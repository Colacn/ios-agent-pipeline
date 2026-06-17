# 与 skills.sh / Agent Skills 标准对照

> 规范：[agentskills.io/specification](https://agentskills.io/specification) · 目录：[skills.sh/Colacn/agent-pipeline](https://skills.sh/Colacn/agent-pipeline)

## 主流 skill 结构（本仓已对齐）

```text
skills/<name>/
├── SKILL.md          # 必需：YAML frontmatter + 指令
├── references/       # 按需加载（含 vendored workflow-pipeline.md 等）
├── scripts/          # bootstrap-run、check-run …
└── assets/           # 模板、overlay 脚手架（plan/develop）
```

**渐进式披露**：启动时 `name` + `description`；激活后 `SKILL.md`；细节在 `references/` / `scripts/` / `assets/`。

## 安装（主流）

```bash
# 推荐：skills.sh CLI（需 Node.js / npx）
npx skills add Colacn/agent-pipeline@analyze -a cursor -y
npx skills add Colacn/agent-pipeline@plan -g -y

# 备选：Git + bash（无 Node）
bash /path/to/agent-pipeline/scripts/install-skill.sh analyze cursor
```

| 方式 | 得到什么 |
|------|----------|
| `npx skills add …@analyze` | **仅**自包含 `skills/analyze/` → 落盘到 `.cursor/skills/analyze/` 等 |
| `install-skill.sh` | 同上 skill + 对应 agent + `.cursor/scripts/install-*.sh` |
| `install-framework-to-project.sh` | 全部 5 skill + agents + 安装工具脚本 |
| `--with-legacy-bundle` | 额外根级 `references/`、`scripts/`、`templates/`（旧布局） |

## 维护者工作流

1. 修改 canonical 源：`references/workflow/`、`scripts/`、`templates/vendor/`。
2. 执行 `bash scripts/sync-skill-vendor.sh` 同步到 `skills/*/`.
3. 提交 skill 目录变更（skills.sh 从 Git 拉取的是 `skills/<name>/`）。

## 跨 skill 引用

主流模式**不**依赖 `../plan/SKILL.md` 等兄弟 skill。本仓将附录 A、协作纪律等 **vendored** 到各 skill 的 `references/`（`layering-appendix-a.md`、`collaboration-discipline.md`）。

## 相关文档

- [distribution.md](distribution.md)
- [skill-subagent.md](skill-subagent.md)
- [path-conventions.md](path-conventions.md)
