#!/usr/bin/env bash
# 将自研 Agent 工作流框架安装到目标项目（支持多 IDE 落盘路径）。
#
# 用法（在目标业务仓库根目录）：
#   bash /path/to/ios-agent-pipeline/scripts/install-framework-to-project.sh [options] [target...]
#
# target（可多个）：cursor | claude | codex | neutral | all
#   默认：cursor
#
# options:
#   --init-agents     若不存在则从 templates/project/AGENTS.md.example 生成 AGENTS.md
#   --overlay NAME    安装 project-overlays/NAME 到业务仓 project-overlays/NAME
#   --check           安装后执行 scripts/smoke-test.sh
#   --dry-run         仅打印将执行的操作，不写入
#
# 环境变量：
#   FRAMEWORK_SRC     框架源目录；默认=本脚本上级目录
#   OVERLAY_SRC       overlay 父目录（含各 <name>/ 子目录）；默认=业务仓 project-overlays/
#   INSTALL_GLOBAL=1  对 claude/codex 额外复制 skills 到用户全局 skills 目录
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
default_src="$(cd "$script_dir/.." && pwd)"
FRAMEWORK_SRC="${FRAMEWORK_SRC:-$default_src}"

project_root="$(pwd)"
INIT_AGENTS=0
RUN_CHECK=0
DRY_RUN=0
OVERLAYS=()
targets=()

usage() {
  cat <<EOF
用法: $0 [options] [target...]

target: cursor | claude | codex | neutral | all  （默认 cursor）

options:
  --init-agents       从模板生成 AGENTS.md（已存在则跳过）
  --overlay NAME      安装 project-overlays/NAME
  --check             安装后跑 smoke-test.sh
  --dry-run           预览，不写入
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --init-agents) INIT_AGENTS=1; shift ;;
    --check) RUN_CHECK=1; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    --overlay)
      OVERLAYS+=("${2:?--overlay 需要名称}")
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    cursor | claude | codex | neutral | all)
      targets+=("$1")
      shift
      ;;
    *)
      echo "ERROR: 未知参数: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ ${#targets[@]} -eq 0 ]]; then
  targets=(cursor)
fi
if [[ "${targets[0]:-}" == "all" ]]; then
  targets=(cursor claude codex neutral)
fi

log_action() {
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "[dry-run] $*"
  else
    echo "$@"
  fi
}

copy_tree() {
  local src="$1" dest="$2"
  [[ -d "$src" ]] || return 0
  log_action "copy: $src -> $dest"
  [[ $DRY_RUN -eq 1 ]] && return 0
  mkdir -p "$dest"
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
  log_action "==> 安装到 ${label}: ${dest_root}"
  [[ $DRY_RUN -eq 0 ]] && mkdir -p "$dest_root"
  for c in skills agents references scripts templates rules; do
    merge_component "$c" "$dest_root"
  done
  if [[ -f "$FRAMEWORK_SRC/framework.manifest.json" ]]; then
    log_action "copy manifest -> $dest_root/framework.manifest.json"
    [[ $DRY_RUN -eq 0 ]] && cp "$FRAMEWORK_SRC/framework.manifest.json" "$dest_root/framework.manifest.json"
  fi
  if [[ $DRY_RUN -eq 0 ]]; then
    chmod +x "$dest_root/scripts/"*.sh 2>/dev/null || true
    chmod +x "$dest_root/scripts/lib/"*.sh 2>/dev/null || true
  fi
}

resolve_overlay_src() {
  local name="$1"
  local base="${OVERLAY_SRC:-$project_root/project-overlays}"
  if [[ -d "$base/$name" ]]; then
    printf '%s' "$base/$name"
    return 0
  fi
  if [[ -d "$FRAMEWORK_SRC/templates/overlay/$name" ]]; then
    printf '%s' "$FRAMEWORK_SRC/templates/overlay/$name"
    return 0
  fi
  return 1
}

install_overlay() {
  local name="$1"
  local src
  local dest="$project_root/project-overlays/$name"
  if ! src="$(resolve_overlay_src "$name")"; then
    echo "ERROR: 找不到 overlay '$name'。" >&2
    echo "  在业务仓维护 project-overlays/$name/，或设置 OVERLAY_SRC 指向 overlay 父目录。" >&2
    echo "  框架仅提供无业务语义的 templates/overlay/sample/ 脚手架。" >&2
    exit 1
  fi
  log_action "==> overlay: $name ($src -> $dest)"
  copy_tree "$src" "$dest"
}

init_agents_md() {
  local guide="$project_root/AGENTS.md"
  local template="$FRAMEWORK_SRC/templates/project/AGENTS.md.example"
  if [[ -f "$guide" ]]; then
    log_action "hint: 已存在 AGENTS.md，跳过 --init-agents"
    return 0
  fi
  if [[ ! -f "$template" ]]; then
    echo "ERROR: 缺少模板 $template" >&2
    exit 1
  fi
  log_action "==> 生成 AGENTS.md 自模板"
  [[ $DRY_RUN -eq 0 ]] && cp "$template" "$guide"
  for name in "${OVERLAYS[@]+"${OVERLAYS[@]}"}"; do
    local fragment=""
    if src="$(resolve_overlay_src "$name" 2>/dev/null)" && [[ -f "$src/AGENTS.fragment.md" ]]; then
      fragment="$src/AGENTS.fragment.md"
    fi
    if [[ -n "$fragment" ]]; then
      log_action "==> 追加 overlay 片段: $name"
      if [[ $DRY_RUN -eq 0 ]]; then
        {
          echo ""
          cat "$fragment"
        } >> "$guide"
      fi
    fi
  done
}

expand_home() {
  local p="$1"
  if [[ "$p" == *CODEX_HOME* ]]; then
    local codex_home="${CODEX_HOME:-$HOME/.codex}"
    printf '%s/skills' "$codex_home"
  elif [[ "${p:0:2}" == "~/" ]]; then
    printf '%s/%s' "$HOME" "${p:2}"
  else
    printf '%s' "$p"
  fi
}

install_global_skills() {
  local global_base="$1"
  local label="$2"
  log_action "==> 全局 skills (${label}): ${global_base}"
  [[ $DRY_RUN -eq 1 ]] && return 0
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
    log_action "hint: 建议 --init-agents 或手动创建 ${guide}"
  else
    log_action "hint: 未修改已有 ${guide}"
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
      echo "ERROR: 未知 target: $t" >&2
      exit 1
      ;;
  esac
done

for name in "${OVERLAYS[@]+"${OVERLAYS[@]}"}"; do
  install_overlay "$name"
done

if [[ $INIT_AGENTS -eq 1 ]]; then
  init_agents_md
fi

if [[ $DRY_RUN -eq 0 ]]; then
  echo ""
  echo "安装完成。验证示例（Cursor 落盘为 .cursor/ 时）："
  echo "  bash .cursor/scripts/bootstrap-run.sh smoke-test"
  echo "  bash .cursor/scripts/check-run.sh smoke-test"
  echo "  bash .cursor/scripts/reconcile-check.sh <slug>   # develop 出口后"
  echo "详见 references/guide/cross-platform-deployment.md"
fi

if [[ $RUN_CHECK -eq 1 && $DRY_RUN -eq 0 ]]; then
  echo ""
  echo "==> 运行 smoke-test"
  bash "$FRAMEWORK_SRC/scripts/smoke-test.sh"
fi
