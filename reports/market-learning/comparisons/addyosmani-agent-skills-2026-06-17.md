# 对比报告：addyosmani/agent-skills → agent-pipeline

**日期**：2026-06-17  
**来源**：[addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)  
**对照仓**：Colacn/agent-pipeline（五阶段流水线 skill）

## 仓库定位差异

| 维度 | addyosmani/agent-skills | agent-pipeline |
|------|-------------------------|----------------|
| 结构 | 20+ 独立能力 skill（TDD、评审、规划等） | 固定五阶段 `analyze→plan→review→develop→test` |
| 产出 | 通用工程纪律 | `runs/<slug>/` 文档驱动交付物 |
| 分发 | Plugin + commands + hooks 多入口 | skills.sh 单 skill 自包含为主 |
| 文档 | `docs/skill-anatomy.md` 写作规范 | `references/workflow/*` + execution-playbook |

## 可借鉴优点（已吸收）

| 模式 | 来源 skill | 落点 |
|------|------------|------|
| 假设显式化 + 成功标准改写 + Always/Ask/Never | spec-driven-development | `references/workflow/assumptions-protocol.md` → analyze |
| 纵向切片、任务粒度、Checkpoint | planning-and-task-breakdown | `references/workflow/plan-slicing.md` → plan |
| 五轴评审、先看验证、评论分级、体量控制 | code-review-and-quality | `references/workflow/review-discipline.md` → review |
| 增量切片、范围纪律、简洁性自检 | incremental-implementation | `references/workflow/incremental-delivery.md` → develop |
| Prove-It、验证命令纪律、未覆盖显式化 | test-driven-development | `references/workflow/test-discipline.md` → test |
| Common Rationalizations / Red Flags / Verification | skill-anatomy 推荐节 | 各 discipline 文件内嵌（不复制全文） |

## 刻意不照搬

- **整份 SKILL.md 体例替换**：本仓以 execution-playbook + 流水线门禁为主，避免与 agentskills.io 已有 frontmatter 冲突。
- **commands/hooks/plugin 多入口**：与 skills.sh 主路径重复；保留可选 Cursor Subagent。
- **领域 checklist**（a11y、webperf 等）：非流水线核心；可按项目 overlay 扩展。
- **validate-skills.js**：本仓已有 `smoke-test.sh`；后续可考虑类似 frontmatter lint。

## 后续 watchlist

已将 `addyosmani/agent-skills` 加入 `market-learning.manifest.json` watchlist，供每日 market-learn 持续对比。

## 验证

```bash
bash scripts/sync-skill-vendor.sh
bash scripts/smoke-test.sh
```
