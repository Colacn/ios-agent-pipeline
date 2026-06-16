# IDE 入口适配表

> Skill 名与 SOP **跨 IDE 一致**；下表仅为各环境的**触发方式**差异，不是第二套流程。

## Skill 与 Subagent 对照

| Skill（落盘前缀） | 历史 Subagent 名 | 主要产物 |
|-------------------|------------------|----------|
| `analyze` | `analyst` | `outputs/analyze.requirements.md` |
| `plan` | `planner` | `outputs/plan.solution.md` |
| `review` | `reviewer` | `outputs/review.gate.md` |
| `develop` | `developer` | `outputs/developer.implementation.md` |
| `test` | `tester` | `outputs/test.report.md` |

## 各 IDE 触发方式

| 阶段 | Cursor | Claude Code | Codex |
|------|--------|-------------|-------|
| analyze | `/analyze` 或 `/analyst`、子代理 | Skill 工具 / 斜杠（若配置） | 加载 `analyze` skill |
| plan | `/plan` / `/planner` | 同上 | 同上 |
| review | `/review` / `/reviewer` | 同上 | 同上 |
| develop | `/develop` / `/developer` | 同上 | 同上 |
| test | `/test` / `/tester` | 同上 | 同上 |

## 项目内框架根目录

安装脚本 [install-framework-to-project.sh](../../scripts/install-framework-to-project.sh) 映射：

| target | 项目内路径 |
|--------|------------|
| `cursor` | `.cursor/` |
| `claude` | `.claude/` |
| `codex` | `.codex/agent-workflow/` |
| `neutral` | `agent-workflow/` |

`skills/` 与 `references/`、`scripts/` 必须位于同一框架根下，以保持 Skill 内相对链接有效。

## 项目指南文件

| IDE | 建议文件 |
|-----|----------|
| Cursor / Codex | `AGENTS.md` |
| Claude Code | `CLAUDE.md`（可与 AGENTS.md 并存，由团队约定优先级） |

框架**不**在项目指南中写入第三方插件规则；见 [cross-platform-deployment.md](cross-platform-deployment.md)。
