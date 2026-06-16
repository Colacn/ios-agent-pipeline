#!/usr/bin/env bash
# 将自研 Agent 工作流框架安装到目标项目（支持多 IDE 落盘路径）。
#
# 用法（在目标业务仓库根目录）：
#   bash /path/to/framework/.cursor/scripts/install-framework-to-project.sh [target...]
#
# target（可多个）：cursor | claude | codex | neutral | all
#   默认：cursor
#
# 环境变量：
#   FRAMEWORK_SRC  框架源目录（含 skills/agents/...）；默认=本脚本上级目录（.cursor）
#   INSTALL_GLOBAL=1  对 claude/codex 额外复制 skills 到用户全局 skills 目录
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
default_src="$(cd "$script_dir/.." && pwd)"
FRAMEWORK_SRC="${FRAMEWORK_SRC:-$default_src}"

project_root="$(pwd)"
targets=("$@")
if [[ ${#targets[@]} -eq 0 ]]; then
  targets=(cursor)
fi
if [[ "${targets[0]:-}" == "all" ]]; then
  targets=(cursor claude codex neutral)
fi

copy_tree() {
  local src="$1" dest="$2"
  [[ -d "$src" ]] || return 0
  mkdir -p "$dest"
  # rsync 优先；无 rsync 时 cp -R
  if command -v rsync >/dev/null 2>&1; then
    rsync -a "$src/" "$dest/"
  else
    cp -R "$src/." "$dest/"
  fi
}

merge_component() {
  local component="$1" dest_root="$2"
  local src_path="$FRAMEWORK_SRC/$component"
  [[ -d "$src_path" ]] || return 0
  copy_tree "$src_path" "$dest_root/$component"
}

install_to_dir() {
  local dest_root="$1"
  local label="$2"
  echo "==> 安装到 ${label}: ${dest_root}"
  mkdir -p "$dest_root"
  for c in skills agents references scripts templates rules; do
    merge_component "$c" "$dest_root"
  done
  # 复制 manifest 便于校验版本
  if [[ -f "$FRAMEWORK_SRC/framework.manifest.json" ]]; then
    cp "$FRAMEWORK_SRC/framework.manifest.json" "$dest_root/framework.manifest.json"
  fi
  chmod +x "$dest_root/scripts/"*.sh 2>/dev/null || true
}

expand_home() {
  local p="$1"
  if [[ "$p" == "~/"* ]]; then
    printf '%s' "${HOME}${p#\~}"
  elif [[ "$p" == *CODEX_HOME* ]]; then
    local codex_home="${CODEX_HOME:-$HOME/.codex}"
    printf '%s/skills' "$codex_home"
  else
    printf '%s' "$p"
  fi
}

install_global_skills() {
  local global_base="$1"
  local label="$2"
  echo "==> 全局 skills (${label}): ${global_base}"
  mkdir -p "$global_base"
  local skill_dir
  for skill_dir in "$FRAMEWORK_SRC/skills"/*; do
    [[ -d "$skill_dir" && -f "$skill_dir/SKILL.md" ]] || continue
    local name
    name="$(basename "$skill_dir")"
    copy_tree "$skill_dir" "$global_base/$name"
  done
}

warn_agents_guide() {
  local guide="$1"
  if [[ ! -f "$project_root/$guide" ]]; then
    echo "hint: 建议在项目根创建 ${guide}，链到 ${1%%/*} 下 references/workflow/pipeline.md"
  else
    echo "hint: 未修改已有 ${guide}；请自行合并流水线路由说明"
  fi
}

for t in "${targets[@]}"; do
  case "$t" in
    cursor)
      install_to_dir "$project_root/.cursor" "Cursor"
      warn_agents_guide "AGENTS.md"
      ;;
    claude)
      install_to_dir "$project_root/.claude" "Claude Code"
      warn_agents_guide "CLAUDE.md"
      if [[ "${INSTALL_GLOBAL:-0}" == "1" ]]; then
        install_global_skills "$(expand_home ~/.claude/skills)" "Claude Code"
      fi
      ;;
    codex)
      install_to_dir "$project_root/.codex/agent-workflow" "Codex (project bundle)"
      warn_agents_guide "AGENTS.md"
      if [[ "${INSTALL_GLOBAL:-0}" == "1" ]]; then
        install_global_skills "$(expand_home ~/.codex/skills)" "Codex"
      fi
      ;;
    neutral)
      install_to_dir "$project_root/agent-workflow" "neutral (IDE-agnostic)"
      warn_agents_guide "AGENTS.md"
      ;;
    *)
      echo "ERROR: 未知 target: $t（可用: cursor claude codex neutral all）" >&2
      exit 1
      ;;
  esac
done

echo ""
echo "安装完成。验证（按实际落盘路径调整）:"
echo "  bash .cursor/scripts/bootstrap-run.sh smoke-test"
echo "  bash .cursor/scripts/check-run.sh smoke-test"
echo "详见 .cursor/references/guide/cross-platform-deployment.md"
