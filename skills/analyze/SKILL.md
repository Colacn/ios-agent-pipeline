---
name: analyze
description: Use this skill when the user needs intent clarification, ambiguity resolution, or structured analysis without implementation advice. It asks clarifying questions when uncertain and analyzes only user-provided information after confirmation; use PRD-style packaging only when explicitly requested.
---

# Analyze

**入口约定**：`analyze` 为本 Skill 名。主会话 **`/analyze`** 或子代理 `analyst` **均只按本文件与 execution-playbook 执行**。详见 [`../../references/guide/skill-subagent.md`](../../references/guide/skill-subagent.md)。

## Instructions

1. 完整执行规范见 [`references/execution-playbook.md`](references/execution-playbook.md)（**优先通读**）。**走流水线**时遵守项目根 `AGENTS.md`「流水线预处理」：有外部依据则 [`../../scripts/bootstrap-run.sh`](../../scripts/bootstrap-run.sh) + ingest/record-urls；否则首次落盘前 bootstrap。
2. **路由决策（首轮）**：按 [`../../references/workflow/grading.md`](../../references/workflow/grading.md) 判定 L0–L3；L1 轻量通道可不建 `runs/`（见 execution-playbook「路由决策」）；L2+ 或用户显式流水线入口须 bootstrap 并落盘。
3. 按 execution-playbook「输入源与解析范围」收拢信息。
4. 不确定时走「轮次 A — 待澄清」；确认后「轮次 B — 分析交付」。
5. 流水线内口径歧义按「单题对齐协议」：**阻塞项未清不进 plan**。
6. 写入仓库前须按项目 `AGENTS.md`「执行前确认」征得用户同意（若适用）。
7. **流水线硬门禁**：项目根 `AGENTS.md` + [`../../references/workflow/pipeline.md`](../../references/workflow/pipeline.md)。
8. **内容边界**：`analyze.requirements.md` 只写要什么 + 验收 + 范围；技术细节交给 **plan**。
9. **需求清单体例**：极短标题 + 编号要点；不堆平台词；不引用不存在的旁路文件。

## Scripts（runs 工区，bundle 根 `scripts/`）

- [`../../scripts/bootstrap-run.sh`](../../scripts/bootstrap-run.sh)
- [`../../scripts/ingest-external-to-inputs.sh`](../../scripts/ingest-external-to-inputs.sh)
- [`../../scripts/record-urls-to-inputs.sh`](../../scripts/record-urls-to-inputs.sh)

## On-demand references（按需读取）

- 需要完整分析流程、输出结构、禁止项时：读取 `references/playbook-map.md`
- 用户明确要需求包或下游交接格式时：读取 `references/handoff-checklist.md`
- 需要完整 SOP（流程/澄清/定稿/附录 A）时：读取 `references/execution-playbook.md`

## When not to use

- 用户要的是**写代码、出方案规划**（见 `develop` / `plan` Skill）。
- 用户明确要**评审、拍板、给实施方案**（见 `review` 等 Skill，而非本 Skill 默认模式）。
- 与项目/任务无关的闲聊。

## Related rules

- 项目根 `AGENTS.md`
- [`../develop/SKILL.md`](../develop/SKILL.md) Appendix「协作与质量纪律」
- [`../../references/guide/path-conventions.md`](../../references/guide/path-conventions.md)
