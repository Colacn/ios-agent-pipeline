#!/usr/bin/env bash
# 导出 IDE 中立 + 多通道可发布的分发目录（不含 iOS 业务代码）。
#
# 用法：
#   bash .cursor/scripts/export-distribution-layout.sh <output-dir>
#
# 产出 layout：
#   <output-dir>/
#   ├── framework.manifest.json
#   ├── skills/ agents/ references/ scripts/ templates/ rules/
#   ├── README.md
#   ├── .cursor-plugin/plugin.json    # Cursor Marketplace 可选通道
#   └── templates/project/AGENTS.md.template
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "用法: bash .cursor/scripts/export-distribution-layout.sh <output-dir>" >&2
  exit 1
fi

out_dir="$1"
mkdir -p "$out_dir"
out_dir="$(cd "$out_dir" && pwd)"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
framework_src="$(cd "$script_dir/.." && pwd)"

manifest_version="0.2.0"
if [[ -f "$framework_src/framework.manifest.json" ]]; then
  manifest_version="$(grep -E '"version"' "$framework_src/framework.manifest.json" | head -1 | sed -E 's/.*"version"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/')"
fi

copy_tree() {
  local src="$1" dest="$2"
  [[ -d "$src" ]] || return 0
  mkdir -p "$dest"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete "$src/" "$dest/"
  else
    rm -rf "$dest"
    mkdir -p "$dest"
    cp -R "$src/." "$dest/"
  fi
}

mkdir -p "$out_dir"
for c in skills agents references scripts templates rules; do
  copy_tree "$framework_src/$c" "$out_dir/$c"
done

cp "$framework_src/framework.manifest.json" "$out_dir/framework.manifest.json"
chmod +x "$out_dir/scripts/"*.sh 2>/dev/null || true

# Cursor Marketplace 通道（可选，非唯一安装方式）
mkdir -p "$out_dir/.cursor-plugin"
cat > "$out_dir/.cursor-plugin/plugin.json" <<EOF
{
  "name": "ios-agent-pipeline",
  "version": "${manifest_version}",
  "description": "IDE-agnostic iOS agent pipeline (analyze → plan → review → develop → test). Install project bundle via scripts/install-framework-to-project.sh for full references/scripts.",
  "keywords": ["ios", "agent", "pipeline", "workflow", "skills"],
  "skills": "skills",
  "agents": "agents",
  "rules": "rules"
}
EOF

# 分发 README
cat > "$out_dir/README.md" <<'EOF'
# iOS Agent Pipeline（可移植工作流框架）

IDE 中立 · 可安装到 Cursor / Claude Code / Codex / skills.sh

## 快速安装（任意 IDE）

在**目标业务仓库根目录**：

```bash
git clone <this-repo-url> /tmp/ios-agent-pipeline
bash /tmp/ios-agent-pipeline/scripts/install-framework-to-project.sh all
# 或单通道：cursor | claude | codex | neutral
```

全局 skills（Claude Code / Codex 可选）：

```bash
INSTALL_GLOBAL=1 bash /tmp/ios-agent-pipeline/scripts/install-framework-to-project.sh claude codex
```

## skills.sh

```bash
npx skills add <owner/repo>@analyze
# 整包仍建议 clone + install-framework-to-project.sh 以获取 references/scripts
```

## 文档

安装后阅读：`references/guide/cross-platform-deployment.md`
EOF

mkdir -p "$out_dir/templates/project"
if [[ -f "$framework_src/templates/project/AGENTS.md.example" ]]; then
  cp "$framework_src/templates/project/AGENTS.md.example" "$out_dir/templates/project/AGENTS.md.example"
fi

echo "已导出到: $out_dir"
echo "下一步: cd $out_dir && git init && git add . && git commit -m 'chore: distribution layout'"
