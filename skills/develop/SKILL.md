---
name: develop
description: Use when implementing approved changes with minimal diff, layered constraints, and local verification. Intended for post-plan/review execution with collaboration discipline and test handoff.
compatibility: Requires bash and git in the business repository.
metadata:
  author: agent-pipeline
  version: "0.6.0"
---

# Develop

## Instructions

1. 完整执行规范见 [`references/execution-playbook.md`](references/execution-playbook.md)（**优先通读**）。落盘 `outputs/` 前若目录不存在，执行 [`scripts/bootstrap-run.sh`](scripts/bootstrap-run.sh) `<slug>`。
2. **Layering**：[`references/layering-appendix-a.md`](references/layering-appendix-a.md) + 项目 overlay `project-overlays/*/appendix-a-layers.md`（冲突时以 overlay 为准）。
3. **协作与质量**：见 [`references/collaboration-discipline.md`](references/collaboration-discipline.md)；项目编码细则见 overlay `coding-conventions.md`（若有）。
4. **流程**：项目根 `AGENTS.md`；走流水线时遵守 execution-playbook「流水线中的本步」。
5. **Handoff to test**：结构化测试/放行建议交给 `test` Skill。
6. **流水线硬门禁**：项目根 `AGENTS.md` + [`references/workflow-pipeline.md`](references/workflow-pipeline.md)。
7. 跳过 `review`/`test` 时的替代门禁见 execution-playbook 与项目 `AGENTS.md`。
8. **develop 出口（强制）**：落盘 `developer.implementation.md` → **reconcile-docs**（对照 `git diff` 回写 requirements/plan）。模板 [`assets/developer-implementation-template.md`](assets/developer-implementation-template.md)。建议执行 `bash scripts/reconcile-check.sh <slug>`。

## On-demand references

- `references/execution-gate.md`
- `references/delivery-checklist.md`
- `references/execution-playbook.md`
- `references/collaboration-discipline.md`

## When not to use

- 评审阻塞未解除仍强行开发。
- 关键决策未决（先上游 Skill）。
