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
bash /tmp/ios-agent-pipeline/scripts/install-framework-to-project.sh cursor
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
├── framework.manifest.json   # IDE-neutral package manifest
├── skills/                   # analyze, plan, review, develop, test
├── agents/
├── references/
├── scripts/
├── templates/
├── rules/
└── .cursor-plugin/           # optional Cursor Marketplace channel
```

## Documentation

| Doc | Description |
|-----|-------------|
| [cross-platform-deployment.md](references/guide/cross-platform-deployment.md) | Multi-IDE deployment |
| [distribution.md](references/guide/distribution.md) | Publish channels |
| [installation.md](references/guide/installation.md) | Migration checklist |
| [skill-subagent.md](references/guide/skill-subagent.md) | Skill vs Subagent names |
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
