#!/usr/bin/env bash
# 将 URL 追加到 /runs/<slug>/inputs/source-urls.md（无则创建目录与文件）。
# 用法：bash .cursor/scripts/record-urls-to-inputs.sh <short-slug> <url> [url ...]
set -euo pipefail
slug="${1:-}"
shift || true
if [[ -z "$slug" ]]; then
  echo "用法: $0 <short-slug> <url> [url...]" >&2
  exit 1
fi
if [[ $# -eq 0 ]]; then
  echo "用法: $0 <short-slug> <url> [url...]" >&2
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/../.." && pwd)"
inputs_dir="$repo_root/runs/$slug/inputs"
mkdir -p "$inputs_dir"
out="$inputs_dir/source-urls.md"
ts="$(date "+%Y-%m-%d %H:%M:%S %z" 2>/dev/null || date)"

{
  echo "## 外部链接摘录"
  echo ""
  echo "**记录时间**: $ts"
  echo ""
  for u in "$@"; do
    echo "- $u"
  done
  echo ""
} >> "$out"

echo "已追加到 $out"
