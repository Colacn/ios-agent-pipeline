# agent-pipeline

Document-driven agent pipeline for software R&D teams:

`analyze → plan → review → develop → test`

符合 [Agent Skills 开放规范](https://agentskills.io/specification)：每个阶段为**自包含 skill**（`SKILL.md` + `references/` + `scripts/` + `assets/`），可通过 [skills.sh](https://skills.sh/Colacn/agent-pipeline) / `npx skills add` 安装到 **Cursor**、**Claude Code**、**Codex** 等 60+ Agent。

## Features

- 五阶段流水线 skill，证据基线 `runs/<slug>/outputs/`
- 每 skill 自带 `scripts/`（bootstrap、check-run 等）
- Subagent 薄路由（`analyst` ↔ `analyze` 等）
- 可选 Cursor Marketplace 插件清单（`.cursor-plugin/`）

## Quick start（主流：skills.sh）

在**业务仓库根目录**（需 Node.js / `npx`）：

```bash
npx skills add Colacn/agent-pipeline@analyze -a cursor -y
npx skills add Colacn/agent-pipeline@plan -a cursor -y   # 按需追加阶段
```

验证：

```bash
bash .cursor/skills/analyze/scripts/bootstrap-run.sh smoke-test
bash .cursor/skills/develop/scripts/check-run.sh smoke-test
```

## 备选：Git 安装脚本

无需 Node 时，clone 后用 bash 安装（同样安装自包含 skill + agents + 项目工具脚本）：

```bash
git clone https://github.com/Colacn/agent-pipeline.git /tmp/agent-pipeline
cd your-app
bash /tmp/agent-pipeline/scripts/install-framework-to-project.sh cursor --init-agents --check
```

单阶段：

```bash
bash /tmp/agent-pipeline/scripts/install-skill.sh analyze cursor
```

多 IDE：

```bash
bash /tmp/agent-pipeline/scripts/install-framework-to-project.sh all
```

全局 skills（Claude / Codex）：

```bash
INSTALL_GLOBAL=1 bash /tmp/agent-pipeline/scripts/install-framework-to-project.sh claude codex
```

项目指南：从 [`templates/project/AGENTS.md.example`](templates/project/AGENTS.md.example) 生成 `AGENTS.md`。

框架仓冒烟：

```bash
bash scripts/smoke-test.sh
```

## Install targets

| Target | Skill 路径 | Guide file |
|--------|------------|------------|
| `cursor` | `.cursor/skills/<name>/` | `AGENTS.md` |
| `claude` | `.claude/skills/<name>/` | `CLAUDE.md` |
| `codex` | `.codex/skills/<name>/`（全局）或项目 bundle | `AGENTS.md` |
| `neutral` | `agent-workflow/skills/<name>/` | `AGENTS.md` |

## 安装方式对照

| 方式 | 命令 | 得到什么 |
|------|------|----------|
| **skills.sh（推荐）** | `npx skills add Colacn/agent-pipeline@analyze` | 自包含 skill 目录 |
| **install-skill.sh** | `bash …/install-skill.sh analyze cursor` | skill + agent + 安装工具脚本 |
| **整包** | `install-framework-to-project.sh cursor` | 全部 5 skill + agents + 安装工具脚本 |
| **legacy bundle** | 上述命令 + `--with-legacy-bundle` | 额外复制根 `references/scripts/templates`（旧布局） |

## 单 skill 目录结构（Agent Skills 标准）

```text
skills/analyze/
├── SKILL.md
├── references/          # workflow-pipeline.md、execution-playbook.md …
├── scripts/               # bootstrap-run.sh、ingest …
└── assets/                # 可选
```

维护者修改根 `references/workflow/` 或 `scripts/` 后，执行 `bash scripts/sync-skill-vendor.sh` 同步到各 skill。

## Repository layout（框架仓）

```text
agent-pipeline/
├── framework.manifest.json
├── skills/                # 发布到 skills.sh 的 5 个自包含 skill
├── agents/                # Cursor 等 Subagent 薄路由（非 skills.sh 标准）
├── references/            # 维护者 canonical 源（sync 到 skills/*/references）
├── scripts/               # 维护者工具 + sync-skill-vendor.sh
├── templates/
└── .cursor-plugin/
```

## Documentation

| Doc | Description |
|-----|-------------|
| [CHANGELOG.md](CHANGELOG.md) | 版本变更 |
| [skills-ecosystem-alignment.md](references/guide/skills-ecosystem-alignment.md) | Agent Skills / skills.sh 对照 |
| [distribution.md](references/guide/distribution.md) | 发布渠道 |
| [installation.md](references/guide/installation.md) | 迁移清单 |
| [pipeline.md](references/workflow/pipeline.md) | 流水线规则（canonical；skill 内为 `workflow-pipeline.md`） |

## Output naming

| Stage | Output file |
|-------|-------------|
| analyze | `runs/<slug>/outputs/analyze.requirements.md` |
| plan | `runs/<slug>/outputs/plan.solution.md` |
| review | `runs/<slug>/outputs/review.gate.md` |
| develop | `runs/<slug>/outputs/developer.implementation.md` |
| test | `runs/<slug>/outputs/test.report.md` |

## License

MIT — see [LICENSE](LICENSE).
