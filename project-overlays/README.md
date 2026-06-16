# Project Overlays

**框架仓不含任何业务域 overlay。** 分层表、编码规范、团队验证命令等由**业务仓库**自行维护。

## 业务仓目录约定

```text
your-app-repo/
├── AGENTS.md
├── .cursor/                    # install 框架后
└── project-overlays/
    └── <your-team-name>/
        ├── manifest.json
        ├── appendix-a-layers.md
        ├── coding-conventions.md
        ├── AGENTS.fragment.md      # 可选
        └── check-run-patterns.txt    # 可选
```

## 安装 overlay

overlay 源目录通过环境变量 **`OVERLAY_SRC`** 指定（指向含各 overlay 子目录的父路径）：

```bash
# 在业务仓根；OVERLAY_SRC 默认为当前仓库的 project-overlays/
bash .cursor/scripts/install-framework-to-project.sh cursor \
  --init-agents --overlay your-team-name
```

从外部路径安装：

```bash
OVERLAY_SRC=/path/to/your-app/project-overlays \
  bash /path/to/ios-agent-pipeline/scripts/install-framework-to-project.sh cursor \
  --overlay your-team-name
```

## 脚手架

框架仅提供**无业务语义**的模板，复制后改名填充：

- [`templates/overlay/sample/`](../templates/overlay/sample/)

## 与 Skill 的关系

- `plan` / `develop`：有 overlay 时读 `project-overlays/<name>/appendix-a-layers.md` 与 `coding-conventions.md`
- 无 overlay 时：在 `plan.solution.md` 与项目 `AGENTS.md` 自建模块表
