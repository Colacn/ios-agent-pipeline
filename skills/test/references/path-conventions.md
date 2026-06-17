# Skill 内路径约定（自包含安装）

本 skill 目录为**权威根**；`npx skills add` 与 `install-skill.sh` 均只依赖本目录内资源。

| 类型 | 路径 |
|------|------|
| 执行细则 | `references/execution-playbook.md` |
| 流水线规则 | `references/workflow-pipeline.md` |
| 协作纪律 | `references/collaboration-discipline.md` |
| 分层附录 A | `references/layering-appendix-a.md` |
| runs 脚本 | `scripts/bootstrap-run.sh` 等 |
| 交付模板 | `assets/` |

**脚本调用**：在业务仓库根目录执行（Agent 默认工作目录）：

```bash
bash .cursor/skills/analyze/scripts/bootstrap-run.sh <slug>
# 或全局安装后：
bash ~/.cursor/skills/analyze/scripts/bootstrap-run.sh <slug>
```

脚本通过 git 仓库根或 `.cursor/framework.manifest.json` 解析业务仓根，在 `runs/<slug>/` 落盘。

**跨阶段**：其它流水线阶段为独立 skill（`plan`、`review`、`develop`、`test`）；按需 `npx skills add owner/repo@plan` 安装，无硬依赖链。
