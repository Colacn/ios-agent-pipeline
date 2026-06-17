#!/usr/bin/env bash
# 将自研 Agent 工作流框架安装到目标项目（支持多 IDE 落盘路径）。
#
# 用法（在目标业务仓库根目录）：
#   bash /path/to/agent-pipeline/scripts/install-framework-to-project.sh [options] [target...]
#
# target（可多个）：cursor | claude | codex | neutral | all
#   默认：cursor
#
# options:
#   --bundle          安装整包（默认；显式指定时可覆盖先前的 --skill）
#   --skill NAME      仅安装指定 skill + agent + 项目工具脚本（可重复）
#   --skills A,B,C    同 --skill，逗号分隔
#   --with-legacy-bundle  额外复制根 references/scripts/templates（旧 bundle 布局）
#   --with-agents         安装 Cursor 等 IDE 的 Subagent 薄路由（agents/，非 skills.sh 标准）
#   --list-skills     列出可安装的 pipeline skill 并退出
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
# shellcheck source=scripts/lib/skill-install.sh
source "$script_dir/lib/skill-install.sh"

project_root="$(pwd)"
INIT_AGENTS=0
RUN_CHECK=0
DRY_RUN=0
OVERLAYS=()
targets=()
INSTALL_MODE=bundle
SELECTED_SKILLS=()
WITH_LEGACY_BUNDLE=0
WITH_AGENTS=0

usage() {
  cat <<EOF
用法: $0 [options] [target...]

target: cursor | claude | codex | neutral | all  （默认 cursor）

安装范围:
  （默认）            整包：全部自包含 skills + 项目工具脚本
  --skill NAME        单个或多个 skill + 项目工具脚本
  --skills A,B,C      同 --skill，逗号分隔
  --bundle            显式整包（覆盖 --skill）
  --with-agents       额外安装 agents/（Cursor Subagent 薄路由，可选）
  --with-legacy-bundle 额外安装根 references/scripts/templates（兼容旧路径）
  --list-skills       列出 pipeline skill 名称

options:
  --init-agents       从模板生成 AGENTS.md（已存在则跳过）
  --overlay NAME      安装 project-overlays/NAME
  --check             安装后跑 smoke-test.sh
  --dry-run           预览，不写入

单 skill 快捷入口: scripts/install-skill.sh analyze [target...]
EOF
}

if [[ "${1:-}" == "--list-skills" ]]; then
  list_pipeline_skills "$FRAMEWORK_SRC"
  exit 0
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --init-agents) INIT_AGENTS=1; shift ;;
    --check) RUN_CHECK=1; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    --bundle)
      INSTALL_MODE=bundle
      SELECTED_SKILLS=()
      shift
      ;;
    --skill)
      INSTALL_MODE=skills
      validate_skill_name "${2:?--skill 需要名称}" "$FRAMEWORK_SRC"
      append_unique_skill "$2"
      shift 2
      ;;
    --skills)
      INSTALL_MODE=skills
      IFS=',' read -r -a _skill_csv <<<"${2:?--skills 需要逗号分隔列表}"
      for _s in "${_skill_csv[@]}"; do
        _s="${_s// /}"
        [[ -z "$_s" ]] && continue
        validate_skill_name "$_s" "$FRAMEWORK_SRC"
        append_unique_skill "$_s"
      done
      shift 2
      ;;
    --overlay)
      OVERLAYS+=("${2:?--overlay 需要名称}")
      shift 2
      ;;
    --with-legacy-bundle)
      WITH_LEGACY_BUNDLE=1
      shift
      ;;
    --with-agents)
      WITH_AGENTS=1
      shift
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

copy_file() {
  local src="$1" dest="$2"
  [[ -f "$src" ]] || return 0
  log_action "copy: $src -> $dest"
  [[ $DRY_RUN -eq 1 ]] && return 0
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
}

merge_component() {
  local component="$1" dest_root="$2"
  local src_path="$FRAMEWORK_SRC/$component"
  [[ -d "$src_path" ]] || return 0
  copy_tree "$src_path" "$dest_root/$component"
}

install_shared_bundle() {
  local dest_root="$1"
  merge_component references "$dest_root"
  merge_component scripts "$dest_root"
  merge_component templates "$dest_root"
}

install_project_tooling() {
  local dest_root="$1"
  local tooling_scripts=(
    install-framework-to-project.sh
    install-skill.sh
    smoke-test.sh
    export-distribution-layout.sh
    sync-skill-vendor.sh
  )
  local s
  [[ $DRY_RUN -eq 0 ]] && mkdir -p "$dest_root/scripts/lib"
  for s in "${tooling_scripts[@]}"; do
    copy_file "$FRAMEWORK_SRC/scripts/$s" "$dest_root/scripts/$s"
  done
  copy_tree "$FRAMEWORK_SRC/scripts/lib" "$dest_root/scripts/lib"
}

