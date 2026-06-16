# 新会话背景包（ios-agent-pipeline）

> **用途**：在新 Cursor / Claude Code / Codex 会话的第一条消息中，复制下方「会话提示词」整段发送，即可在无跨会话记忆的情况下继续本框架相关工作。  
> **本仓库**：https://github.com/Colacn/ios-agent-pipeline

---

## 一、这是什么

**ios-agent-pipeline** 是一套 **IDE 中立** 的文档驱动 Agent 产研流水线框架，不是 iOS 业务 App 本身。

默认流水线：

```text
analyze → plan → review → develop → reconcile-docs → test
```

- **Skill 名**（落盘、文档规范）：`analyze` / `plan` / `review` / `develop` / `test`
- **Subagent 名**（部分 IDE 的历史入口）：`analyst` / `planner` / `reviewer` / `developer` / `tester` — 与 Skill **同能力**，不是第二套 SOP

---

## 二、产品目标（长期）

1. **可移植**：Skill + references + scripts + templates 为统一内容；换电脑 / 换 IDE 可复现。
2. **多通道分发**：Git 克隆 + 安装脚本（主路径）、[skills.sh](https://skills.sh/)、可选 Cursor Marketplace。
3. **不与 Cursor 强绑定**：可装到 Cursor、Claude Code、Codex；**框架内不含 Superpowers 等第三方插件逻辑**。
4. **项目层可叠加**：业务域、验证命令、可选第三方工具规则写在业务仓 `AGENTS.md` / `CLAUDE.md`，不写进本框架仓。

---

## 三、架构分层

| 层级 | 位置 | 职责 |
|------|------|------|
| **框架层** | 本仓库（或安装后的 `.cursor/` / `.claude/` / `agent-workflow/`） | SOP、Skill、脚本、模板、公共 references |
| **项目层** | 业务仓根 `AGENTS.md` / `CLAUDE.md` | 团队偏好、业务域约束、项目验证命令 |
| **工区** | 业务仓 `runs/<slug>/{inputs,outputs}/` | 单次需求的证据与交付物 |

---

## 四、框架与项目层边界

- **本仓只含框架**：SOP、Skill、脚本、模板、公共 references；**不含**具体 App 源码或团队业务 overlay。
- **项目层在应用仓**：`AGENTS.md` / `CLAUDE.md`、`project-overlays/<name>/`、验证命令、分层表由使用方自行维护。
- **避免 SOP 分叉**：应用仓若内嵌 `.cursor/` 工作流，应通过 **install 脚本从本仓同步**，不要与框架各维护一套。

---

## 五、本仓库结构

```text
ios-agent-pipeline/
├── framework.manifest.json     # IDE 中立清单（版本、组件、install target）
├── skills/                     # 五阶段权威 SOP（SKILL.md + execution-playbook）
├── agents/                     # Subagent 薄路由（→ skills，不重复长 SOP）
├── references/                 # 公共规则 workflow / structure / rules / guide
├── scripts/                    # bootstrap-run, check-run, install, export
├── templates/                  # skip-step、overlay/sample 脚手架等
├── rules/                      # 可选 .mdc
├── .cursor-plugin/             # Cursor Marketplace 可选通道
├── docs/SESSION-HANDOFF.md     # 本文件
├── README.md
└── PUBLISH.md
```

---

## 六、产物命名（硬性）

`runs/<slug>/outputs/` 下 **必须用 Skill 名前缀**：

| 阶段 | 文件名 |
|------|--------|
| analyze | `analyze.requirements.md` |
| plan | `plan.solution.md` |
| review | `review.gate.md` |
| develop | `developer.implementation.md` |
| test | `test.report.md`（有问题时 `test.ledger.md`） |
| 可选 | `plan.task-breakdown.md` |

**禁止**：`analyst.*` / `planner.*` / `reviewer.*` / `tester.*` 作为 outputs 文件名。

---

## 七、关键脚本

| 脚本 | 作用 |
|------|------|
| `scripts/install-framework-to-project.sh [cursor\|claude\|codex\|neutral\|all]` | 安装到业务仓 |
| `scripts/export-distribution-layout.sh <dir>` | 导出发布目录 |
| `scripts/bootstrap-run.sh <slug> [files...]` | 创建 `runs/<slug>/` |
| `scripts/check-run.sh <slug>` | 校验 outputs 命名与证据基线 |

安装示例（在**业务仓根**）：

```bash
git clone https://github.com/Colacn/ios-agent-pipeline.git /tmp/ios-agent-pipeline
bash /tmp/ios-agent-pipeline/scripts/install-framework-to-project.sh cursor
```

---

## 八、文档索引（改框架时先读）

| 文档 | 路径 |
|------|------|
| 流水线总规则 | `references/workflow/pipeline.md` |
| 复杂度分级 + 硬例子 | `references/workflow/grading.md` |
| runs 归档 | `references/structure/runs-archive.md` |
| 跨 IDE 部署 | `references/guide/cross-platform-deployment.md` |
| 分发通道 | `references/guide/distribution.md` |
| Skill vs Subagent | `references/guide/skill-subagent.md` |
| IDE 入口对照 | `references/guide/ide-adapters.md` |
| 项目 AGENTS 示例 | `templates/project/AGENTS.md.example` |
| skills.sh 结构对照 | `references/guide/skills-ecosystem-alignment.md` |
| overlay 脚手架 | `templates/overlay/README.md` |

各阶段 execution-playbook：`skills/<stage>/references/execution-playbook.md`

---

## 九、修改本仓时的约束

- **只改框架**：skills / agents / references / scripts / templates / rules / docs；**不要**把 iOS 业务实现塞进本仓。
- **框架内不写** Superpowers 等第三方插件的配置或触发规则。
- **改 SOP 时**同步检查：`framework.manifest.json` version、相关 references、必要时 `export-distribution-layout.sh` 产出物。
- **Subagent 文件名**（agents/*.md）可保留历史名；**outputs 落盘**必须用 Skill 名。
- 发版后业务仓通过 `git pull` + `install-framework-to-project.sh` 或 submodule bump 同步。

---

## 十、当前状态（截至 2026-06）

| 项 | 状态 |
|----|------|
| 公开 GitHub 仓 | ✅ https://github.com/Colacn/ios-agent-pipeline |
| 五阶段 Skill + agents | ✅ |
| 多 IDE 安装脚本 | ✅ |
| check-run.sh | ✅ |
| Cursor Marketplace manifest | ✅ 可选，非唯一通道 |
| skills.sh 正式上架 | ⏳ 待 owner 在 skills 生态注册/验证 |
| 业务仓改为 submodule 接入 | ⏳ 可选，未强制 |

---

## 十一、待办 / 可继续方向

- skills.sh 各 `@analyze` … `@test` 入口验证与 README 安装量说明
- Cursor Marketplace 提交审核（若需要 IDE 内发现）
- 应用仓接入：`install-framework-to-project.sh` 同步框架，删除与框架重复的本地 `.cursor/` 分叉
- 框架版本 tag 与 CHANGELOG 持续维护
- Skill 内链：部分仍写 `.cursor/skills/...`（**安装到业务仓 `.cursor/` 后正确**；在本框架仓根浏览时路径不同，属预期）

---

## 会话提示词（复制以下整段到新 Chat）

```markdown
# 任务上下文：ios-agent-pipeline 框架仓

## 仓库

- **GitHub**：https://github.com/Colacn/ios-agent-pipeline
- **本地**：`/Users/lixiuwei/Desktop/ZDXLZ/ios-agent-pipeline`（若 clone 到其他路径请自行替换）
- **性质**：IDE 中立的 Agent 产研流水线框架（非 iOS 业务代码）

## 背景（请当作事实）

1. 本仓库为 **IDE 中立的 Agent 产研流水线框架**，与应用业务代码分离。
2. 流水线：`analyze → plan → review → develop → reconcile-docs → test`。
3. **Skill 名**用于落盘（`analyze.requirements.md` 等）；**Subagent 名**（analyst 等）仅为 IDE 入口，不是第二套 SOP。
4. **不与 Cursor 强绑定**：可装 Cursor / Claude Code / Codex / skills.sh；框架内不含 Superpowers。
5. 业务域、验证命令、分层表等写在 **业务仓 AGENTS.md** 与 **project-overlays/**，不在本框架仓。

## 目录要点

- 权威 SOP：`skills/*/SKILL.md` + `skills/*/references/execution-playbook.md`
- 公共规则：`references/workflow/pipeline.md`、`references/workflow/grading.md`
- 脚本：`scripts/install-framework-to-project.sh`、`scripts/check-run.sh`、`scripts/bootstrap-run.sh`
- 清单：`framework.manifest.json`
- 新会话背景全文：`docs/SESSION-HANDOFF.md`

## 工作方式

- 改框架，不改 iOS 业务源码（`.m/.mm/.swift` 业务模块不在本仓）。
- 最小 diff；改 SOP 时同步 references 与 manifest version。
- 完整背景请先读 `docs/SESSION-HANDOFF.md`。

## 请先执行（若需要了解现状）

```bash
cd /path/to/ios-agent-pipeline
git log -3 --oneline
ls skills agents scripts references
cat framework.manifest.json
```

然后继续我的具体任务：<!-- 在此填写本轮目标 -->
```

---

## 使用说明

1. 打开 **ios-agent-pipeline** 仓库（或已 install 框架的业务仓）。
2. 新建 Chat，粘贴上方「会话提示词」代码块内全文（不含外层 ` ```markdown ` 围栏）。
3. 在 `<!-- 在此填写本轮目标 -->` 处写上本轮具体任务。
4. 若本轮只改**应用业务功能**，应打开**目标应用仓库**（已 install 框架），并在提示词中说明「勿改框架仓除非必要」。
