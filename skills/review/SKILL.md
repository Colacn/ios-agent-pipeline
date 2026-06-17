---
name: review
description: Use this skill when evaluating analyze/plan outputs before implementation, especially for feasibility, risk, security, performance, compatibility, and testability gates. It produces evidence-based pass, conditional pass, or fail conclusions.
compatibility: Requires bash and git in the business repository.
metadata:
  author: agent-pipeline
  version: "0.6.3"
---

# Review

## Instructions

1. 完整执行规范见 [`references/execution-playbook.md`](references/execution-playbook.md)。落盘前若工区不存在，执行 [`scripts/bootstrap-run.sh`](scripts/bootstrap-run.sh) `<slug>`。
2. **Inputs**：`analyze` + `plan` 产出；补充人类约束（窗口、合规、性能等）。
3. **分层对照**：[`references/layering-appendix-a.md`](references/layering-appendix-a.md) + 项目 overlay（若有）。
4. **Ruling**：`通过` / `有条件通过` / `不通过`；关键发现须带证据；必改 vs 建议分离；纪律见 [`references/review-discipline.md`](references/review-discipline.md)。
5. **流水线**：[`references/workflow-pipeline.md`](references/workflow-pipeline.md)。
6. **极简需求清单闸门**：短编号需求须核对 plan 的 §0 与正文逐条可验收落点。

## On-demand references

- `references/review-discipline.md` — 五轴、验证故事、评论分级
- `references/review-gate-checklist.md`
- `references/ruling-criteria.md`
- `references/execution-playbook.md`

## When not to use

- 无 `analyze` / `plan` 可评材料且拒绝补充。
- 用户明示跳过评审（须留痕）。
