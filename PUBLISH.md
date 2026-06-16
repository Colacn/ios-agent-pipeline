# 发布到 GitHub（首次）

本地仓库路径：

```text
/Users/lixiuwei/Desktop/ZDXLZ/ios-agent-pipeline
```

已执行：`git init` + 初始 commit（`main`）。

## 1. 登录 GitHub CLI

```bash
export PATH="/opt/homebrew/bin:$PATH"
gh auth login
```

按提示选择 GitHub.com → HTTPS 或 SSH → 浏览器授权。

## 2. 创建公开仓库并推送

```bash
cd /Users/lixiuwei/Desktop/ZDXLZ/ios-agent-pipeline

gh repo create ios-agent-pipeline \
  --public \
  --source=. \
  --remote=origin \
  --push \
  --description "IDE-agnostic iOS agent pipeline: analyze → plan → review → develop → test"
```

若仓库名已被占用，改用例如 `ios-agent-pipeline-framework`，并更新 `README.md` 中的 clone URL。

## 3. 验证

```bash
gh repo view --web
```

## 4. 业务仓接入

在 iOS 业务仓库根目录：

```bash
git clone https://github.com/Colacn/ios-agent-pipeline.git /tmp/ios-agent-pipeline
bash /tmp/ios-agent-pipeline/scripts/install-framework-to-project.sh cursor
```

或使用 submodule：

```bash
git submodule add https://github.com/Colacn/ios-agent-pipeline.git .agent-pipeline-src
bash .agent-pipeline-src/scripts/install-framework-to-project.sh cursor
```

## 5. skills.sh（可选，推送后）

仓库公开后，用户可：

```bash
npx skills add Colacn/ios-agent-pipeline@analyze
```

整包仍推荐 Git clone + `install-framework-to-project.sh`。
