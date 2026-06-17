---
name: test
description: Use this skill when validating code changes after develop-stage delivery, including regression focus, release gating, and traceable test evidence. It outputs test reports or ledgers and supports AskQuestion-based issue intake for ambiguous or manual acceptance findings.
---

# Test

## Instructions

1. 完整执行规范见 [`references/execution-playbook.md`](references/execution-playbook.md)（**优先通读**）。落盘 test 报告/台账前，若尚无 `runs/<slug>/outputs/`，执行 [`../../scripts/bootstrap-run.sh`](../../scripts/bootstrap-run.sh) `<slug>`。
2. **Inputs**：验收 Given/When/Then、`develop` 改动清单、兼容说明、发布约束；若用户明确要求，再纳入回滚/处置预案说明。
3. **分层对照**：[`../plan/SKILL.md`](../plan/SKILL.md) 附录 A + 项目 overlay（若有）。
4. **Evidence**：结论须可复现；未测范围必须写明。
5. **Escalation**：阻塞级 → `develop`；方案/闸门问题 → `review` / `plan`。
6. **落盘强制**：每次执行结束必须生成/更新测试文档并返回路径（有问题输出台账，无问题输出结论）。
7. **手动补录**：用户出现“追加台账/补录问题/添加问题”等意图时，先用 `AskQuestion` 结构化采集，再按 `references/execution-playbook.md` 与 `references/manual-intake.md` 写入同一台账，不覆盖历史。
8. **流水线硬门禁**：项目根 `AGENTS.md` + [`../../references/workflow/pipeline.md`](../../references/workflow/pipeline.md)。
9. **test** 报告与台账的分工与落盘细则以 `references/execution-playbook.md` 为准（报告定稿、台账追踪）。

## On-demand references（按需读取）

- 需要快速落盘台账/报告时：读取 `references/report-and-ledger-checklist.md`
- 需要手动补录问题（人工验收后）时：读取 `references/manual-intake.md`
- 需要完整 SOP（验证流程/落盘规则/补录规则）时：读取 `references/execution-playbook.md`

## Workflow（可勾选）

- [ ] 主路径 / 边界 / 异常优先级  
- [ ] 兼容或历史路径至少一条  
- [ ] 放行结论 + 残余风险  
- [ ] 下一轮回归最小集合（若窗口紧）  
- [ ] 文档已落盘并返回路径  
- [ ] **文档与实现一致**（implementation + plan + requirements 对表 git diff）  
- [ ] 手动唤起时已完成台账追加（如适用）  
- [ ] 手动补录已使用 AskQuestion 完成字段采集（如适用）  

## When not to use

- 无改动说明且无验收线索、无法补材料。

## 手动追加触发词（建议）

- “追加台账”
- “补录问题”
- “把人工验收问题加到台账”
- “append ledger: <台账路径>”

## Related rules

- 项目根 `AGENTS.md`
- [`../develop/SKILL.md`](../develop/SKILL.md) Appendix
