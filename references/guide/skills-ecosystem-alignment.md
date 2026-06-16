# 与 skills.sh / Agent Skills 标准对照

> 规范来源：[agentskills.io/specification](https://agentskills.io/specification) · 生态入口：[skills.sh](https://skills.sh/)

## 热门 skill 的典型结构

skills.sh 排行靠前的 skill（如 `brainstorming`、`test-driven-development`、`systematic-debugging`）多为**单能力、自包含**目录：

```text
skill-name/
├── SKILL.md          # 必需：YAML frontmatter + 指令正文
├── references/       # 可选：按需加载的长文档
├── scripts/          # 可选：可执行脚本（跑输出，不整文件进上下文）
└── assets/           # 可选：模板、schemas、静态资源
```

设计原则：**渐进式披露** — 启动时只加载 `name` + `description`；激活后读 `SKILL.md`；细节在 `references/` / `scripts/` / `assets/`。

## 本仓库的定位（流水线 bundle）

本仓是 **五阶段流水线整包**，不是单个 skill：

```text
ios-agent-pipeline/
├── skills/           # analyze | plan | review | develop | test（各符合 SKILL.md 标准）
├── references/       # 跨阶段公共规则（pipeline、grading、runs…）
├── scripts/          # 跨阶段 bash（bootstrap、check-run、install）
├── templates/        #  bundle 级 assets（≈ 标准中的 assets/）
├── agents/           # Cursor 薄路由（非 skills.sh 标准；IDE 适配层）
└── rules/            # Cursor rules（可选）
```

| 标准目录 | 本仓对应 | 说明 |
|----------|----------|------|
| `SKILL.md` | `skills/<stage>/SKILL.md` | 每阶段独立 skill，可 `npx skills add owner/repo@analyze` |
| `references/` | `skills/*/references/` + 根 `references/` | 阶段细则在 skill 内；公共规则在根（install 后同级） |
| `scripts/` | 根 `scripts/` | 共享脚本；**不在** skill 下重复转发 |
| `assets/` | `templates/` | 交付模板、overlay 脚手架 |

## 安装方式对照

| 方式 | 得到什么 | 适用 |
|------|----------|------|
| `npx skills add …@analyze` | 单个 skill 目录 | 发现、轻量试用 |
| `install-framework-to-project.sh` | skills + references + scripts + templates + agents | **完整流水线** |

单 skill 安装**不会**带上 `references/workflow/pipeline.md` 等公共规则 → 完整产研仍推荐 Git clone + install。

##  authoring 建议（对齐热门 skill）

1. **SKILL.md 保持短**：入口 + 步骤 + 指向 `references/execution-playbook.md`（本仓已采用）。
2. **description 写清 WHEN**：Agent 靠它决定是否触发（frontmatter 最关键字段）。
3. **长 SOP 放 references/**：execution-playbook、checklist 等按需读。
4. **脚本放根 scripts/**：避免 skill 内重复 wrapper。
5. **模板放 templates/**：等同 assets/；develop 模板见 `templates/developer-implementation-template.md`。
6. **项目 overlay**：在**应用仓** `project-overlays/` 维护，见 [`templates/overlay/README.md`](../../templates/overlay/README.md)。

## 相关文档

- [distribution.md](distribution.md)
- [skill-subagent.md](skill-subagent.md)
- [path-conventions.md](path-conventions.md)
