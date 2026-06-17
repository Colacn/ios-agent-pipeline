---
name: plan
description: Use when turning analyze outputs into reviewable technical plans with implementation boundaries, risks, validation, and handoff-ready planning outputs. Supports project overlays for domain-specific layering.
compatibility: Requires bash and git in the business repository.
metadata:
  author: agent-pipeline
  version: "0.6.0"
---

# Plan（方案规划）

## Instructions

1. 完整执行规范见 [`references/execution-playbook.md`](references/execution-playbook.md)（**优先通读**）。落盘 `outputs/plan.solution.md` 前若尚无 `runs/<slug>/`，执行 [`scripts/bootstrap-run.sh`](scripts/bootstrap-run.sh) `<slug>`。
2. **Layering authority**：[`references/layering-appendix-a.md`](references/layering-appendix-a.md) 为通用占位；**已安装 project overlay** 时以应用仓 `project-overlays/<name>/appendix-a-layers.md` 为准。详见 [`references/guide-layering.md`](references/guide-layering.md)。
3. **编码与协作**：见 [`references/collaboration-discipline.md`](references/collaboration-discipline.md)；overlay 脚手架见 [`assets/overlay/README.md`](assets/overlay/README.md)。
4. **Process**：产研流水线见项目根 `AGENTS.md` 与 [`references/workflow-pipeline.md`](references/workflow-pipeline.md)；演进 overlay 或共享文档须征得用户同意。
5. **Upstream / downstream**：输入来自 `analyze`；输出面向 `review` 与 `develop`。
6. **流水线硬门禁**：以项目根 `AGENTS.md` 路由 + [`references/workflow-pipeline.md`](references/workflow-pipeline.md) 为准。
7. **内容边界**：`analyze.requirements.md` 只承载需求与验收；`plan.solution.md` 负责落层、设计决策、实现路径与技术取舍。
8. **承接「极简需求清单」**（与 `analyze` 对表）：
   - 需求清单为少量编号条目时，须在 `plan.solution.md` 用 **§0 对表索引** + 后文可验收细则写全约束。
   - **正文为真源**：细则写在对应方案章节，不在文首重复铺陈 §0.1。
   - **元说明禁写**：不写「细节见 plan/analyze」类无验收信息注脚。
   - **措辞**：默认不以「移动端 / iOS 端」作无信息装饰；跨端对照须有必要性。

## On-demand references

- `references/plan-checklist.md`
- `references/risk-gate.md`（用户要求回滚/处置预案时）
- `references/execution-playbook.md`
- `references/layering-appendix-a.md`

## Quick start

- 先读 **分层附录 A** / 项目 overlay 分层文 + execution-playbook「方案规划原则」。
- 方案须显式：落层、依赖方向、兼容口径、数据流影响面。
- **走流水线**时须含 **第 11）测试策略与验证衔接**。

## When not to use

- 仅改文案/UI 且不动分层与接口。
- 无 analyze 上下文且用户拒绝补充。

## Related rules

- 项目根 `AGENTS.md`
- [`references/collaboration-discipline.md`](references/collaboration-discipline.md)
