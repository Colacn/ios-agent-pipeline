---
name: develop
description: Use when implementing approved changes with minimal diff, layered constraints, and local verification. Intended for post-plan/review execution with collaboration discipline and test handoff.
---

# Develop

## Instructions

1. 完整执行规范见 [`references/execution-playbook.md`](references/execution-playbook.md)（**优先通读**）。落盘 `outputs/` 前若目录不存在，执行 [`scripts/bootstrap-run.sh`](scripts/bootstrap-run.sh) `<slug>`（权威实现 [`../../scripts/bootstrap-run.sh`](../../scripts/bootstrap-run.sh)）。
2. **Layering**：[`../plan/SKILL.md`](../plan/SKILL.md) 附录 A + 项目 overlay `project-overlays/*/appendix-a-layers.md`（冲突时以 overlay 为准）。
3. **协作与质量**：见本文件 **Appendix**；项目编码细则见 overlay `coding-conventions.md`（若有）。
4. **流程**：项目根 `AGENTS.md`；走流水线时遵守 execution-playbook「流水线中的本步」。
5. **线程**：UI 主线程；IO/网络回调不阻塞主线程。
6. **Handoff to test**：结构化测试/放行建议交给 `test` Skill。
7. **流水线硬门禁**：项目根 `AGENTS.md` + [`../../references/workflow/pipeline.md`](../../references/workflow/pipeline.md)。
8. 跳过 `review`/`test` 时的替代门禁见 execution-playbook 与项目 `AGENTS.md`。
9. **develop 出口（强制）**：落盘 `developer.implementation.md` → **reconcile-docs**（对照 `git diff` 回写 requirements/plan）。模板 [`../../templates/developer-implementation-template.md`](../../templates/developer-implementation-template.md)。建议执行 `bash scripts/reconcile-check.sh <slug>`。

## On-demand references

- `references/execution-gate.md`
- `references/delivery-checklist.md`
- `references/execution-playbook.md`

## When not to use

- 评审阻塞未解除仍强行开发。
- 关键决策未决（先上游 Skill）。

---

## Appendix

### 协作与质量纪律（10条）

适用于日常开发与 AI 协作；与项目根 `AGENTS.md`、plan 分层约定配合。未走流水线时仍适用。

**走产研流水线**时：按 plan/review 约定测试范围执行并回报证据。

1. **先定边界再开工** — 明确「改什么 / 不改什么 / 如何验收」。
2. **小步提交思维** — 一次一个问题；用户要求时再补回滚预案。
3. **先读调用链** — 确认入口、数据模型、存储、渲染与回调。
4. **关键路径可验证** — 能说清验收方式（测试、手测、编译回归）。
5. **兼容性前置** — 接口/字段变更先定义兼容策略。
6. **不破坏主线程** — UI 主线程；IO/网络不阻塞主线程。
7. **统一错误语义** — 错误码、日志、用户提示一致。
8. **复用优先于复制** — 先检索既有抽象。
9. **每次改动带验证** — 至少编译与相关回归。
10. **输出可追踪结论** — 改动文件、原因、风险、验证、TODO。

#### 协作输出模板（推荐）

1. 当前理解：<一句话>
2. 待你决策：<阻塞项>
3. 默认推进：<可默认项>
4. 下一步：<动作与验证>

### 编码规范（框架通用）

> 项目 team 可在 `project-overlays/<name>/coding-conventions.md` 覆盖或扩展下列条目。

- **最小改动**：不扩大影响面，不做无关重构。
- **匹配既有风格**：命名、目录、语言（OC/Swift）与被改文件一致。
- **分层**：遵守 plan / overlay 落层；不新造平行入口。
- **列表与 UI**：热路径避免重 IO；布局阶段考虑 0 尺寸兜底。
- **交付回报**：改动文件、风险点、验证结果；纯重排须声明逻辑未变。

overlay 脚手架（无业务语义）：[`../../templates/overlay/sample/`](../../templates/overlay/sample/) — 复制到业务仓后改名使用。
