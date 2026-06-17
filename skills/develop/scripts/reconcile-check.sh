#!/usr/bin/env bash
# 对照 developer.implementation.md 与 git diff，校验 reconcile 可追溯性。
#
# 用法：
#   bash .cursor/scripts/reconcile-check.sh <short-slug>
#
# 退出码：0=通过（可有 warning）；1=硬错误（非 git 仓、缺 implementation 等）。
set -euo pipefail

slug="${1:-}"
if [[ -z "$slug" ]]; then
  echo "用法: bash reconcile-check.sh <short-slug>" >&2
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/resolve-repo-root.sh
source "$script_dir/lib/resolve-repo-root.sh"
repo_root="$(resolve_repo_root_from_script_dir "$script_dir")"

impl_file="$repo_root/runs/$slug/outputs/developer.implementation.md"
errors=0
warnings=0

err() { echo "ERROR: $*" >&2; errors=$((errors + 1)); }
warn() { echo "WARNING: $*" >&2; warnings=$((warnings + 1)); }

if ! git -C "$repo_root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  err "不在 git 仓库内: $repo_root"
  exit 1
fi

if [[ ! -f "$impl_file" ]]; then
  err "缺少 $impl_file"
  exit 1
fi

# §8 reconcile 复选框
section8="$(awk '/^## 8\. reconcile-docs/{flag=1;next} /^## [0-9]+\./{if(flag) exit} flag' "$impl_file")"
if printf '%s\n' "$section8" | grep -q '^- \[ \]'; then
  warn "developer.implementation.md §8 reconcile 尚有未勾选项"
fi

# §4 改动清单 vs git diff
impl_files=()
while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  impl_files+=("$line")
done < <(
  awk '
    /^## 4\. 代码改动清单/{flag=1;next}
    /^## [0-9]+\./{if(flag) exit}
    flag && /^\|/ && !/^\|[[:space:]]*[-|]+/ && !/^\|[[:space:]]*文件/ {
      gsub(/^[[:space:]]*\|[[:space:]]*/, "", $0)
      split($0, a, "|")
      f=a[1]
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", f)
      if (f != "" && f != "文件") print f
    }
  ' "$impl_file"
)

diff_files=()
while IFS= read -r f; do
  [[ -n "$f" ]] && diff_files+=("$f")
done < <(
  {
    git -C "$repo_root" diff --name-only
    git -C "$repo_root" diff --cached --name-only
  } | sort -u | grep -v '^$' || true
)

if [[ ${#diff_files[@]} -eq 0 && ${#impl_files[@]} -eq 0 ]]; then
  warn "git diff 与 implementation §4 均为空（无代码改动或未记录）"
elif [[ ${#impl_files[@]} -eq 0 && ${#diff_files[@]} -gt 0 ]]; then
  warn "git diff 有 ${#diff_files[@]} 个文件，但 implementation §4 未列出改动文件"
else
  for df in "${diff_files[@]}"; do
    found=0
    for imf in "${impl_files[@]}"; do
      [[ "$df" == "$imf" || "$df" == *"$imf"* || "$imf" == *"$df"* ]] && found=1 && break
    done
    if [[ $found -eq 0 ]]; then
      warn "git diff 含 $df，但不在 implementation §4 改动清单中"
    fi
  done
  for imf in "${impl_files[@]}"; do
    found=0
    for df in "${diff_files[@]}"; do
      [[ "$df" == "$imf" || "$df" == *"$imf"* || "$imf" == *"$df"* ]] && found=1 && break
    done
    if [[ $found -eq 0 ]]; then
      warn "implementation §4 列出 $imf，但当前 git diff 未包含"
    fi
  done
fi

if [[ $errors -gt 0 ]]; then
  echo "reconcile-check: $errors 个错误, $warnings 个警告" >&2
  exit 1
fi

if [[ $warnings -gt 0 ]]; then
  echo "reconcile-check: 通过（$warnings 个警告）"
else
  echo "reconcile-check: 通过"
fi
