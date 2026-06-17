#!/usr/bin/env bash
# 解析业务仓库根目录（含 runs/ 的 git 项目根）。
#
# 优先级：
#   1. 当前工作目录所在的 git 仓库根（npx skills 全局安装、仅 skill 目录时）
#   2. 自 script_dir 向上查找 framework.manifest.json（.cursor/ 等整包安装）
#   3. 自 script_dir 向上查找 .git（兜底）
resolve_repo_root_from_script_dir() {
  local script_dir="$1"

  if git -C "${PWD}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C "${PWD}" rev-parse --show-toplevel
    return 0
  fi

  local dir="$script_dir"
  local framework_dir=""

  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/framework.manifest.json" ]]; then
      framework_dir="$dir"
      break
    fi
    dir="$(dirname "$dir")"
  done

  if [[ -n "$framework_dir" ]]; then
    local fw_base fw_parent fw_parent_base
    fw_base="$(basename "$framework_dir")"
    fw_parent="$(dirname "$framework_dir")"
    fw_parent_base="$(basename "$fw_parent")"

    case "$fw_base" in
      .cursor | .claude)
        printf '%s' "$fw_parent"
        return 0
        ;;
      agent-workflow)
        if [[ "$fw_parent_base" == ".codex" ]]; then
          printf '%s' "$(dirname "$fw_parent")"
        else
          printf '%s' "$fw_parent"
        fi
        return 0
        ;;
      *)
        printf '%s' "$framework_dir"
        return 0
        ;;
    esac
  fi

  dir="$script_dir"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/.git" ]]; then
      printf '%s' "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done

  echo "ERROR: 未找到 git 仓库根或 framework.manifest.json（自 ${script_dir} 向上检索；请在业务仓库根目录执行）" >&2
  return 1
}
