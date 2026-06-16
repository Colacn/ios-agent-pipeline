# 维护约定

## 框架层 vs 项目层

- **框架层**（`.cursor/` 或 `agent-workflow/` 等）：流水线 SOP、脚本、模板；IDE 中立，**不**写入第三方 Agent 插件配置。
- **项目层**（根 `AGENTS.md` / `CLAUDE.md`、`.cursor/rules/*.mdc`）：团队偏好、业务域、可选第三方工具规则。

## 同步规则

- 改仓库级长期规则、验证基线、安全红线时：同步更新仓库根 `AGENTS.md` 摘要与 `references/rules/stable-rules.md`
- 改流水线或门禁时：同步更新 `references/workflow/*` 与相关 `agents/*`、`skills/*`
- 改结构基线时：同步更新 `references/structure/*`
- 模板改动统一在 `templates/*` 维护，引用处只保留链接