chmod_skill_scripts() {
  local dest_root="$1"
  [[ $DRY_RUN -eq 1 ]] && return 0
  find "$dest_root/skills" -type f -path '*/scripts/*.sh' -exec chmod +x {} + 2>/dev/null || true
  find "$dest_root/skills" -type f -path '*/scripts/lib/*.sh' -exec chmod +x {} + 2>/dev/null || true
}

install_selected_skills() {
  local dest_root="$1"
  local skill agent
  [[ $DRY_RUN -eq 0 ]] && mkdir -p "$dest_root/skills"
  for skill in "${SELECTED_SKILLS[@]}"; do
    copy_tree "$FRAMEWORK_SRC/skills/$skill" "$dest_root/skills/$skill"
    if [[ $WITH_AGENTS -eq 1 ]]; then
      agent="$(skill_to_agent "$skill")"
      [[ $DRY_RUN -eq 0 ]] && mkdir -p "$dest_root/agents"
      copy_file "$FRAMEWORK_SRC/agents/${agent}.md" "$dest_root/agents/${agent}.md"
    fi
  done
}

install_manifest() {
  local dest_root="$1"
  if [[ ! -f "$FRAMEWORK_SRC/framework.manifest.json" ]]; then
    return 0
  fi
  log_action "copy manifest -> $dest_root/framework.manifest.json"
  [[ $DRY_RUN -eq 1 ]] && return 0
  cp "$FRAMEWORK_SRC/framework.manifest.json" "$dest_root/framework.manifest.json"
}

chmod_installed_scripts() {
  local dest_root="$1"
  [[ $DRY_RUN -eq 1 ]] && return 0
  chmod +x "$dest_root/scripts/"*.sh 2>/dev/null || true
  chmod +x "$dest_root/scripts/lib/"*.sh 2>/dev/null || true
  chmod_skill_scripts "$dest_root"
}

install_to_dir() {
  local dest_root="$1"
  local label="$2"
  log_action "==> 安装到 ${label}: ${dest_root}"
  [[ $DRY_RUN -eq 0 ]] && mkdir -p "$dest_root"

  if [[ "$INSTALL_MODE" == "bundle" ]]; then
    log_action "    模式: 整包（全部自包含 skills）"
    merge_component skills "$dest_root"
    if [[ $WITH_AGENTS -eq 1 ]]; then
      log_action "    附加: agents/（Subagent 薄路由）"
      merge_component agents "$dest_root"
    fi
    install_project_tooling "$dest_root"
    if [[ $WITH_LEGACY_BUNDLE -eq 1 ]]; then
      log_action "    附加: legacy bundle（references/scripts/templates）"
      install_shared_bundle "$dest_root"
    fi
  else
    log_action "    模式: 选定 skills（${SELECTED_SKILLS[*]}）+ 项目工具脚本"
    install_selected_skills "$dest_root"
    install_project_tooling "$dest_root"
    if [[ $WITH_LEGACY_BUNDLE -eq 1 ]]; then
      log_action "    附加: legacy bundle（references/scripts/templates）"
      install_shared_bundle "$dest_root"
    fi
  fi

  install_manifest "$dest_root"
  chmod_installed_scripts "$dest_root"
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

  if [[ "$INSTALL_MODE" == "skills" ]]; then
    local skill
    for skill in "${SELECTED_SKILLS[@]}"; do
      copy_tree "$FRAMEWORK_SRC/skills/$skill" "$global_base/$skill"
    done
    return 0
  fi

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
  if [[ "$INSTALL_MODE" == "skills" ]]; then
    echo "安装完成（skill 模式: ${SELECTED_SKILLS[*]}）。验证示例："
    echo "  bash .cursor/skills/analyze/scripts/bootstrap-run.sh smoke-test"
    echo "  bash .cursor/skills/develop/scripts/check-run.sh smoke-test"
    echo "补装其他阶段: npx skills add Colacn/agent-pipeline@plan -y"
    echo "Cursor Subagent: bash .cursor/scripts/install-skill.sh plan --with-agents"
    echo "整包升级: bash .cursor/scripts/install-framework-to-project.sh cursor --bundle"
  else
    echo "安装完成（整包）。验证示例（Cursor 落盘为 .cursor/ 时）："
    echo "  bash .cursor/skills/analyze/scripts/bootstrap-run.sh smoke-test"
    echo "  bash .cursor/skills/develop/scripts/check-run.sh smoke-test"
    echo "  bash .cursor/skills/develop/scripts/reconcile-check.sh <slug>   # develop 出口后"
  fi
  echo "skills.sh 单 skill: npx skills add Colacn/agent-pipeline@analyze -a cursor -y"
fi

if [[ $RUN_CHECK -eq 1 && $DRY_RUN -eq 0 ]]; then
  echo ""
  echo "==> 运行 smoke-test"
  bash "$FRAMEWORK_SRC/scripts/smoke-test.sh"
fi
