# Skill 与 Subagent 使用指南

## 一句话口径

- **Skill** 定义能力与方法（跨 IDE 一致）
- **Subagent / 子代理** 是部分 IDE 的**调用通道**（隔离上下文；Cursor 等使用 `analyst` 等历史名）
- 项目指南（`AGENTS.md` / `CLAUDE.md`）负责仓库级规则与路由
- **框架层**不含第三方插件配置

各 IDE 入口对照：[ide-adapters.md](ide-adapters.md)

## 关系

- Skill 管「怎么做」（唯一长 SOP：`SKILL.md` + `execution-playbook.md`）
- Subagent 文件不另写 SOP，只**指向** Skill
- 同一能力可有多种进入方式（斜杠 Skill 名、Subagent 名、Skill 工具加载）

## analyze 示例（其它阶段同理）

| 方式 | 含义 | 实际执行 |
| --- | --- | --- |
| Skill 名 `analyze` | 主会话直接加载 analyze Skill | 本 skill 的 `SKILL.md` + `references/execution-playbook.md` |
| Subagent 名 `analyst` | Cursor 等 IDE 的子代理入口 | **内部仍按** analyze Skill 同一套 SOP |

结论：**`analyze` = Skill 名；`analyst` = Subagent 名**，绑定同一能力。

其它：`plan` ↔ `planner`，`review` ↔ `reviewer`，`develop` ↔ `developer`，`test` ↔ `tester`。

## 选择建议

- 不拆会话：优先 Skill 名入口（如 `/analyze` 或 IDE 等价方式）
- 需子任务隔离：用 Subagent / 子代理，**内部仍**加载同一 Skill
- 文档出现旧名（`/analyst` 等）时，与 Skill 名 **同序同能力**

## 推荐工作方式

人来路由，Agent 来执行，Skill 来稳定，人来验收。
