#!/usr/bin/env bash
# skill 安装辅助：名称校验、agent 映射、可用 skill 列表。
# 由 install-framework-to-project.sh / install-skill.sh source。
set -euo pipefail

skill_to_agent() {
  case "$1" in
    analyze) printf '%s' analyst ;;
    plan) printf '%s' planner ;;
    review) printf '%s' reviewer ;;
    develop) printf '%s' developer ;;
    test) printf '%s' tester ;;
    *) return 1 ;;
  esac
}

skill_exists() {
  local name="$1" src_root="$2"
  [[ -f "$src_root/skills/$name/SKILL.md" ]]
}

list_pipeline_skills() {
  local src_root="$1"
  local d name
  for d in "$src_root/skills"/*; do
    [[ -d "$d" ]] || continue
    name="$(basename "$d")"
    [[ -f "$d/SKILL.md" ]] || continue
    printf '%s\n' "$name"
  done
}

validate_skill_name() {
  local name="$1" src_root="$2"
  if ! skill_exists "$name" "$src_root"; then
    echo "ERROR: 未知 skill '$name'。可用: $(list_pipeline_skills "$src_root" | tr '\n' ' ')" >&2
    return 1
  fi
  if ! skill_to_agent "$name" >/dev/null; then
    echo "ERROR: skill '$name' 缺少 agent 映射" >&2
    return 1
  fi
}

skill_in_list() {
  local needle="$1"
  shift
  local s
  for s in "$@"; do
    [[ "$s" == "$needle" ]] && return 0
  done
  return 1
}

append_unique_skill() {
  local name="$1"
  skill_in_list "$name" "${SELECTED_SKILLS[@]+"${SELECTED_SKILLS[@]}"}" && return 0
  SELECTED_SKILLS+=("$name")
}
