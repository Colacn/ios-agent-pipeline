# 与 skills.sh / Agent Skills 标准对照

> 规范：[agentskills.io/specification](https://agentskills.io/specification)

## 主流安装（唯一必需）

```bash
npx skills add Colacn/agent-pipeline@analyze -y
```

落盘 `.agents/skills/analyze/`（skills CLI 统一目录）。**不含** `agents/`。

## 单 skill 最小结构（v0.6.1+）

每阶段只 vendoring **本阶段必需** 的 references，不五份复制相同附录。

```text
skills/analyze/
├── SKILL.md
├── references/       # 仅 analyze 相关（pipeline、grading、playbook…）
├── scripts/
└── assets/             # 通常为空
```

## 可选增强（非 skills.sh 标准）

| 增强 | 命令 | 用途 |
|------|------|------|
| Cursor Subagent | `install-skill.sh analyze --with-agents` | `agents/analyst.md` 薄路由 |
| 项目 AGENTS.md | `--init-agents` | 流水线总入口 |
| 旧 bundle 布局 | `--with-legacy-bundle` | 根级 `references/scripts/templates` |

## 维护

1. 改 `references/workflow/`、`scripts/`、`templates/vendor/`
2. `bash scripts/sync-skill-vendor.sh`（按阶段复制，非全量）
3. 提交 `skills/*/`

## 相关

- [skill-subagent.md](skill-subagent.md) — Skill vs Subagent
- [distribution.md](distribution.md)
