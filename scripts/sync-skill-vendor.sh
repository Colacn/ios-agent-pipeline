#!/usr/bin/env bash
# 将共享 canonical 内容同步到各 skill 目录，使单 skill 符合 Agent Skills 自包含规范。
# 维护流程：改 references/workflow/、scripts/、templates/vendor/ 后执行本脚本。
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$script_dir/.." && pwd)"

ALL_SKILLS=(analyze plan review develop test)

copy_file() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
}

copy_tree() {
  local src="$1" dest="$2"
  mkdir -p "$dest"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a "$src/" "$dest/"
  else
    cp -R "$src/." "$dest/"
  fi
}

for skill in "${ALL_SKILLS[@]}"; do
  base="$root/skills/$skill"
  mkdir -p "$base/scripts/lib" "$base/references" "$base/assets"

  copy_file "$root/references/workflow/pipeline.md" "$base/references/workflow-pipeline.md"
  copy_file "$root/scripts/bootstrap-run.sh" "$base/scripts/bootstrap-run.sh"
  copy_file "$root/scripts/lib/resolve-repo-root.sh" "$base/scripts/lib/resolve-repo-root.sh"
  copy_file "$root/templates/vendor/collaboration-discipline.md" "$base/references/collaboration-discipline.md"
  copy_file "$root/templates/vendor/layering-appendix-a.md" "$base/references/layering-appendix-a.md"
  copy_file "$root/templates/vendor/path-conventions-skill.md" "$base/references/path-conventions.md"
done

# analyze
a="$root/skills/analyze"
copy_file "$root/references/workflow/grading.md" "$a/references/workflow-grading.md"
copy_file "$root/references/workflow/light-task.md" "$a/references/workflow-light-task.md"
copy_file "$root/references/guide/skill-subagent.md" "$a/references/guide-skill-subagent.md"
copy_file "$root/scripts/ingest-external-to-inputs.sh" "$a/scripts/ingest-external-to-inputs.sh"
copy_file "$root/scripts/record-urls-to-inputs.sh" "$a/scripts/record-urls-to-inputs.sh"

# plan
p="$root/skills/plan"
copy_file "$root/references/guide/layering.md" "$p/references/guide-layering.md"
copy_tree "$root/templates/overlay" "$p/assets/overlay"

# review — playbook refs only

# develop
d="$root/skills/develop"
copy_file "$root/references/rules/check-run-patterns.txt" "$d/references/check-run-patterns.txt"
copy_file "$root/templates/developer-implementation-template.md" "$d/assets/developer-implementation-template.md"
copy_file "$root/scripts/reconcile-check.sh" "$d/scripts/reconcile-check.sh"
copy_file "$root/scripts/check-run.sh" "$d/scripts/check-run.sh"
copy_tree "$root/templates/overlay" "$d/assets/overlay"

# test
t="$root/skills/test"
copy_file "$root/scripts/check-run.sh" "$t/scripts/check-run.sh"

chmod +x "$root/skills/"*/scripts/*.sh 2>/dev/null || true
chmod +x "$root/skills/"*/scripts/lib/*.sh 2>/dev/null || true

echo "sync-skill-vendor: 已同步 ${#ALL_SKILLS[@]} 个 skill 的自包含 vendor 内容"
