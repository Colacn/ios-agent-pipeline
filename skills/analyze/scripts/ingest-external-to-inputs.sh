#!/usr/bin/env bash
# 将本地文件或目录归档到 /runs/<slug>/inputs/（需已存在或先跑 bootstrap-run.sh）。
# 默认复制（保留原始文件）；传 --move 可改为迁移。
# 用法：
#   bash .cursor/scripts/ingest-external-to-inputs.sh <short-slug> <路径1> [路径2 ...]
#   bash .cursor/scripts/ingest-external-to-inputs.sh --move <short-slug> <路径1> [路径2 ...]
# 已位于目标 inputs/ 下的路径会跳过；不存在的路径会警告并跳过。
set -euo pipefail
move_mode=0
if [[ "${1:-}" == "--move" ]]; then
  move_mode=1
  shift || true
fi
slug="${1:-}"
shift || true
if [[ -z "$slug" ]]; then
  echo "用法: $0 [--move] <short-slug> <文件或目录...>" >&2
  exit 1
fi
if [[ $# -eq 0 ]]; then
  echo "用法: $0 [--move] <short-slug> <文件或目录...>" >&2
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/resolve-repo-root.sh
source "$script_dir/lib/resolve-repo-root.sh"
repo_root="$(resolve_repo_root_from_script_dir "$script_dir")"
inputs_dir="$(cd "$repo_root/runs/$slug/inputs" 2>/dev/null && pwd)" || {
  echo "错误: 不存在 $repo_root/runs/$slug/inputs — 请先运行 bootstrap-run.sh $slug" >&2
  exit 1
}

abs_inputs="$(cd "$inputs_dir" && pwd)"

for arg in "$@"; do
  if [[ ! -e "$arg" ]]; then
    echo "跳过（不存在）: $arg" >&2
    continue
  fi
  target="$(cd "$(dirname "$arg")" && pwd)/$(basename "$arg")"
  case "$target" in
    "$abs_inputs"|"$abs_inputs"/*)
      echo "已在 inputs 内，跳过: $arg"
      continue
      ;;
  esac
  dest="$abs_inputs/$(basename "$arg")"
  if [[ -e "$dest" ]]; then
    echo "跳过（目标已存在）: $(basename "$arg")" >&2
    continue
  fi
  cp -R "$target" "$abs_inputs/"
  if [[ $move_mode -eq 1 ]]; then
    rm -rf "$target"
    echo "已迁移到 inputs: $(basename "$arg")"
  else
    echo "已复制到 inputs: $(basename "$arg")"
  fi
done
