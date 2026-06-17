---
name: analyze
description: Use this skill when the user needs intent clarification, ambiguity resolution, or structured analysis without implementation advice. It asks clarifying questions when uncertain and analyzes only user-provided information after confirmation; use PRD-style packaging only when explicitly requested.
compatibility: Requires bash and git in the business repository. Scripts live in this skill's scripts/ directory.
metadata:
  author: agent-pipeline
  version: "0.6.1"
---

# Analyze

**入口**：`analyze` 为本 Skill 名；部分 IDE（如 Cursor）可用子代理名 `analyst` 作隔离上下文入口，**SOP 仍以本文件为准**。见 [`references/guide-skill-subagent.md`](references/guide-skill-subagent.md)。

## Instructions

1. 完整执行规范见 [`references/execution-playbook.md`](references/execution-playbook.md)（**优先通读**）。**走流水线**时：有外部依据则 [`scripts/bootstrap-run.sh`](scripts/bootstrap-run.sh) + ingest/record-urls；否则首次落盘前 bootstrap。
2. **路由决策（首轮）**：按 [`references/workflow-grading.md`](references/workflow-grading.md) 判定 L0–L3；L1 轻量可不建 `runs/`；L2+ 或显式流水线入口须 bootstrap。
3. 按 execution-playbook「输入源与解析范围」收拢信息。
4. 不确定时走「轮次 A — 待澄清」；确认后「轮次 B — 分析交付」。
5. 流水线内口径歧义：**阻塞项未清不进 plan**。
6. 写入仓库前按项目约定征得用户同意（若适用）。
7. **流水线硬门禁**：[`references/workflow-pipeline.md`](references/workflow-pipeline.md)（项目 `AGENTS.md` 若有则叠加）。
8. **内容边界**：`analyze.requirements.md` 只写要什么 + 验收 + 范围；技术细节交给 **plan** skill。
9. **需求清单体例**：极短标题 + 编号要点；不堆平台词。

## Scripts

- [`scripts/bootstrap-run.sh`](scripts/bootstrap-run.sh)
- [`scripts/ingest-external-to-inputs.sh`](scripts/ingest-external-to-inputs.sh)
- [`scripts/record-urls-to-inputs.sh`](scripts/record-urls-to-inputs.sh)

在业务仓库根目录执行；全局安装时路径为 `~/.agents/skills/analyze/scripts/` 或各 IDE 映射目录。

## On-demand references

- `references/playbook-map.md` — 流程与边界
- `references/handoff-checklist.md` — 需求包交接
- `references/execution-playbook.md` — 完整 SOP
- `references/workflow-light-task.md` — L1 轻量通道

## When not to use

- 用户要**写代码、出方案**（见 `develop` / `plan` skill）。
- 用户要**评审、拍板**（见 `review` skill）。
