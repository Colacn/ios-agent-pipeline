#!/usr/bin/env bash
# 校验 runs/<short-slug>/outputs/ 产物命名与流水线证据基线。
# 权威实现：本文件。
#
# 用法（在仓库任意目录）：
#   bash .cursor/scripts/check-run.sh <short-slug>
#
# 退出码：0=通过（可有 warning）；1=存在旧命名等硬错误。
set -euo pipefail

slug="${1:-}"
if [[ -z "$slug" ]]; then
  echo "用法: bash .cursor/scripts/check-run.sh <short-slug>" >&2
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/../.." && pwd)"
outputs_dir="$repo_root/runs/$slug/outputs"

errors=0
warnings=0

err() {
  echo "ERROR: $*" >&2
  errors=$((errors + 1))
}

warn() {
  echo "WARNING: $*" >&2
  warnings=$((warnings + 1))
}

if [[ ! -d "$outputs_dir" ]]; then
  err "目录不存在: runs/$slug/outputs/"
  echo "check-run: $errors 个错误" >&2
  exit 1
fi

# --- 旧命名检测（硬错误）---
check_old_name() {
  local old="$1" new="$2"
  if [[ -f "$outputs_dir/$old" ]]; then
    err "检测到旧命名 runs/$slug/outputs/$old → 应重命名为 $new"
  fi
}

check_old_name analyst.requirements.md analyze.requirements.md
check_old_name planner.solution.md plan.solution.md
check_old_name planner.task-breakdown.md plan.task-breakdown.md
check_old_name reviewer.gate.md review.gate.md
check_old_name tester.report.md test.report.md
check_old_name tester.ledger.md test.ledger.md

while IFS= read -r f; do
  base="$(basename "$f")"
  if [[ "$base" =~ ^(analyst|planner|reviewer|tester)\. ]]; then
    err "检测到旧命名 runs/$slug/outputs/$base（outputs 须使用 Skill 名前缀）"
  fi
done < <(find "$outputs_dir" -maxdepth 1 -type f -name '*.md' 2>/dev/null || true)

# --- 白名单（未知 md 仅 warning）---
allowed=(
  analyze.requirements.md
  plan.solution.md
  plan.task-breakdown.md
  review.gate.md
  developer.implementation.md
  test.report.md
  test.ledger.md
)

is_allowed() {
  local name="$1"
  local a
  for a in "${allowed[@]}"; do
    [[ "$name" == "$a" ]] && return 0
  done
  return 1
}

while IFS= read -r f; do
  base="$(basename "$f")"
  [[ "$base" == *.md ]] || continue
  if ! is_allowed "$base"; then
    warn "runs/$slug/outputs/$base 不在白名单内（见 runs-archive.md）"
  fi
done < <(find "$outputs_dir" -maxdepth 1 -type f 2>/dev/null || true)

# --- 流水线必选产物（缺失 warning，允许历史样本不完整）---
for req in analyze.requirements.md plan.solution.md review.gate.md developer.implementation.md; do
  if [[ ! -f "$outputs_dir/$req" ]]; then
    warn "缺少 runs/$slug/outputs/${req}（走完全流水线时为必选）"
  fi
done

# --- plan 过时标记 ---
plan_file="$outputs_dir/plan.solution.md"
if [[ -f "$plan_file" ]]; then
  if grep -qE '待实现|T3 阻塞|待 Toast' "$plan_file" 2>/dev/null; then
    warn "plan.solution.md 含可能过时标记（待实现 / T3 阻塞 / 待 Toast）"
  fi
fi

# --- developer.implementation.md §8 reconcile ---
impl_file="$outputs_dir/developer.implementation.md"
if [[ -f "$impl_file" ]]; then
  section="$(awk '/^## 8\. reconcile-docs/{flag=1;next} /^## [0-9]+\./{if(flag) exit} flag' "$impl_file")"
  if printf '%s\n' "$section" | grep -q '^- \[ \]'; then
    warn "developer.implementation.md §8 reconcile 尚有未勾选项"
  fi
fi

# --- 汇总 ---
if [[ $errors -gt 0 ]]; then
  echo "check-run: $errors 个错误, $warnings 个警告" >&2
  exit 1
fi

if [[ $warnings -gt 0 ]]; then
  echo "check-run: 通过（$warnings 个警告）"
else
  echo "check-run: 通过"
fi
exit 0
