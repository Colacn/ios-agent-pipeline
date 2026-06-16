# 分发与发布指南

> 将自研工作流发布到 **skills.sh**、**Git 分发包**、**Cursor Marketplace** 等通道；**不绑定单一 IDE**。

## 通道总览

| 通道 | 典型命令 / 入口 | 安装内容 | 适用 |
|------|-----------------|----------|------|
| **Git + 安装脚本** | `install-framework-to-project.sh` | skills + agents + references + scripts + templates | **全功能首选** |
| **skills.sh** | `npx skills add <owner/repo>@analyze` | 通常单个 Skill 目录 | 按阶段发现、轻量安装 |
| **中立目录** | `install-framework-to-project.sh neutral` | `agent-workflow/` | Codex / 自定义 IDE 适配 |
| **Cursor Marketplace** | IDE 内 Marketplace | skills + agents + rules（需再跑落地脚本） | Cursor 用户发现 |

详细 IDE 对照见 [cross-platform-deployment.md](cross-platform-deployment.md)。

---

## 推荐发布仓结构（IDE 中立）

由导出脚本生成，**不要**与 iOS 业务仓混杂：

```bash
bash .cursor/scripts/export-distribution-layout.sh /path/to/ios-agent-pipeline
```

```text
ios-agent-pipeline/
├── framework.manifest.json
├── skills/              # analyze, plan, review, develop, test
├── agents/
├── references/
├── scripts/
├── templates/
├── rules/
├── README.md
└── .cursor-plugin/      # 可选：仅 Cursor Marketplace 通道
    └── plugin.json
```

---

## 通道 A：skills.sh

- 站点：[skills.sh](https://skills.sh/)
- 安装示例：

```bash
npx skills add your-org/ios-agent-pipeline@analyze -g -y
npx skills add your-org/ios-agent-pipeline@plan -g -y
```

- 发布要求：公开 Git 仓，`skills/<name>/SKILL.md` 符合 [Agent Skills 开放格式](https://skills.sh/)
- **限制**：agents、references、scripts 不会随 `@analyze` 自动进项目 → 用户仍需 clone 整包或跑 `install-framework-to-project.sh`

**建议**：skills.sh 提供五个 `@skill` 入口；README 指向整包安装命令。

---

## 通道 B：Git 分发包（全功能）

```bash
git clone https://github.com/your-org/ios-agent-pipeline.git
cd your-ios-app
bash /path/to/ios-agent-pipeline/scripts/install-framework-to-project.sh all
```

支持 `cursor` | `claude` | `codex` | `neutral` | `all`。

---

## 通道 C：Cursor Marketplace（可选）

非必须。仅服务 Cursor 用户的**发现与一键加载 skills/agents**。

1. 使用 `export-distribution-layout.sh` 产出目录（含 `.cursor-plugin/plugin.json`）
2. 推送到公开 Git 仓库
3. 本地验证：`git clone ... ~/.cursor/plugins/local/ios-agent-pipeline`
4. 提交 [cursor.com/marketplace/publish](https://cursor.com/marketplace/publish)

**注意**：Marketplace 安装后须在业务项目执行：

```bash
bash /path/to/ios-agent-pipeline/scripts/install-framework-to-project.sh cursor
```

以补齐 `references/`、`scripts/`、`templates/`。

---

## 发布前自检

- [ ] `framework.manifest.json` version 已 bump
- [ ] 五个 Skill frontmatter（`name`、`description`）完整
- [ ] 框架 SOP 无第三方插件硬依赖
- [ ] `bash scripts/check-run.sh <sample-slug>` 可执行（在含 runs 样本的测试仓）
- [ ] README 含：Git 安装、skills.sh、多 IDE target 说明
- [ ] Claude Code / Codex 用户说明 `INSTALL_GLOBAL` 与项目 bundle 路径

---

## 版本更新

1. 修改 `framework.manifest.json` 与 `.cursor-plugin/plugin.json` 的 `version`
2. 重新 `export-distribution-layout.sh` 并 push
3. skills.sh：用户 `npx skills update`
4. Marketplace：按平台流程提交更新审核

---

## 相关文档

- [cross-platform-deployment.md](cross-platform-deployment.md)
- [installation.md](installation.md)
- [../../README.md](../../README.md)
