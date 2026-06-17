# 项目 overlay（可选）

应用仓内的**项目层**补充规则：模块分层、编码规范、验证命令等。**框架仓不含 overlay 内容**，仅提供本脚手架。

## 应用仓目录

```text
your-app/
├── AGENTS.md
├── .cursor/                 # install 框架后
└── project-overlays/        # 由应用仓自建
    └── <your-name>/
        ├── appendix-a-layers.md
        ├── coding-conventions.md
        ├── AGENTS.fragment.md      # 可选
        └── check-run-patterns.txt  # 可选
```

从 [`sample/`](sample/) 复制并重命名 `<your-name>`，填写真实模块与规范。

## 安装

```bash
# OVERLAY_SRC 默认：当前应用仓的 project-overlays/
bash .cursor/scripts/install-framework-to-project.sh cursor \
  --init-agents --overlay your-name
```

外部路径：

```bash
OVERLAY_SRC=/path/to/your-app/project-overlays \
  bash .../install-framework-to-project.sh cursor --overlay your-name
```

## 与 Skill 的关系

- **plan / develop / review / test**：若存在 overlay，读 `project-overlays/<name>/appendix-a-layers.md` 与 `coding-conventions.md`
- **无 overlay**：在 `plan.solution.md` 与 `AGENTS.md` 自建模块表（见 plan skill 的 `references/guide-layering.md`）

**勿**向框架上游提交业务 overlay。
