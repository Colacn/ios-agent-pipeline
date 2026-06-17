---
name: develop
description: Use when implementing approved changes with minimal diff, layered constraints, and local verification. Intended for post-plan/review execution with collaboration discipline and test handoff.
compatibility: Requires bash and git in the business repository.
metadata:
  author: agent-pipeline
  version: "0.6.1"
---

# Develop

## Instructions

1. 完整执行规范见 [`references/execution-playbook.md`](references/execution-playbook.md)。落盘前执行 [`scripts/bootstrap-run.sh`](scripts/bootstrap-run.sh) `<slug>`（若尚无工区）。
2. **分层**：[`references/layering-appendix-a.md`](references/layering-appendix-a.md) + overlay `project-overlays/*/appendix-a-layers.md`。
3. **协作与质量**：[`references/collaboration-discipline.md`](references/collaboration-discipline.md)。
4. **流水线**：[`references/workflow-pipeline.md`](references/workflow-pipeline.md)。
5. **出口（强制）**：落盘 `developer.implementation.md` → reconcile-docs。模板 [`assets/developer-implementation-template.md`](assets/developer-implementation-template.md)。建议 `bash scripts/reconcile-check.sh <slug>`。

## On-demand references

- `references/execution-gate.md`
- `references/delivery-checklist.md`
- `references/execution-playbook.md`

## When not to use

- 评审阻塞未解除仍强行开发。
- 关键决策未决（先上游 skill）。
