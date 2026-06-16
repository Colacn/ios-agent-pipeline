# L3 全链路样本（文档示例）

> 非真实业务 run；供 `check-run.sh` 与 onboarding 对照命名。复制到 `runs/<your-slug>/outputs/` 作骨架。

## 文件清单

| 阶段 | 文件 |
|------|------|
| analyze | `analyze.requirements.md` |
| plan | `plan.solution.md` |
| review | `review.gate.md` |
| develop | `developer.implementation.md` |
| test | `test.report.md` |

## 使用

```bash
slug=my-feature
bash .cursor/scripts/bootstrap-run.sh "$slug"
cp docs/examples/minimal-l3/*.md "runs/$slug/outputs/"
bash .cursor/scripts/check-run.sh "$slug"
```
