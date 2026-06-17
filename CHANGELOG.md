# Changelog

本仓库遵循 [Semantic Versioning](https://semver.org/)。

## [0.6.0] - 2026-06-17

### Changed

- **Agent Skills 主流对齐**：每个 pipeline skill 自包含 `references/`、`scripts/`、`assets/`（符合 [agentskills.io](https://agentskills.io/specification)）。
- `npx skills add Colacn/agent-pipeline@analyze` 即可运行，无需额外 shared bundle。
- 新增 `scripts/sync-skill-vendor.sh`：从根 `references/`、`scripts/` 同步到各 skill。
- `install-framework-to-project.sh` 默认只装自包含 skills + agents + 项目工具脚本；`--with-legacy-bundle` 恢复旧根级 references/scripts/templates。
- `resolve-repo-root.sh` 优先用 git 仓库根（支持全局 skills 目录执行脚本）。
- README / AGENTS 模板 / agents 路径改为 skill 内相对资源。
- `framework.manifest.json` / `.cursor-plugin/plugin.json` → v0.6.0。

## [0.5.0] - 2026-06-16

### Removed

- **`PUBLISH.md`**：一次性个人发布笔记。
- **`rules/*.mdc`**：误装入框架的 ObjC 业务 Cursor rules；整包安装不再复制 `rules/`。
- **`references/rules/git-hooks.md`** 与 **`setup-hooks.sh`** 引用链（脚本从未提供）。
- **`docs/SESSION-HANDOFF.md`**：与 README / references 重复的会话背景包。

### Changed

- 框架重命名为 **`agent-pipeline`**（面向通用软件研发，非 iOS 专用）。
- `framework.manifest.json` / `.cursor-plugin/plugin.json` → v0.5.0；移除 `components.rules`。
- develop/test agent 与 test skill 描述泛化（不再绑定 Objective-C/Swift）。
- README、distribution、installation、AGENTS 模板等文档同步更新。
- GitHub 仓库重命名为 **`Colacn/agent-pipeline`**（原 `ios-agent-pipeline`）。

## [0.4.0] - 2026-06-16

### Added

- **单 skill 部署**：`scripts/install-skill.sh` 与 `install-framework-to-project.sh --skill/--skills`。
- 单 skill 模式自动安装共享 bundle（`references/`、`scripts/`、`templates/`）及对应 agent。
- `scripts/lib/skill-install.sh`：skill 校验与 agent 映射。
- `framework.manifest.json` → `skillInstall` 元数据。
- smoke-test 增加单 skill 安装用例。

### Changed

- 整包安装仍为默认；`--bundle` 可显式覆盖 `--skill`。
- README / distribution / skills-ecosystem-alignment 文档对齐新安装方式。

## [0.3.2] - 2026-06-16

### Removed

- `project-overlays/README.md`（与 `templates/overlay/README.md` 重复）。
- `skills/*/scripts/` 转发 wrapper（脚本统一在 bundle 根 `scripts/`）。

### Added

- `references/guide/skills-ecosystem-alignment.md`：与 skills.sh / Agent Skills 标准对照。

### Changed

- overlay 说明合并至 `templates/overlay/`；Skill 内链指向根 `scripts/`。

## [0.3.1] - 2026-06-16

### Removed

- 框架仓内嵌的业务域 overlay（改为仅保留 overlay 机制说明与 `templates/overlay/sample/` 脚手架）。

### Changed

- overlay 由**应用仓**维护；安装时通过 `OVERLAY_SRC` 或应用仓 `project-overlays/` 解析。
- 框架仅保留无业务语义的 **`templates/overlay/sample/`** 脚手架。
- 文档与 Skill 去除具体业务域引用。

## [0.3.0] - 2026-06-16

### Added

- **project-overlays/**：overlay 约定目录（**框架仓不含业务内容**）。
- **install 增强**：`--init-agents`、`--overlay NAME`、`--check`、`--dry-run`。
- **scripts/reconcile-check.sh**：对照 `git diff` 与 `developer.implementation.md` §4/§8。
- **references/guide/path-conventions.md**、**layering.md**；可配置 **check-run-patterns.txt**。
- **analyze 路由决策**：execution-playbook 增加 L0–L3 路由块规范。
- **docs/examples/minimal-l3/**：全链路 outputs 命名样本。

### Changed

- **plan / develop Skill**：业务细则迁出框架；框架层为通用占位 + overlay 约定。
- **grading.md**：L3 硬例子改为通用表述。
- **check-run.sh**：plan 过时标记从 overlay/manifest  patterns 文件读取。
- **export-distribution-layout.sh**：包含 `project-overlays/`；plugin 版本跟随 manifest。

## [0.2.0] - 2026-06-16

### Fixed

- **scripts repo_root 解析**：新增 `scripts/lib/resolve-repo-root.sh`。
- **export-distribution-layout.sh**：`AGENTS.md.example` 与 `repo_root` 路径修复。

### Added

- **scripts/smoke-test.sh**、GitHub Actions CI（shellcheck + smoke）。

## [0.1.0] - 2026-06

### Added

- 五阶段 Skill 与 Subagent 薄路由、多 IDE 安装、`check-run.sh`、跨 IDE 文档。
