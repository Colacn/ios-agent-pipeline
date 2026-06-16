# 跨 IDE 部署指南

> 本框架 **不与 Cursor 强绑定**。Skill 正文、references、bash 脚本、runs 证据基线为 **IDE 中立**；各 IDE 仅差「落盘目录」与「触发入口」。

## 设计原则

| 原则 | 说明 |
|------|------|
| **内容中立** | `skills/*/SKILL.md`、`references/`、`scripts/` 不假设单一 IDE API |
| **结构固定** | 五阶段 Skill 名统一：`analyze` / `plan` / `review` / `develop` / `test` |
| **落盘可适配** | 同一套文件可安装到 Cursor、Claude Code、Codex 或中立目录 `agent-workflow/` |
| **项目层叠加** | 各 IDE 的项目指南（`AGENTS.md` / `CLAUDE.md`）由使用者维护，含可选第三方工具规则 |

权威清单：[framework.manifest.json](../../framework.manifest.json)

---

## IDE 落盘与入口对照

| 能力 | Skill 名 | 产物文件 | Cursor | Claude Code | Codex |
|------|----------|----------|--------|-------------|-------|
| 分析 | `analyze` | `analyze.requirements.md` | `/analyze` 或子代理 `/analyst` | Skill 工具加载 `analyze` | `~/.codex/skills/analyze` 或项目 bundle |
| 方案 | `plan` | `plan.solution.md` | `/plan` / `/planner` | 同上 | 同上 |
| 评审 | `review` | `review.gate.md` | `/review` / `/reviewer` | 同上 | 同上 |
| 实现 | `develop` | `developer.implementation.md` | `/develop` / `/developer` | 同上 | 同上 |
| 测试 | `test` | `test.report.md` | `/test` / `/tester` | 同上 | 同上 |

**Subagent 名**（`analyst`、`planner` 等）为历史并行入口，**不是**第二套 SOP；详见 [skill-subagent.md](skill-subagent.md)。

### 推荐项目目录（安装后）

| IDE | 项目内框架根 | 项目指南文件 |
|-----|--------------|--------------|
| Cursor | `.cursor/` | `AGENTS.md` |
| Claude Code | `.claude/` | `CLAUDE.md` |
| Codex | `.codex/agent-workflow/` | `AGENTS.md` |
| 中立（任意 IDE） | `agent-workflow/` | `AGENTS.md` |

`references/`、`scripts/`、`templates/` 必须与 `skills/` **保持相对路径同级**，否则 Skill 内链会断。

---

## 安装方式

### 1. 一键多 IDE 安装（推荐）

在**目标业务仓库根**执行：

```bash
# 从本 monorepo 或已 clone 的分发包
bash /path/to/ios-agent-pipeline/scripts/install-framework-to-project.sh all
```

仅安装单一 IDE：

```bash
bash .../install-framework-to-project.sh cursor
bash .../install-framework-to-project.sh claude
bash .../install-framework-to-project.sh codex
bash .../install-framework-to-project.sh neutral
```

可选：Claude Code / Codex **全局 skills**（便于跨项目发现）：

```bash
INSTALL_GLOBAL=1 bash .../install-framework-to-project.sh claude codex
```

### 2. Git 克隆 + 复制（无脚本）

```bash
git clone <framework-repo> /tmp/agent-pipeline
cp -R /tmp/agent-pipeline/skills /tmp/agent-pipeline/references ... <target-root>/.cursor/
```

### 3. skills.sh 开放生态

浏览 [skills.sh](https://skills.sh/) · CLI：`npx skills add <owner/repo>@<skill>`

- 适合按阶段安装单个 Skill
- **整包**仍建议 `git clone` + `install-framework-to-project.sh`，以带上 `references/`、`scripts/`、`templates/`

### 4. Cursor Marketplace（可选通道之一）

非唯一分发方式。插件清单见仓库 `.cursor-plugin/plugin.json`；Marketplace 通常只同步 skills/agents/rules，**完整流水线**仍需 [项目落地脚本](../../scripts/install-framework-to-project.sh)。

---

## 导出独立分发包

从本仓库导出 IDE 中立目录（用于开源发布、skills 市场、内网镜像）：

```bash
bash .cursor/scripts/export-distribution-layout.sh /path/to/ios-agent-pipeline-dist
```

产出含 `skills/`、`agents/`、`references/`、`scripts/`、`framework.manifest.json`、可选 `.cursor-plugin/`。

---

## 验证（任意 IDE）

安装后路径可能为 `.cursor/` 或 `agent-workflow/`，以下以 Cursor 为例：

```bash
bash .cursor/scripts/bootstrap-run.sh smoke-test
bash .cursor/scripts/check-run.sh smoke-test
```

---

## 项目层指南模板

框架**不**写入 Superpowers 等第三方工具规则。在目标仓库 `AGENTS.md` 或 `CLAUDE.md` 自行追加，例如：

```markdown
## 可选：第三方 Agent 插件 / 个人 skills

若使用 xxx，其优先级低于本仓库 agent-workflow/references/workflow/pipeline.md 证据基线。
```

---

## 相关文档

- [distribution.md](distribution.md) — 各分发通道对比与发布 checklist
- [installation.md](installation.md) — 换机迁移
- [skill-subagent.md](skill-subagent.md) — Skill 名 vs Subagent 名
- [../../README.md](../../README.md) — 框架自述
