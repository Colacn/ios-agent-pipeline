#!/usr/bin/env bash
# Phase 0 冒烟：验证 repo_root 解析与 runs 工区脚本在框架仓与安装后均可工作。
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
framework_root="$(cd "$script_dir/.." && pwd)"
slug="smoke-ci-$(date +%s)"

echo "==> [1/5] 框架仓直接执行 bootstrap-run"
cd "$framework_root"
bash scripts/bootstrap-run.sh "$slug"
test -d "$framework_root/runs/$slug/inputs"
test -d "$framework_root/runs/$slug/outputs"
echo "    OK: runs/$slug 位于框架仓根"

echo "==> [2/5] check-run（空 outputs，预期 warning 通过）"
bash scripts/check-run.sh "$slug"

echo "==> [3/5] 模拟 Cursor 整包安装后执行"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
cd "$tmpdir"
git init -q
bash "$framework_root/scripts/install-framework-to-project.sh" cursor
bash .cursor/scripts/bootstrap-run.sh "${slug}-installed"
test -d "$tmpdir/runs/${slug}-installed/inputs"
echo "    OK: 安装后 runs 位于业务仓根"

echo "==> [4/5] 单 skill 安装（analyze）+ 共享 bundle"
skill_tmp="$(mktemp -d)"
trap 'rm -rf "$tmpdir" "$overlay_tmp" "$skill_tmp"' EXIT
cd "$skill_tmp"
git init -q
bash "$framework_root/scripts/install-skill.sh" analyze cursor
test -f .cursor/skills/analyze/SKILL.md
test -f .cursor/agents/analyst.md
test -f .cursor/references/workflow/pipeline.md
test -f .cursor/scripts/bootstrap-run.sh
test ! -e .cursor/skills/plan/SKILL.md
bash .cursor/scripts/bootstrap-run.sh "${slug}-skill"
test -d "$skill_tmp/runs/${slug}-skill/inputs"
echo "    OK: 单 skill 含 references/scripts，可 bootstrap"

echo "==> [5/5] overlay 脚手架（sample）+ --init-agents"
overlay_tmp="$(mktemp -d)"
trap 'rm -rf "$tmpdir" "$overlay_tmp" "$skill_tmp"' EXIT
cd "$overlay_tmp"
git init -q
OVERLAY_SRC="$framework_root/templates/overlay" \
  bash "$framework_root/scripts/install-framework-to-project.sh" cursor --init-agents --overlay sample
test -f AGENTS.md
test -f project-overlays/sample/appendix-a-layers.md
grep -q 'project-overlays/sample' AGENTS.md
echo "    OK: 脚手架 overlay 安装"

echo "smoke-test: 全部通过"
