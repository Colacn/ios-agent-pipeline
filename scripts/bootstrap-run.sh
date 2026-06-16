#!/usr/bin/env bash
# 在仓库中创建 /runs/<short-slug>/{inputs,outputs}；可选一次性 ingest 外部文件到 inputs/。
# 权威实现：本文件。
#
# 用法（在仓库任意目录）：
#   bash .cursor/scripts/bootstrap-run.sh <short-slug>
#   bash .cursor/scripts/bootstrap-run.sh --from-branch
#   bash .cursor/scripts/bootstrap-run.sh <short-slug> [file1 file2 ...]
#   bash .cursor/scripts/bootstrap-run.sh --from-branch [file1 file2 ...]
#
# 说明：slug 之后的尾参数视为"随需求一起给出的本地文件/目录路径"，建完工区后会自动调用
#       ingest-external-to-inputs.sh 将其归档到 inputs/（默认复制，保留原件）。一步到位，避免"建完目录忘了 ingest"。
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/../.." && pwd)"

current_branch() {
  git -C "$repo_root" rev-parse --abbrev-ref HEAD 2>/dev/null || true
}

# 从分支名派生 slug：取最后一个 '/' 后的片段，转小写，_/空格 -> '-'，仅保留 [a-z0-9-]。
branch_slug() {
  local branch="${1:-}"
  [[ -z "$branch" || "$branch" == "HEAD" ]] && return 0
  local last="${branch##*/}"
  printf '%s' "$last" \
    | tr '[:upper:]' '[:lower:]' \
    | tr '_ ' '--' \
    | sed -e 's/[^a-z0-9-]//g' -e 's/--*/-/g' -e 's/^-//' -e 's/-$//'
}

branch="$(current_branch)"
derived="$(branch_slug "$branch")"

first="${1:-}"
shift || true

if [[ "$first" == "--from-branch" ]]; then
  if [[ -z "$derived" ]]; then
    echo "错误: 无法从当前分支派生 slug（分支=${branch:-<未识别>}）。请显式传入 <short-slug>。" >&2
    exit 1
  fi
  slug="$derived"
  echo "使用分支派生 slug: ${slug}（分支=${branch}）"
else
  slug="$first"
fi

if [[ -z "$slug" || "$slug" == -* ]]; then
  {
    echo "用法: $0 <short-slug> [file1 file2 ...]"
    echo "      $0 --from-branch [file1 file2 ...]"
    echo
    echo "当前分支:         ${branch:-<未在 git 仓库或处于游离 HEAD>}"
    echo "分支派生 slug:    ${derived:-<无法从分支派生>}"
    echo
    echo "约定:"
    echo "  - 分支语义与本需求一致 -> 可直接 '--from-branch'，或把 '${derived:-<branch-slug>}' 作为参数传入。"
    echo "  - 分支语义与本需求不一致 -> 按需求语义自造 slug（与用户确认后）传入。"
    echo "  - 若随需求一并给出本地文件路径，作为尾参数一次性 ingest 到 inputs/，不要挂 TODO。"
    echo
    echo "示例:"
    echo "  $0 chat-with-myself"
    echo "  $0 --from-branch 文件专题二期-技术方案.md docs/screenshot.png"
  } >&2
  exit 1
fi

run_dir="$repo_root/runs/$slug"
mkdir -p "$run_dir/inputs" "$run_dir/outputs"
echo "已创建: $run_dir/inputs"
echo "        $run_dir/outputs"

if [[ -n "$derived" && "$derived" != "$slug" ]]; then
  echo "提示: 当前分支=${branch}, 派生 slug=${derived}, 与传入 slug(${slug}) 不一致; 请确认系 '需求语义 != 分支语义' 而非笔误。" >&2
fi

if [[ $# -gt 0 ]]; then
  echo "--- 开始 ingest 外部依据到 inputs/ ---"
  "$script_dir/ingest-external-to-inputs.sh" "$slug" "$@"
  echo "--- ingest 完成 ---"
fi

echo "下一步: 其它外部依据放入 inputs/ 或写入 source-urls.md；各角色落盘写入 outputs/。"
