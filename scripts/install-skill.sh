#!/usr/bin/env bash
# 安装一个或多个 pipeline skill（skills.sh 风格）+ 最小共享 bundle。
#
# 用法（在目标业务仓库根目录）：
#   bash /path/to/agent-pipeline/scripts/install-skill.sh analyze [cursor]
#   bash /path/to/agent-pipeline/scripts/install-skill.sh analyze plan develop claude --init-agents
#   bash /path/to/agent-pipeline/scripts/install-skill.sh --list
#
# 整包（全部 skills + agents）请用 install-framework-to-project.sh 或 --bundle。
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
framework_root="$(cd "$script_dir/.." && pwd)"
# shellcheck source=scripts/lib/skill-install.sh
source "$script_dir/lib/skill-install.sh"

if [[ "${1:-}" == "--list" || "${1:-}" == "-l" ]]; then
  list_pipeline_skills "$framework_root"
  exit 0
fi

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  cat <<EOF
用法: $0 SKILL [SKILL...] [options] [target...]

SKILL: analyze | plan | review | develop | test（可多个）

target: cursor | claude | codex | neutral | all  （默认 cursor）

options（转发至 install-framework-to-project.sh）:
  --init-agents       从模板生成 AGENTS.md
  --overlay NAME      安装 project-overlays/NAME
  --check             安装后跑 smoke-test.sh
  --dry-run           预览，不写入
  --bundle            安装整包（全部 skills + rules），忽略前面列出的 SKILL

示例:
  $0 analyze cursor
  $0 analyze plan --init-agents
  INSTALL_GLOBAL=1 $0 develop claude

整包: bash $script_dir/install-framework-to-project.sh cursor
EOF
  exit 0
fi

skills=()
forward=()
INSTALL_BUNDLE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --bundle)
      INSTALL_BUNDLE=1
      forward+=("$1")
      shift
      ;;
    --init-agents | --check | --dry-run)
      forward+=("$1")
      shift
      ;;
    --overlay)
      forward+=("$1" "${2:?--overlay 需要名称}")
      shift 2
      ;;
    --with-legacy-bundle)
      forward+=("$1")
      shift
      ;;
    -h | --help)
      exec bash "$script_dir/install-skill.sh" --help
      ;;
    cursor | claude | codex | neutral | all)
      forward+=("$1")
      shift
      ;;
    --*)
      echo "ERROR: 未知参数: $1" >&2
      exit 1
      ;;
    *)
      if skill_exists "$1" "$framework_root"; then
        skills+=("$1")
        shift
      else
        echo "ERROR: 未知 skill 或参数: $1" >&2
        echo "可用: $(list_pipeline_skills "$framework_root" | tr '\n' ' ')" >&2
        exit 1
      fi
      ;;
  esac
done

if [[ $INSTALL_BUNDLE -eq 0 && ${#skills[@]} -eq 0 ]]; then
  echo "ERROR: 至少指定一个 skill，或使用 --bundle 安装整包" >&2
  exit 1
fi

args=()
if [[ $INSTALL_BUNDLE -eq 0 ]]; then
  for s in "${skills[@]}"; do
    args+=(--skill "$s")
  done
fi

if [[ ${#forward[@]} -eq 0 ]]; then
  forward=(cursor)
fi

exec bash "$script_dir/install-framework-to-project.sh" "${args[@]}" "${forward[@]}"
