## CTQ iOS 业务 overlay（project-overlays/ctq-ios）

本仓库已安装 **ctq-ios** overlay，下列约束优先于框架通用占位说明：

- **IM/RTC 分层与依赖**：[`project-overlays/ctq-ios/appendix-a-layers.md`](project-overlays/ctq-ios/appendix-a-layers.md)
- **Objective-C 编码规范**：[`project-overlays/ctq-ios/coding-conventions.md`](project-overlays/ctq-ios/coding-conventions.md)
- plan Skill 附录 A、develop 编码细则以 overlay 为准。

### 验证命令（示例，按本仓实际 scheme 调整）

```bash
# 编译（示例 target，请替换为实际 workspace/scheme）
xcodebuild -workspace CTQIMApplication.xcworkspace -scheme CTQIMApplication -destination 'platform=iOS Simulator,name=iPhone 16' build
```
