# Develop 执行细则

> 本文件为 **develop** Skill 的完整执行规范。与主会话或子代理调用方式无关，执行时以本文为准。

## 定位

将已对齐范围与验收落成可合并实现，遵循最小改动、分层约束与可验证交付。

## 流水线中的本步（落地实现）

- 先过执行前确认门禁，再动代码。
- 落盘实现说明前，如工区未建先补建 `runs/<slug>/outputs/`。
- 依据证据基线读取方案与评审结论，避免实现口径静默漂移。
- 按方案约定测试范围完成实现与回归；若方案明确“无新增自动化要求”，按常规验证推进。

## 跳步替代门禁（用户明示跳过 review / test）

- 跳过 `review`：补风险清单、兼容影响、测试范围、未决项处理、跳过理由。
- 跳过 `test`：补最小回归集、验证证据、残余风险、放行口径、跳过理由。
- 缺任一项，不给“可推进/可放行”结论。

## 执行前确认（强制）

改仓库/改环境前必须说明：改动意图、范围、风险、验收方式，并征得用户同意。  
只读任务或 `AGENTS.md` 约定的低风险快速通道可按例外处理，但需事后补充验证说明。

## 输入与依赖

1. 需求目标、范围、验收、Out of Scope
2. 方案落层、接口与兼容策略（及第 11 节测试衔接）
3. 工程约束（主线程/分层/一致性）
4. 质量门禁（编译与关键路径验证）

阻塞项需通过 `AskQuestion` 逐项确认，不得跳过确认直接实现。

## 实施流程

1. 复述目标与边界，明确本轮测试范围。
2. 梳理调用链与影响面。
3. 设计最小改动方案。
4. 实现并保持错误语义/日志口径一致。
5. 完成编译与关键验证并记录结果。
6. 落盘 `runs/<slug>/outputs/developer.implementation.md`（模板见 `.cursor/templates/developer-implementation-template.md`）。
7. 执行 **reconcile-docs**（见下节）。
8. 按交付结构回报。

## reconcile-docs（流水线强制）

develop 代码完成后、移交 test 前执行：

1. 填写 `developer.implementation.md` §2（与 plan 差异）与 §3（新增决策）。
2. 对照 `git diff` 与 implementation，**局部修订**：
   - `outputs/analyze.requirements.md`：补全验收口径与 develop 阶段决策（不写实现细节堆砌）。
   - `outputs/plan.solution.md`：更新为终态（删除「待 Toast」「T3 阻塞」等过时表述；补实现索引）。
3. 在 implementation §8 勾选 reconcile 确认项。
4. 禁止只改 chat 不改 `runs/outputs/`。

**触发条件**：plan 与实现不一致、develop 中新增/变更决策、多轮对话对齐口径时必做。

## 编码约束（摘要）

- 不跨层直连抄近道
- UI 主线程，重逻辑不阻塞主线程
- 优先复用既有抽象
- 协议/字段改动先定义兼容与降级策略

## 交付物结构

A. 实现概述  
B. 代码改动清单  
C. 风险与兼容（用户明确要求时补回滚/处置预案）  
D. 验证结果（含测试范围对齐情况）  
E. 待确认（仅阻塞项）  
F. 跳步替代留痕（按需）  
G. **`developer.implementation.md` 路径 + reconcile 完成确认**（流水线必填）

## 升级与协同

- 方案不清：回 `plan`
- 闸门/风险：`review`
- 放行建议：交 `test`

## 禁止项

- 验收未对齐即大范围改动
- 无验证宣称完成
- 无证据宣布根因/风险已消除
- 存在阻塞歧义却不使用 `AskQuestion`
- 未落盘 `developer.implementation.md` 或未 reconcile 即宣称可进入 test
