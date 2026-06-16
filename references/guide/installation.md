# 框架安装与迁移

> **IDE 中立**：`.cursor/` 为本仓库默认目录名；Claude Code / Codex / skills.sh 安装方式见 [cross-platform-deployment.md](cross-platform-deployment.md)。

## 设计原则

1. **框架自包含**：`skills/`、`agents/`、`references/`、`scripts/`、`templates/` 即可运行，无 npm/pod 依赖。
2. **零第三方插件绑定**：框架内不启用 Superpowers 等；第三方规则由项目 `AGENTS.md` / `CLAUDE.md` 自行扩展。
3. **多 IDE 可部署**：同一内容可落盘到 `.cursor/`、`.claude/`、`.codex/agent-workflow/` 或 `agent-workflow/`。

## 新机器 / 新项目安装

### 步骤 1：获取并安装

```bash
# 方式 A：从本 monorepo 安装到当前项目（可多 target）
bash .cursor/scripts/install-framework-to-project.sh all

# 方式 B：从独立分发仓
git clone <framework-repo> /tmp/ios-agent-pipeline
cd your-app && bash /tmp/ios-agent-pipeline/scripts/install-framework-to-project.sh cursor
```

| 方式 | 适用 |
|------|------|
| `install-framework-to-project.sh` | **推荐**；支持 cursor / claude / codex / neutral |
| 复制 `.cursor/` 目录 | 仅 Cursor 或已熟悉结构时 |
| `npx skills add ...@analyze` | 单 Skill；需另装 references/scripts |
| `export-distribution-layout.sh` 产出物 | 开源发布、内网镜像 |

### 步骤 2：项目指南

创建或合并根目录 `AGENTS.md`（Claude Code 可用 `CLAUDE.md`）：

- 链接到 `references/workflow/pipeline.md`、`grading.md`
- 写本项目验证命令（如 xcodebuild）
- **可选**：第三方 Agent 插件/skills 与流水线的优先级

### 步骤 3：可选 hooks

```bash
bash setup-hooks.sh
```

### 步骤 4：冒烟验证

```bash
bash .cursor/scripts/bootstrap-run.sh smoke-test    # 路径随 IDE 调整
bash .cursor/scripts/check-run.sh smoke-test
```

## 换机迁移检查清单

- [ ] 框架目录完整（`.cursor/` 或 `agent-workflow/` 等，含 scripts 可执行权限）
- [ ] 项目指南 `AGENTS.md` / `CLAUDE.md` 已同步
- [ ] 不依赖 IDE 专属插件配置文件
- [ ] 进行中需求：`runs/<slug>/` 随项目 git 迁移

## 维护

框架升级时 diff `references/` 与 `skills/*/execution-playbook.md`；详见 [maintain.md](maintain.md)。
