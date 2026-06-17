#!/usr/bin/env bash
# Phase 0 冒烟：验证自包含 skill 与安装布局。
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
framework_root="$(cd "$script_dir/.." && pwd)"
slug="smoke-ci-$(date +%s)"

echo "==> [1/5] 框架仓：analyze skill 内 bootstrap-run"
cd "$framework_root"
bash skills/analyze/scripts/bootstrap-run.sh "$slug"
test -d "$framework_root/runs/$slug/inputs"
test -d "$framework_root/runs/$slug/outputs"
echo "    OK: runs/$slug 位于框架仓根"

echo "==> [2/5] develop skill 内 check-run（空 outputs，预期 warning 通过）"
bash skills/develop/scripts/check-run.sh "$slug"

echo "==> [3/5] 模拟 Cursor 整包安装后执行"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
cd "$tmpdir"
git init -q
bash "$framework_root/scripts/install-framework-to-project.sh" cursor
bash .cursor/skills/analyze/scripts/bootstrap-run.sh "${slug}-installed"
test -d "$tmpdir/runs/${slug}-installed/inputs"
test -f .cursor/skills/analyze/scripts/bootstrap-run.sh
test ! -f .cursor/references/workflow/pipeline.md
echo "    OK: 自包含 skill 可 bootstrap，无 legacy references/"

echo "==> [4/5] 单 skill 安装（analyze）"
skill_tmp="$(mktemp -d)"
trap 'rm -rf "$tmpdir" "$overlay_tmp" "$skill_tmp"' EXIT
cd "$skill_tmp"
git init -q
bash "$framework_root/scripts/install-skill.sh" analyze cursor
test -f .cursor/skills/analyze/SKILL.md
test -f .cursor/skills/analyze/scripts/bootstrap-run.sh
test -f .cursor/agents/analyst.md
test ! -e .cursor/skills/plan/SKILL.md
bash .cursor/skills/analyze/scripts/bootstrap-run.sh "${slug}-skill"
test -d "$skill_tmp/runs/${slug}-skill/inputs"
echo "    OK: 单 skill 自包含，可 bootstrap"

echo "==> [5/5] overlay 脚手架（sample）+ --init-agents"
overlay_tmp="$(mktemp -d)"
trap 'rm -rf "$tmpdir" "$overlay_tmp" "$skill_tmp"' EXIT
cd "$overlay_tmp"
git init -q
OVERLAY_SRC="$framework_root/templates/overlay" \
  bash "$framework_root/scripts/install-framework-to-project.sh" cursor --init-agents --overlay sample
test -f AGENTS.md
test -f project-overlays/sample/appendix-a-layers.md
test -f .cursor/skills/plan/assets/overlay/sample/appendix-a-layers.md
echo "    OK: overlay 脚手架 + 自包含 plan assets"

echo "smoke-test: 全部通过"
