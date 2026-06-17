---
name: plan
description: Use when turning analyze outputs into reviewable technical plans with implementation boundaries, risks, validation, and handoff-ready planning outputs. Supports project overlays for domain-specific layering.
compatibility: Requires bash and git in the business repository.
metadata:
  author: agent-pipeline
  version: "0.6.3"
---

# Plan（方案规划）

## Instructions

1. 完整执行规范见 [`references/execution-playbook.md`](references/execution-playbook.md)。落盘前若无 `runs/<slug>/`，执行 [`scripts/bootstrap-run.sh`](scripts/bootstrap-run.sh) `<slug>`。
2. **分层**：[`references/layering-appendix-a.md`](references/layering-appendix-a.md)；overlay 优先见 `project-overlays/<name>/appendix-a-layers.md`。详见 [`references/guide-layering.md`](references/guide-layering.md)。
3. **下游协作口径**：[`references/collaboration-discipline.md`](references/collaboration-discipline.md)；overlay 脚手架 [`assets/overlay/README.md`](assets/overlay/README.md)。
4. **流水线**：[`references/workflow-pipeline.md`](references/workflow-pipeline.md)。
5. **输入/输出**：来自 `analyze`；面向 `review` 与 `develop`。
6. **内容边界**：`plan.solution.md` 负责落层、设计决策、实现路径；需求清单在 `analyze.requirements.md`。
7. **极简需求清单**：须 **§0 对表索引** + 正文可验收细则（见 execution-playbook）。
8. **任务切片**：按 [`references/plan-slicing.md`](references/plan-slicing.md) 写纵向切片、粒度与 Checkpoint。

## On-demand references

- `references/plan-slicing.md` — 纵向切片与任务粒度
- `references/plan-checklist.md`
- `references/risk-gate.md`
- `references/execution-playbook.md`

## When not to use

- 仅改文案/UI 且不动分层与接口。
- 无 analyze 上下文且用户拒绝补充。
