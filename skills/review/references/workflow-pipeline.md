# 流水线规则总览

> 本文为 `AGENTS.md` 中“预处理 / 各步职责 / 证据基线 / 跳步替代”的结构化拆分镜像。

## 流水线预处理（嵌在 /analyze 首轮，若入口仍为 `/analyst` 则同指）

1. 选定 `<short-slug>`（优先分支语义；不一致时按需求语义并可 `AskQuestion` 确认）
2. 识别外部依据（本地路径 / URL / 用户声明后续提供）
3. 有本地文件：
   - 先 `bootstrap-run.sh`（或一步到位带路径）
   - 再确保 ingest 完成后方可落盘 `outputs/`
4. 有 URL 无本地文件：
   - `bootstrap-run.sh` + `record-urls-to-inputs.sh`
5. 仅自然语言：
   - 可延后建 `runs/`，但首次落盘前必须建好

## 默认顺序

`runs 判断 -> analyze -> plan -> review -> develop -> reconcile-docs -> test`（Subagent/入口仍可能显示为 `analyst`/`planner` 等历史名，与上同序）  
（`reconcile-docs` 合并在 develop 出口，不单独占角色；`review` / `test` 可经用户明示跳过并留痕）

## 跳步替代门禁（强制）

1. skip **review**：风险清单 + 兼容影响 + 测试范围 + 未决项处理 + 跳过理由
2. skip **test**：最小回归集 + 实际验证证据 + 残余风险 + 放行口径 + 跳过理由
3. 阻塞项未获明确决策，不得以跳步名义推进定稿

## 统一留痕模板

```markdown
## 跳步替代留痕

### 跳过 review（按需）
- 风险清单：<...>
- 兼容影响：<...>
- 测试范围：<...>
- 未决项处理：<...>
- 跳过理由：<...>

### 跳过 test（按需）
- 最小回归集：<...>
- 实际验证证据：<...>
- 残余风险：<...>
- 放行口径：<...>
- 跳过理由：<...>
```

## 证据基线（防漂移门禁）

1. 进入每一步前必须 `ls runs/<slug>/{inputs,outputs}` 并读齐上下文
2. 关键结论必须可溯源到 `inputs/` 或上游 `outputs/`
3. 发现冲突时先 `AskQuestion`，不得隐式覆盖上游结论
4. 上游缺失/冲突即阻塞，不得默认推进
5. 定稿去痕 + 局部修订（禁止无必要整篇抹平重写）
6. 过程项清理（已决项回填正文并从清单移除）
7. `AskQuestion` 决策优先（仅用户明确暂不回答时可标注“等待用户答复”）
8. **develop 出口**：须落盘 `outputs/developer.implementation.md`（模板 `.cursor/templates/developer-implementation-template.md`）
9. **reconcile-docs**：develop 后对照 `git diff` 回写 `analyze.requirements.md` 与 `plan.solution.md` 至与实现一致；禁止 plan 保留「待实现」而代码已合并
10. **test 入口**：须存在已 reconcile 的 `developer.implementation.md`；test 须检查文档与实现一致性（见 test Skill）
11. **机械校验**：develop 出口或 test 入口前建议执行 `bash .cursor/scripts/check-run.sh <short-slug>`（旧命名硬失败；缺失 implementation 等为 warning）
