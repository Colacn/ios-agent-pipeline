# 分层与依赖边界（框架占位）

> 具体模块名与依赖表由 **project overlay** 或项目 `AGENTS.md` 维护。未安装 overlay 时在 `plan.solution.md` 自建模块表。

## A.1 通用要求

1. 先确定落层，再落代码。
2. 依赖单向；核心状态走主链路，不新增旁路。
3. 接口/存储/协议变更须写兼容口径。

## A.2 已安装 overlay

读取应用仓根 `project-overlays/<name>/appendix-a-layers.md`（由应用仓维护）。脚手架见 plan/develop skill 的 `assets/overlay/sample/`。

## A.3 方案交付时必须交代

1. 所在层、上下游依赖与禁止跨层点。
2. 落层依据、兼容说明；用户要求时再补回滚/处置。
3. 数据流变化时的最小回归范围。

详见 `references/guide-layering.md`（plan skill）或项目 overlay。
