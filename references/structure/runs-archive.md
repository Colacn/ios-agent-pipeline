# runs 产物归档规则

## 目录语义

- `runs/<short-slug>/inputs/`：外部依据、原始材料
- `runs/<short-slug>/outputs/`：各角色交付物

## 文件建议

> **命名规范（硬性）**：`outputs/` 下文件名必须使用 **Skill 名**前缀（`analyze` / `plan` / `review` / `develop` / `test`），**禁止**使用 Subagent 名（`analyst` / `planner` / `reviewer` / `tester`）作为落盘前缀。

- `analyze.requirements.md`
- `plan.solution.md`
- `review.gate.md`
- `developer.implementation.md`（develop **必交付**；模板见 `.cursor/templates/developer-implementation-template.md`）
- `test.report.md`
- `test.ledger.md`（问题台账）
- `plan.task-breakdown.md`（可选；任务拆解补充，非流水线必选）

## develop 出口与文档回写

1. develop 结束须落盘 `developer.implementation.md`（记录与 plan 差异、落点索引、验证结果）。
2. 执行 **reconcile-docs**：对照 `git diff` 更新 `analyze.requirements.md`、`plan.solution.md`，避免方案滞后于代码。
3. test 阶段检查：implementation 存在、plan 无过时「待实现」表述、落点索引与代码一致。

## 基本约束

- 不按角色再拆多层 inputs/outputs
- 中间产物统一落在同一 `outputs/`
- 同一角色同一需求优先局部修订

## inputs 大文件与 git 策略

### 是否进 git

| 类型 | 建议 | 说明 |
|------|------|------|
| PRD / 方案 md、小体积截图 | **进 git** | 便于证据溯源与跨会话恢复 |
| PDF、设计稿、大体积 png/psd | **视体积而定** | 单文件 < ~2MB 且团队需共享时可进；否则放 `inputs/` 本地 + 在 `outputs/analyze.requirements.md` 写摘要与路径 |
| 含密钥/内网-only 材料 | **不进 git** | 仅本地 `inputs/` 或脱敏摘要进 `outputs/` |

当前仓库历史样本（如 `runs/*/inputs/*.pdf`）已纳入 git；**暂不新增** `.gitignore` 规则忽略 `runs/**/inputs/*.{pdf,png}`，以免与既有样本冲突。若后续单 run 体积过大，可在该 run 的 `inputs/README.md` 说明「原件在网盘/本地路径」，并只提交文本摘要。

### 完成后归档

- **长期保留**：`outputs/` 下各阶段定稿（analyze / plan / review / developer / test）。
- **可选摘要**：任务关闭后，可将结论性摘要写入 [`.cursor/milestones/`](../../milestones/)（按 milestone Skill 命名），便于跨分支检索；**不**强制删除 `runs/<slug>/`。
- **清理 inputs**：大文件在 milestone 或 handoff 已摘要后可从工作区移除，但删除前须确认无未回写的验收口径依赖该原件。
