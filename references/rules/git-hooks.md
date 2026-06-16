# Git hooks（可选）

仓库根目录提供：

```bash
bash setup-hooks.sh
bash setup-hooks.sh --force
bash setup-hooks.sh -h
```

约束：

- 不修改已有 `core.hooksPath`
- 多 worktree 需逐个检出根执行
- `pre-commit` 含**非阻断**流水线提示：提交 `.m/.mm/.swift` 时若 `runs/*/outputs/` 缺 `developer.implementation.md` 或该文件未纳入暂存，会在 stderr 提示 reconcile（见 `pipeline.md` 证据基线 §8–10）
