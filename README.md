# agent-pipeline

Document-driven agent pipeline for software R&D teams:

`analyze → plan → review → develop → test`

符合 [Agent Skills 开放规范](https://agentskills.io/specification)：每阶段为**按能力最小自包含**的 skill，通过 [skills.sh](https://skills.sh/Colacn/agent-pipeline) / `npx skills add` 安装到任意支持的 Agent。

## 两层设计

| 层 | 内容 | 何时需要 |
|----|------|----------|
| **Skill**（主流） | `SKILL.md` + 本阶段 `references/` / `scripts/` | 总是；`npx skills add` |
| **Subagent**（可选） | `agents/analyst.md` 等薄路由 | 仅 Cursor 等需子代理隔离时；`--with-agents` |

## Quick start（推荐）

```bash
npx skills add Colacn/agent-pipeline@analyze -y
# skills CLI 落盘：.agents/skills/analyze/（各 IDE symlink）
```

```bash
bash .agents/skills/analyze/scripts/bootstrap-run.sh my-feature
```

按需追加阶段：`npx skills add Colacn/agent-pipeline@plan -y`

## 备选：Git + bash（无 Node）

```bash
git clone https://github.com/Colacn/agent-pipeline.git /tmp/agent-pipeline
cd your-app
bash /tmp/agent-pipeline/scripts/install-framework-to-project.sh cursor --init-agents
```

单阶段：

```bash
bash /tmp/agent-pipeline/scripts/install-skill.sh analyze cursor
```

**Cursor Subagent（可选）**：

```bash
bash /tmp/agent-pipeline/scripts/install-skill.sh analyze --with-agents cursor
```

## 安装对照

| 方式 | 得到什么 |
|------|----------|
| `npx skills add …@analyze` | 自包含 skill → `.agents/skills/` |
| `install-skill.sh analyze` | `.cursor/skills/analyze/` + 安装工具脚本 |
| `install-skill.sh analyze --with-agents` | 上述 + `agents/analyst.md` |
| `install-framework-to-project.sh` | 全部 5 skill + 工具脚本 |
| `+ --with-agents` | 上述 + 全部 `agents/` |
| `+ --with-legacy-bundle` | 额外根级 `references/scripts/templates`（旧布局） |

## 各 skill 自带内容（最小集）

| Skill | references（vendored） | scripts |
|-------|------------------------|---------|
| analyze | pipeline, grading, light-task, skill-subagent | bootstrap, ingest, record-urls |
| plan | pipeline, layering, appendix-a, collaboration | bootstrap |
| review | pipeline, appendix-a | bootstrap |
| develop | pipeline, appendix-a, collaboration, check-run-patterns | bootstrap, reconcile, check-run |
| test | pipeline, appendix-a | bootstrap, check-run |

维护者改 canonical 源后：`bash scripts/sync-skill-vendor.sh`

## 验证

```bash
bash scripts/smoke-test.sh
```

## License

MIT — see [LICENSE](LICENSE).
