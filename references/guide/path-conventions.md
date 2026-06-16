# 路径约定（框架仓 vs 安装后）

Skill、references、scripts 在**两种浏览上下文**下路径前缀不同，链接规则如下。

## 两种上下文

| 上下文 | 框架根目录示例 | runs/ 位置 |
|--------|----------------|------------|
| **框架发布仓** | `ios-agent-pipeline/`（本仓库 clone） | 仓库根 `runs/` |
| **业务仓（已 install）** | `.cursor/` 或 `agent-workflow/` 等 | 业务仓根 `runs/` |

安装脚本将 `skills/`、`references/`、`scripts/` 等复制到 IDE 目标目录；**业务证据**始终落在业务仓根 `runs/<slug>/`。

## Skill 内链规则

1. **同 Skill 内**：用相对路径，如 `references/execution-playbook.md`。
2. **跨 Skill**：用相对路径，如 `../plan/SKILL.md`、`../develop/SKILL.md`。
3. **公共 references**：从 `skills/<stage>/` 出发用 `../../references/workflow/pipeline.md`。
4. **项目指南**：写「项目根 `AGENTS.md`」，不要用 `../../../AGENTS.md` 硬链（框架仓内该文件不存在）。
5. **`.cursor/` 前缀**：仅出现在 **AGENTS.md.example** 等业务仓项目指南中；框架 Skill 正文避免硬编码 `.cursor/`。

## 脚本路径

- **权威实现**：`<framework-root>/scripts/`（安装后为 `.cursor/scripts/` 等）。
- **Skill 兼容入口**：`skills/*/scripts/*.sh` 转发至权威实现。
- **repo_root 解析**：见 `scripts/lib/resolve-repo-root.sh`（读取 `framework.manifest.json`）。

## 项目 overlay

业务域分层、编码规范放在业务仓根：

```text
project-overlays/<name>/
├── appendix-a-layers.md
├── coding-conventions.md
└── AGENTS.fragment.md
```

安装：`bash .cursor/scripts/install-framework-to-project.sh cursor --overlay <name>`

## 相关文档

- [cross-platform-deployment.md](cross-platform-deployment.md)
- [skill-subagent.md](skill-subagent.md)
