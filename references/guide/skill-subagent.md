# Skill 与 Subagent

## 主流路径（所有 IDE）

- **Skill** = 能力定义（`SKILL.md` + `references/` + `scripts/`）
- 安装：`npx skills add owner/repo@analyze -y`
- 落盘：`.agents/skills/analyze/`（skills CLI 统一目录，各 IDE symlink）

**不需要** Subagent 文件即可使用。

## Subagent（可选，主要 Cursor）

- `agents/analyst.md` 等 = **IDE 适配层**，非 Agent Skills 标准
- 作用：子代理隔离上下文；**不另写 SOP**，只指向对应 Skill
- 安装：`bash install-skill.sh analyze --with-agents cursor` 或整包 `--with-agents`

| Skill | Subagent（Cursor 等） |
|-------|----------------------|
| analyze | analyst |
| plan | planner |
| review | reviewer |
| develop | developer |
| test | tester |

## 选择

- **通用 / skills.sh**：只用 Skill 名，主会话或 Skill 工具加载
- **Cursor 子任务隔离**：`--with-agents` 装 `agents/`，入口 `/analyst` 等

人来路由，Skill 定 SOP，人来验收。
