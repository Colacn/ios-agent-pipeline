#!/usr/bin/env bash
# 从 scripts/ 或 .cursor/scripts/ 等位置解析业务仓库根目录（含 runs/ 的 git 项目根）。
# 用法（在其它脚本中）：
#   script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#   # shellcheck source=lib/resolve-repo-root.sh
#   source "$script_dir/lib/resolve-repo-root.sh"
#   repo_root="$(resolve_repo_root_from_script_dir "$script_dir")"
resolve_repo_root_from_script_dir() {
  local script_dir="$1"
  local dir="$script_dir"
  local framework_dir=""

  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/framework.manifest.json" ]]; then
      framework_dir="$dir"
      break
    fi
    dir="$(dirname "$dir")"
  done

  if [[ -z "$framework_dir" ]]; then
    echo "ERROR: 未找到 framework.manifest.json（自 ${script_dir} 向上检索）" >&2
    return 1
  fi

  local fw_base fw_parent fw_parent_base
  fw_base="$(basename "$framework_dir")"
  fw_parent="$(dirname "$framework_dir")"
  fw_parent_base="$(basename "$fw_parent")"

  case "$fw_base" in
    .cursor | .claude)
      printf '%s' "$fw_parent"
      ;;
    agent-workflow)
      if [[ "$fw_parent_base" == ".codex" ]]; then
        printf '%s' "$(dirname "$fw_parent")"
      else
        printf '%s' "$fw_parent"
      fi
      ;;
    *)
      printf '%s' "$framework_dir"
      ;;
  esac
}
