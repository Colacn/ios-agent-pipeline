---
name: review
description: Use this skill when evaluating analyze/plan outputs before implementation, especially for feasibility, risk, security, performance, compatibility, and testability gates. It produces evidence-based pass, conditional pass, or fail conclusions.
---

# Review

## Instructions

1. 完整执行规范见 [`references/execution-playbook.md`](references/execution-playbook.md)（**优先通读**）。**runs 工区**：落盘 **review** 闸门 `outputs/review.gate.md` 前，若工区目录不存在，执行 [`scripts/bootstrap-run.sh`](scripts/bootstrap-run.sh) `<slug>`（与其他 Skill 同源）。
2. **Inputs**：`analyze` + `plan` 产出；补充人类约束（窗口、合规、性能等）。
3. **分层对照**：[`../plan/SKILL.md`](../plan/SKILL.md) 附录 A + 项目 overlay（若有）。
4. **Ruling**：给出 `通过` / `有条件通过` / `不通过`；关键发现须带**证据**与阻塞性；必改 vs 建议分离。
5. Heavy reviews：可按 execution-playbook「多视角评审（可选）」组织。
6. **流水线硬门禁**：项目根 `AGENTS.md` + [`../../references/workflow/pipeline.md`](../../references/workflow/pipeline.md)。
7. **极简需求清单的闸门**（**analyze** 产出为短表时）：若需求清单为**短编号条**，须核对 `plan` 是否已有 **§0 对表索引** 且**每条**在**后文设计/范围/测试等章节**中可找到可验收落点，避免「需求只有四条、方案缺了条数/分档/兼容」类缺口；**不**以单独「§0.1 细则承接」大段与正文是否重复为替代标准。对照 `plan` Skill 第 8 条与 `analyze` 需求清单体例。

## On-demand references（按需读取）

- 需要快速执行闸门判断时：读取 `references/review-gate-checklist.md`
- 需要统一评审等级口径时：读取 `references/ruling-criteria.md`
- 需要完整 SOP（输入范围/评审模板/执行顺序）时：读取 `references/execution-playbook.md`

## Review checklist（速览）

- 风险是否有缓释与残余说明
- 可行性（分层、依赖、验证闭环）
- 安全、性能、兼容是否可执行；用户明确要求时再审回滚/处置预案
- 验收 Given/When/Then 是否可测
- **走流水线**：`plan` 方案**第 11）**是否明确测试范围、关键场景与自动化落点；若为「无新增自动化要求」时理由是否成立

## When not to use

- 无 `analyze` / `plan` 可评材料且拒绝补充。
- 用户明示跳过评审（须在对话中记录）。

## Related rules

- 项目根 `AGENTS.md`
- [`../develop/SKILL.md`](../develop/SKILL.md) Appendix
