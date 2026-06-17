# agent-pipeline

**IDE-agnostic** document-driven agent pipeline for software R&D teams:

`analyze → plan → review → develop → test`

Install into **Cursor**, **Claude Code**, **Codex**, or any editor that supports [Agent Skills](https://skills.sh/). No Superpowers or other third-party plugin required.

## Features

- Five pipeline skills with shared evidence baseline (`runs/<slug>/outputs/`)
- Bash scripts: bootstrap runs, ingest inputs, check outputs naming
- Subagent thin routing (`analyst` ↔ `analyze`, etc.)
- Optional Cursor Marketplace plugin manifest (`.cursor-plugin/`)

## Quick start

In your **application repository root**:

```bash
git clone https://github.com/Colacn/agent-pipeline.git /tmp/agent-pipeline
bash /tmp/agent-pipeline/scripts/install-framework-to-project.sh cursor --init-agents --check
# 业务 overlay 在业务仓自建 project-overlays/ 后：--overlay <name>
```

**只装某一阶段**（含 references/scripts/templates 共享 bundle，与 skills.sh 单 skill 体验一致）：

```bash
bash /tmp/agent-pipeline/scripts/install-skill.sh analyze cursor
bash /tmp/agent-pipeline/scripts/install-skill.sh analyze plan develop cursor
```

Install for multiple IDEs at once:

```bash
bash /tmp/agent-pipeline/scripts/install-framework-to-project.sh all
```

Optional global skills (Claude Code / Codex):

```bash
INSTALL_GLOBAL=1 bash /tmp/agent-pipeline/scripts/install-framework-to-project.sh claude codex
```

Then add a project guide file (`AGENTS.md` or `CLAUDE.md`) linking to `references/workflow/pipeline.md`. See [`templates/project/AGENTS.md.example`](templates/project/AGENTS.md.example).

Verify:

```bash
bash .cursor/scripts/bootstrap-run.sh smoke-test
bash .cursor/scripts/check-run.sh smoke-test
bash scripts/smoke-test.sh   # 框架仓：repo_root + 安装布局冒烟
```

## Install targets

| Target | Project path | Guide file |
|--------|--------------|------------|
| `cursor` | `.cursor/` | `AGENTS.md` |
| `claude` | `.claude/` | `CLAUDE.md` |
| `codex` | `.codex/agent-workflow/` | `AGENTS.md` |
| `neutral` | `agent-workflow/` | `AGENTS.md` |

## skills.sh / 单 skill 安装

Browse [skills.sh](https://skills.sh/). 两种方式：

| 方式 | 命令 | 得到什么 |
|------|------|----------|
| **本仓 install-skill** | `bash …/scripts/install-skill.sh analyze cursor` | skill + agent + references/scripts/templates |
| **skills.sh 生态** | `npx skills add Colacn/agent-pipeline@analyze` | 通常仅 skill 目录；需另装共享 bundle |
| **整包** | `install-framework-to-project.sh cursor` | 全部 skills + agents + 共享 bundle |

```bash
# 推荐：单阶段 + 可运行共享 bundle
bash /tmp/agent-pipeline/scripts/install-skill.sh analyze cursor

# 或 skills.sh（发现/全局 skills 目录）
npx skills add Colacn/agent-pipeline@analyze
npx skills add Colacn/agent-pipeline@plan

# 整包
bash /tmp/agent-pipeline/scripts/install-framework-to-project.sh cursor
```

## Repository layout

```text
agent-pipeline/
├── framework.manifest.json
├── skills/
├── agents/
├── references/
├── scripts/
├── templates/                # assets：交付模板、overlay/sample
└── .cursor-plugin/
```

## Documentation

| Doc | Description |
|-----|-------------|
| [CHANGELOG.md](CHANGELOG.md) | 版本变更记录 |
| [cross-platform-deployment.md](references/guide/cross-platform-deployment.md) | Multi-IDE deployment |
| [distribution.md](references/guide/distribution.md) | Publish channels |
| [installation.md](references/guide/installation.md) | Migration checklist |
| [skill-subagent.md](references/guide/skill-subagent.md) | Skill vs Subagent names |
| [skills-ecosystem-alignment.md](references/guide/skills-ecosystem-alignment.md) | 与 skills.sh / Agent Skills 标准对照 |
| [path-conventions.md](references/guide/path-conventions.md) | 框架仓 vs 安装后路径 |
| [pipeline.md](references/workflow/pipeline.md) | Pipeline rules |

## Output naming (Skill names, not Subagent names)

| Stage | Output file |
|-------|-------------|
| analyze | `runs/<slug>/outputs/analyze.requirements.md` |
| plan | `runs/<slug>/outputs/plan.solution.md` |
| review | `runs/<slug>/outputs/review.gate.md` |
| develop | `runs/<slug>/outputs/developer.implementation.md` |
| test | `runs/<slug>/outputs/test.report.md` |

## License

MIT — see [LICENSE](LICENSE).
