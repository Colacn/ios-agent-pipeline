#!/usr/bin/env bash
# 按阶段将 canonical 内容同步到各 skill（最小 vendoring，符合 Agent Skills 单能力自包含）。
# 维护：改 references/workflow/、scripts/、templates/vendor/ 后执行本脚本。
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$script_dir/.." && pwd)"

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

install_common_scripts() {
  local base="$1"
  mkdir -p "$base/scripts/lib"
  copy_file "$root/scripts/bootstrap-run.sh" "$base/scripts/bootstrap-run.sh"
  copy_file "$root/scripts/lib/resolve-repo-root.sh" "$base/scripts/lib/resolve-repo-root.sh"
}

# --- analyze：路由 + 预处理 ---
a="$root/skills/analyze"
mkdir -p "$a/references" "$a/scripts/lib"
install_common_scripts "$a"
copy_file "$root/references/workflow/pipeline.md" "$a/references/workflow-pipeline.md"
copy_file "$root/references/workflow/grading.md" "$a/references/workflow-grading.md"
copy_file "$root/references/workflow/light-task.md" "$a/references/workflow-light-task.md"
copy_file "$root/references/guide/skill-subagent.md" "$a/references/guide-skill-subagent.md"
copy_file "$root/scripts/ingest-external-to-inputs.sh" "$a/scripts/ingest-external-to-inputs.sh"
copy_file "$root/scripts/record-urls-to-inputs.sh" "$a/scripts/record-urls-to-inputs.sh"
copy_file "$root/references/workflow/assumptions-protocol.md" "$a/references/assumptions-protocol.md"
rm -f "$a/references/collaboration-discipline.md" \
  "$a/references/layering-appendix-a.md" \
  "$a/references/path-conventions.md" \
  "$a/references/guide-layering.md" \
  "$a/references/check-run-patterns.txt"

# --- plan：分层 + overlay ---
p="$root/skills/plan"
mkdir -p "$p/references" "$p/assets" "$p/scripts/lib"
install_common_scripts "$p"
copy_file "$root/references/workflow/pipeline.md" "$p/references/workflow-pipeline.md"
copy_file "$root/references/guide/layering.md" "$p/references/guide-layering.md"
copy_file "$root/templates/vendor/layering-appendix-a.md" "$p/references/layering-appendix-a.md"
copy_file "$root/templates/vendor/collaboration-discipline.md" "$p/references/collaboration-discipline.md"
copy_tree "$root/templates/overlay" "$p/assets/overlay"
copy_file "$root/references/workflow/plan-slicing.md" "$p/references/plan-slicing.md"
rm -f "$p/references/path-conventions.md" \
  "$p/references/workflow-grading.md" \
  "$p/references/workflow-light-task.md" \
  "$p/references/guide-skill-subagent.md" \
  "$p/references/check-run-patterns.txt"

# --- review：评审闸门 ---
r="$root/skills/review"
mkdir -p "$r/references" "$r/scripts/lib"
install_common_scripts "$r"
copy_file "$root/references/workflow/pipeline.md" "$r/references/workflow-pipeline.md"
copy_file "$root/templates/vendor/layering-appendix-a.md" "$r/references/layering-appendix-a.md"
copy_file "$root/references/workflow/review-discipline.md" "$r/references/review-discipline.md"
rm -f "$r/references/collaboration-discipline.md" \
  "$r/references/path-conventions.md" \
  "$r/references/guide-layering.md" \
  "$r/references/workflow-grading.md" \
  "$r/references/workflow-light-task.md" \
  "$r/references/guide-skill-subagent.md" \
  "$r/references/check-run-patterns.txt"

# --- develop：实现 + reconcile ---
d="$root/skills/develop"
mkdir -p "$d/references" "$d/assets" "$d/scripts/lib"
install_common_scripts "$d"
copy_file "$root/references/workflow/pipeline.md" "$d/references/workflow-pipeline.md"
copy_file "$root/templates/vendor/layering-appendix-a.md" "$d/references/layering-appendix-a.md"
copy_file "$root/templates/vendor/collaboration-discipline.md" "$d/references/collaboration-discipline.md"
copy_file "$root/references/rules/check-run-patterns.txt" "$d/references/check-run-patterns.txt"
copy_file "$root/templates/developer-implementation-template.md" "$d/assets/developer-implementation-template.md"
copy_file "$root/scripts/reconcile-check.sh" "$d/scripts/reconcile-check.sh"
copy_file "$root/scripts/check-run.sh" "$d/scripts/check-run.sh"
copy_tree "$root/templates/overlay" "$d/assets/overlay"
copy_file "$root/references/workflow/incremental-delivery.md" "$d/references/incremental-delivery.md"
rm -f "$d/references/path-conventions.md" \
  "$d/references/guide-layering.md" \
  "$d/references/workflow-grading.md" \
  "$d/references/workflow-light-task.md" \
  "$d/references/guide-skill-subagent.md"

# --- test：验证 + check-run ---
t="$root/skills/test"
mkdir -p "$t/references" "$t/scripts/lib"
install_common_scripts "$t"
copy_file "$root/references/workflow/pipeline.md" "$t/references/workflow-pipeline.md"
copy_file "$root/templates/vendor/layering-appendix-a.md" "$t/references/layering-appendix-a.md"
copy_file "$root/scripts/check-run.sh" "$t/scripts/check-run.sh"
copy_file "$root/references/workflow/test-discipline.md" "$t/references/test-discipline.md"
rm -f "$t/references/collaboration-discipline.md" \
  "$t/references/path-conventions.md" \
  "$t/references/guide-layering.md" \
  "$t/references/workflow-grading.md" \
  "$t/references/workflow-light-task.md" \
  "$t/references/guide-skill-subagent.md" \
  "$t/references/check-run-patterns.txt"

chmod +x "$root/skills/"*/scripts/*.sh 2>/dev/null || true
chmod +x "$root/skills/"*/scripts/lib/*.sh 2>/dev/null || true

echo "sync-skill-vendor: 已按阶段最小集同步 5 个 skill"
