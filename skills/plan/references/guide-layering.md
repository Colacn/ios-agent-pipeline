# 分层与依赖（框架占位）

> 框架层不提供具体模块名。项目 team 应通过 **project overlay** 或 **AGENTS.md** 维护落层速查表。

## 方案阶段必须交代

1. 改动所在层、上下游依赖与禁止跨层点。
2. 落层依据、兼容说明、数据流受影响范围。
3. 最小回归范围（若数据流变化）。

## 已安装 overlay 时

读取应用仓根 `project-overlays/<name>/appendix-a-layers.md`（由应用仓维护）。脚手架见 plan/develop skill 的 `assets/overlay/sample/`。

## 未安装 overlay 时

在 `plan.solution.md` 中根据仓库现有目录结构自建「模块 → 职责 → 依赖方向」表，并在 `AGENTS.md` 沉淀稳定口径。
