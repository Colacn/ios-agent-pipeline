# CTQ iOS 编码规范（项目 overlay）

> 与 [appendix-a-layers.md](appendix-a-layers.md) 模块列表一致；develop 实现阶段对照。

## 适用范围

`CTQ_IMKit`、`CTQ_IMLib`、`CTQ_IMLibBase`、`CQBase`、`CTQ_RTCLib`、`CTQ_RTCKit`、`CTQIMApplication`（含子目录）。

## 硬性约束

- **命名**：`CQ` / `CTQ` 前缀与既有后缀；语义清晰、不随意缩写。
- **分层与复用**：遵守附录 A；改动前先检索同模块调用链与既有抽象，**能接到现有类/扩展上就不新造平行入口**。
- **语言与属性**：以**被改文件**既有语言为准（OC 继续 OC，Swift 继续 Swift）。对外暴露、语义上不可变的 `NSString` / `NSArray` / `NSDictionary` 等属性优先 `copy`。
- **线程与性能**：重逻辑后台；列表热路径无重 IO/重复计算。
- **注释**：兼容分支、边界、降级 — 中文为主。

## 会话沉淀约束（执行优先）

- **最小改动**：需求已明确时，优先小步快改；不做无关重构，不扩大影响面。
- **布局策略**：当需求明确要求不改父子 frame/约束关系时，优先通过 `contentInset` / `scrollIndicatorInsets` 等内边距手段实现视觉间距调整。
- **数据与展示分层**：Model 仅承载接口字段映射（如 MJ）；展示兜底文案（`@""`、`@"--"` 等）放在 Cell 的配置方法，不写死在 Model。
- **列表刷新安全**：请求发起时禁止先 `removeAllObjects` 清空正在展示的数据源；使用局部临时数组承接结果，在主线程一次性替换并 `reloadData`，避免中间态越界与空闪。
- **请求并发约束（列表页）**：默认采用轻量 `isLoading` 防重入；若产品策略是“重复下拉不排队”，允许直接丢弃重复刷新并及时结束刷新动画。
- **请求结果状态命名**：布尔状态优先使用 `*Succeeded`/`*Success` 单一语义，避免同一请求同时维护 `success + failed` 双标记导致分支膨胀。
- **异步回调生命周期处理**：默认使用 `kWeakSelf` + 回调落地处 `__strong typeof(weakSelf) strongSelf = weakSelf; if (!strongSelf) return;`。
- **可见性与生命周期解耦**：`weakSelf` 判空用于生命周期安全；是否拦截离屏行为属于产品策略，按页面约定显式选择。
- **网络层契约依赖声明**：当业务逻辑依赖“成功/失败/取消均回调”时，需在方法注释或实现处显式声明该契约。
- **批量模型映射优先**：接口返回数组优先使用 MJExtension `mj_objectArrayWithKeyValuesArray` 批量转换。
- **错误提示收敛**：并发请求统一在收敛点提示一次错误；优先展示首个可用错误响应，无可用响应再兜底通用文案。
- **防御式 UI 计算**：涉及 `tableView` 宽高计算时，必须考虑早期布局阶段的 0 值场景，提供安全兜底。
- **VC 排版顺序**：默认按 `Lifecycle -> Data/Business -> Layout -> Action -> DataSource -> Delegate -> Lazy load` 组织；使用 `#pragma mark -` 明确分组。
- **视觉常量化**：header 高度、文本边距、底距等可调参数优先抽成常量。

## 交付说明（编码）

1. 复用了哪些类/服务。
2. 命名与职责是否符合本规范；线程/列表性能/日志/错误码 — 无则「不适用」。
3. 最小自检：命名与目录、跨层（对附录 A）、线程与可观测。
