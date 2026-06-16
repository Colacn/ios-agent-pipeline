# Project Overlays

业务域约束与框架解耦：各 overlay 提供**项目层**分层表、编码规范、AGENTS 片段等；框架 Skill 保持 IDE 中立。

## 安装

在业务仓根目录（已安装框架后）：

```bash
bash .cursor/scripts/install-framework-to-project.sh cursor --overlay ctq-ios
# 首次接入可同时初始化 AGENTS.md：
bash .cursor/scripts/install-framework-to-project.sh cursor --init-agents --overlay ctq-ios
```

产物位于业务仓根 `project-overlays/<name>/`（与 `.cursor/` 同级）。

## 内置 overlay

| 名称 | 说明 |
|------|------|
| [ctq-ios](ctq-ios/) | CTQ IM/RTC 模块分层与 Objective-C 编码约定 |

## 自定义 overlay

复制 `ctq-ios/manifest.json` 结构，在自有仓库或 fork 中维护 `project-overlays/<your-name>/`，安装时 `--overlay <your-name>`。
