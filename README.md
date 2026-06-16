# ios-agent-pipeline

**IDE-agnostic** document-driven agent pipeline for iOS (and general software) teams:

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
git clone https://github.com/Colacn/ios-agent-pipeline.git /tmp/ios-agent-pipeline
bash /tmp/ios-agent-pipeline/scripts/install-framework-to-project.sh cursor --init-agents --check
# 业务 overlay 在业务仓自建 project-overlays/ 后：--overlay <name>
```

Install for multiple IDEs at once:

```bash
bash /tmp/ios-agent-pipeline/scripts/install-framework-to-project.sh all
```

Optional global skills (Claude Code / Codex):

```bash
INSTALL_GLOBAL=1 bash /tmp/ios-agent-pipeline/scripts/install-framework-to-project.sh claude codex
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

## skills.sh

Browse [skills.sh](https://skills.sh/). Per-stage install (after this repo is published):

```bash
npx skills add Colacn/ios-agent-pipeline@analyze
npx skills add Colacn/ios-agent-pipeline@plan
```

For `references/`, `scripts/`, and `templates/`, use the full Git install above.

## Repository layout

```text
ios-agent-pipeline/
├── framework.manifest.json
├── skills/
├── agents/
├── references/
├── scripts/
├── templates/                # skip-step, overlay/sample 脚手架等
├── project-overlays/         # 仅 README（业务 overlay 在业务仓维护）
├── rules/
└── .cursor-plugin/
```

## Documentation

| Doc | Description |
|-----|-------------|
| [**SESSION-HANDOFF.md**](docs/SESSION-HANDOFF.md) | **新会话背景包**（复制提示词给 Chat） |
| [CHANGELOG.md](CHANGELOG.md) | 版本变更记录 |
| [cross-platform-deployment.md](references/guide/cross-platform-deployment.md) | Multi-IDE deployment |
| [distribution.md](references/guide/distribution.md) | Publish channels |
| [installation.md](references/guide/installation.md) | Migration checklist |
| [skill-subagent.md](references/guide/skill-subagent.md) | Skill vs Subagent names |
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
