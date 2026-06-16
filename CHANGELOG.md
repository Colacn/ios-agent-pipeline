# Changelog

本仓库遵循 [Semantic Versioning](https://semver.org/)。

## [0.3.0] - 2026-06-16

### Added

- **project-overlays/**：业务域与框架解耦；内置 `ctq-ios`（IM/RTC 分层 + OC 编码规范）。
- **install 增强**：`--init-agents`、`--overlay NAME`、`--check`、`--dry-run`。
- **scripts/reconcile-check.sh**：对照 `git diff` 与 `developer.implementation.md` §4/§8。
- **references/guide/path-conventions.md**、**layering.md**；可配置 **check-run-patterns.txt**。
- **analyze 路由决策**：execution-playbook 增加 L0–L3 路由块规范。
- **docs/examples/minimal-l3/**：全链路 outputs 命名样本。

### Changed

- **plan / develop Skill**：CTQ 细则迁至 overlay；框架层改为通用占位 + 相对路径链接。
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
