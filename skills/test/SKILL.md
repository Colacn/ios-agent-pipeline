---
name: test
description: Use this skill when validating code changes after develop-stage delivery, including regression focus, release gating, and traceable test evidence. It outputs test reports or ledgers and supports AskQuestion-based issue intake for ambiguous or manual acceptance findings.
compatibility: Requires bash and git in the business repository.
metadata:
  author: agent-pipeline
  version: "0.6.1"
---

# Test

## Instructions

1. 完整执行规范见 [`references/execution-playbook.md`](references/execution-playbook.md)。落盘前执行 [`scripts/bootstrap-run.sh`](scripts/bootstrap-run.sh) `<slug>`（若尚无 outputs）。
2. **Inputs**：验收 Given/When/Then、`develop` 改动清单、兼容说明。
3. **分层对照**：[`references/layering-appendix-a.md`](references/layering-appendix-a.md) + overlay（若有）。
4. **Evidence**：结论须可复现；未测范围必须写明。
5. **流水线**：[`references/workflow-pipeline.md`](references/workflow-pipeline.md)。
6. **落盘**：每次结束须生成/更新 `test.report.md` 或台账；手动补录见 `references/manual-intake.md`。
7. develop 出口后建议 `bash scripts/check-run.sh <slug>`。

## On-demand references

- `references/report-and-ledger-checklist.md`
- `references/manual-intake.md`
- `references/execution-playbook.md`

## When not to use

- 无改动说明且无验收线索、无法补材料。
