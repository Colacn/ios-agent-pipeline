# Report And Ledger Checklist

完整测试流程与落盘规则见：`execution-playbook.md`。

- [ ] 每次执行结束已落盘文档并返回路径
- [ ] 已定位需求目录：`/runs/<short-slug>/`（外部依据 → `inputs/`，Agent 落盘 → `outputs/`）
- [ ] 有问题：更新 **test** 台账 `outputs/test.ledger.md`
- [ ] 无问题：更新或生成 **test** 报告 `outputs/test.report.md`
- [ ] 摘要含执行时间、来源、新增问题数、放行结论
- [ ] 阻塞歧义已先通过 `AskQuestion` 澄清
- [ ] **test** 报告仅保留当前有效结论；已决项已回填并清理（对应当前使用之 report 文件名）
- [ ] 若用户明确暂不回答，未决项已标注“等待用户答复”
- [ ] 如用户明示跳过 **test**：已补“最小回归集 + 实际验证证据 + 残余风险 + 放行口径 + 跳过理由”
