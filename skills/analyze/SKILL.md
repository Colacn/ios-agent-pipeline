---
name: analyze
description: Use this skill when the user needs intent clarification, ambiguity resolution, or structured analysis without implementation advice. It asks clarifying questions when uncertain and analyzes only user-provided information after confirmation; use PRD-style packaging only when explicitly requested.
---

# Analyze

**入口约定**：`analyze` 为本 Skill 名。主会话用 **`/analyze`** 即直接加载本能力；在 Cursor 中若以 **子代理** 运行（`analyst` / `Task(subagent_type="analyst", …)`），**仍只按本文件与 `execution-playbook` 执行** — `analyst` 是子代理名，不是第二套方法。详见 [`.cursor/references/guide/skill-subagent.md`](../../references/guide/skill-subagent.md)。

## Instructions

1. 完整执行规范见 [`references/execution-playbook.md`](references/execution-playbook.md)（**优先通读**）。默认是**分析型交付**（不建言）；**附录 A** 仅在用户明确要求需求包/下游交接时启用。**走流水线**时另须遵守 [`AGENTS.md`](../../../AGENTS.md)「产研流水线与工作流」与 **「流水线预处理」**：首轮识别是否有外部依据；有则 `scripts/bootstrap-run.sh` + `ingest-external-to-inputs.sh` / `record-urls-to-inputs.sh`；无则延后在首次落盘需求清单前 `bootstrap-run.sh`。脚本目录：[`scripts/`](scripts/)（权威实现位于 `../../scripts/`，本目录仅保留兼容入口）。
2. 按 `references/execution-playbook.md`「输入源与解析范围」收拢信息；截止窗口、Out of Scope 等若用户提到则纳入**边界**说明，不据此替用户做取舍建议。
3. 不确定时优先走「轮次 A — 待澄清」；确认后再「轮次 B — 分析交付」。**待确认**须全量或约定后续轮次续问（见 execution-playbook）。
4. 流水线内遇到口径歧义时，按 `references/execution-playbook.md`「单题对齐协议」执行：**按阻塞项澄清、确认即落盘、阻塞项未清不进 plan 阶段**。
5. **Planning files**：写入仓库前须按 [`AGENTS.md`](../../../AGENTS.md)「执行前确认」征得用户同意。
6. **与下游**：仅当用户明确要求规格化需求包时，输出才需便于 `plan` Skill 对表；否则不要求对齐需求八节。
7. **流水线硬门禁**：以 [`AGENTS.md`](../../../AGENTS.md) 路由总览 + [`../../references/workflow/pipeline.md`](../../references/workflow/pipeline.md) 细则为准；本 Skill 仅补充 analyze 侧特有执行细则。
8. **内容边界（硬性）**：**analyze** 需求清单（`outputs/analyze.requirements.md`）只写“要什么 + 验收口径 + 业务约束/范围”，不写技术实现细节；实现方案、落层、类方法设计与技术取舍统一交给 **plan** 技术方案（`outputs/plan.solution.md`）。
9. **需求清单体例（定稿向）**（与 **analyze** 落盘时默认遵循）：
   - **形态**：以**极短主标题**（如《需求清单》）+ **编号要点清单**为默认，一条需求一行/一段即可；不堆长表、不抄 PRD 全文；**分档、条数、入口与工程约束**不在本文件展开。
   - **与方案分工**：凡需写清的「入口条件、多选/体积边界、分档、数据字段、状态机、用例、测试」等，一律视为**已迁入** **plan** 的 `outputs/plan.solution.md`（及后续 **test** 产出），**需求清单不补写**「本文件只列 N 条、细节见方案」等元注脚，除非用户或流水线明确要求。
   - **措辞**：不写「移动端 / iOS / Android」等**平台表面词**作标题或装饰；仅在**多端正面对比、跨端差异**时点名平台。单仓单端语境下用**中性表述**（功能名、范围名）即可。
   - **来源与引用**：用**一句**可定位来源即可（如 PRD 路径）。**不**在需求清单中引用仓库内**已删除或不存在**的旁路文件；若可检索/摘录物不存在，不虚构链接。

## Scripts（runs 工区）

- [`scripts/bootstrap-run.sh`](scripts/bootstrap-run.sh)：创建 `/runs/<slug>/{inputs,outputs}`。
- [`scripts/ingest-external-to-inputs.sh`](scripts/ingest-external-to-inputs.sh)：将本地路径归档到 `inputs/`（默认复制，`--move` 可迁移）。
- [`scripts/record-urls-to-inputs.sh`](scripts/record-urls-to-inputs.sh)：将 URL 追加到 `inputs/source-urls.md`。

## On-demand references（按需读取）

- 需要完整分析流程、输出结构、禁止项时：读取 `references/playbook-map.md`
- 用户明确要需求包或下游交接格式时：读取 `references/handoff-checklist.md`
- 需要完整 SOP（流程/澄清/定稿/附录 A）时：读取 `references/execution-playbook.md`

## When not to use

- 用户要的是**写代码、出方案规划**（见 `develop` / `plan` Skill）。
- 用户明确要**评审、拍板、给实施方案**（见 `review` 等 Skill，而非本 Skill 默认模式）。
- 与项目/任务无关的闲聊。

## Related rules

- `AGENTS.md`（产研流水线与工作流、执行前确认）
- `.cursor/skills/develop/SKILL.md` **Appendix**「协作与质量纪律」（横切工程习惯）
