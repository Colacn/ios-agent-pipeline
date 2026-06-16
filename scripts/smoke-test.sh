#!/usr/bin/env bash
# Phase 0 冒烟：验证 repo_root 解析与 runs 工区脚本在框架仓与安装后均可工作。
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
framework_root="$(cd "$script_dir/.." && pwd)"
slug="smoke-ci-$(date +%s)"

echo "==> [1/4] 框架仓直接执行 bootstrap-run"
cd "$framework_root"
bash scripts/bootstrap-run.sh "$slug"
test -d "$framework_root/runs/$slug/inputs"
test -d "$framework_root/runs/$slug/outputs"
echo "    OK: runs/$slug 位于框架仓根"

echo "==> [2/4] check-run（空 outputs，预期 warning 通过）"
bash scripts/check-run.sh "$slug"

echo "==> [3/4] 模拟 Cursor 安装后执行"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
cd "$tmpdir"
git init -q
bash "$framework_root/scripts/install-framework-to-project.sh" cursor
bash .cursor/scripts/bootstrap-run.sh "${slug}-installed"
test -d "$tmpdir/runs/${slug}-installed/inputs"
echo "    OK: 安装后 runs 位于业务仓根"

echo "==> [4/4] overlay 脚手架（sample）+ --init-agents"
overlay_tmp="$(mktemp -d)"
trap 'rm -rf "$tmpdir" "$overlay_tmp"' EXIT
cd "$overlay_tmp"
git init -q
OVERLAY_SRC="$framework_root/templates/overlay" \
  bash "$framework_root/scripts/install-framework-to-project.sh" cursor --init-agents --overlay sample
test -f AGENTS.md
test -f project-overlays/sample/appendix-a-layers.md
grep -q 'project-overlays/sample' AGENTS.md
echo "    OK: 脚手架 overlay 安装"

echo "smoke-test: 全部通过"
