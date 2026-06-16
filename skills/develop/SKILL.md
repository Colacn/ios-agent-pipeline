---
name: develop
description: Use this skill when implementing approved Objective-C/Swift changes with minimal diff, layered constraints, and local verification. It is intended for post-plan/review execution and includes collaboration discipline, test-validation coordination, and coding standards.
---

# Develop

## Instructions

1. 完整执行规范见 [`references/execution-playbook.md`](references/execution-playbook.md)（**优先通读**）。**runs 工区**：需要向 `outputs/` 写入本轮说明类文档前，若目录不存在，执行 [`scripts/bootstrap-run.sh`](scripts/bootstrap-run.sh) `<slug>`（与其他 Skill 同源，权威实现见 `/.cursor/scripts/`）。
2. **Layering**：`.cursor/skills/plan/SKILL.md` **附录 A**（冲突时以 `plan` Skill 为准）。
3. **协作与质量 + 编码规范**：见本文件 **Appendix**（先「协作与质量纪律」，后「编码规范」）。
4. **流程**：`AGENTS.md`（产研流水线、执行前确认）；**走流水线**时遵守 `references/execution-playbook.md`「流水线中的本步」（按方案测试范围完成实现与回归）。
5. **线程**：UI 主线程；IO/网络回调不阻塞主线程（细则见 Appendix）。
6. **Handoff to test**：需要结构化测试/放行建议时交给 `test` Skill。
7. **流水线硬门禁**：以 [`AGENTS.md`](../../../AGENTS.md) 路由总览 + [`../../references/workflow/pipeline.md`](../../references/workflow/pipeline.md) 细则为准；本 Skill 仅补充 develop 侧特有执行细则。
8. 用户明示跳过 `review` 或 `test` 时，替代门禁字段、缺项处理与留痕模板以 `references/execution-playbook.md` 与 [`AGENTS.md`](../../../AGENTS.md) 为准。
9. **走流水线时 develop 出口（强制）**：代码完成后依次落盘 `developer.implementation.md` → 执行 **reconcile-docs**（对照 `git diff` 回写 `analyze.requirements.md` 与 `plan.solution.md`）。模板见 [`.cursor/templates/developer-implementation-template.md`](../../templates/developer-implementation-template.md)。**无 implementation 或未 reconcile，不得声明可进入 test 全量放行。**

## On-demand references（按需读取）

- 需要执行前快速核对开发门禁时：读取 `references/execution-gate.md`
- 需要标准化回报改动与验证证据时：读取 `references/delivery-checklist.md`
- 用户跳过 `review/test` 需补替代门禁时：同时读取 `references/execution-gate.md` 与 `references/delivery-checklist.md`
- 需要完整 SOP（执行门禁/实现流程/交付结构）时：读取 `references/execution-playbook.md`

## When not to use

- 评审阻塞未解除仍强行开发。
- 关键产品/方案决策未决（先 `analyze` / `plan` / `review` 等上游 Skill）。

---

## Appendix

### 协作与质量纪律（10条）

适用于本仓库 **iOS（Objective-C/Swift）** 日常开发与 AI 协作；与 [`AGENTS.md`](../../../AGENTS.md) **产研流水线与工作流**、本 Appendix 下文**编码规范**、[`skills/plan/SKILL.md`](../plan/SKILL.md) **附录 A** 配合使用。未走流水线时，下列纪律仍适用。

**走产研流水线**时：`plan` 在方案 **第 11）**明确测试范围与关键场景，`review` 审可执行性；本 Skill 按约定完成实现与回归验证，并在交付中给出可追溯证据。未走流水线改动，仍按第 4、9 条以可验证为主。

1. **先定边界再开工** — 每轮先明确「改什么 / 不改什么 / 如何验收」，避免改动外溢。
2. **小步提交思维** — 一次只解决一个问题（一个缺陷、一个能力点、一处重构），便于定位与验证；用户明确要求时再补回滚预案。
3. **先读调用链** — 修改前先确认入口、数据模型、存储、渲染与回调链路，避免局部优化破坏全局行为。
4. **关键路径可验证** — 核心逻辑与高风险改动须能说清**如何验收**（自动化测试、手测步骤、编译加场景回归等）。**走产研流水线**时，按 `plan` / `review` 约定的测试范围执行并回报验证证据。
5. **兼容性前置** — 涉及接口、字段、消息类型变更时，先定义新旧版本兼容策略与降级路径；回滚策略仅在用户明确要求时补充。
6. **不破坏主线程原则** — UI 更新必须主线程；IO、序列化、网络回调不得阻塞主线程。
7. **统一错误语义** — 错误码、NSError 域、日志关键字段与用户提示保持一致，确保问题可追踪、可定位。
8. **复用优先于复制** — 发现重复逻辑优先抽象（工具类、协议、基类、分类），再落地需求，避免技术债累积。
9. **每次改动带验证** — 至少完成编译检查与相关回归验证；关键链路需补充或更新测试。
10. **输出可追踪结论** — 每轮明确记录：改动文件、变更原因、风险点、验证结果、后续 TODO。

#### 协作输出模板（推荐）

在需要**快速对齐意图与方案**时（例如走产研流水线时 **analyze / plan** 衔接段），可优先使用：

1. 当前理解：<目标与上下文，一句话>
2. 待你决策：<必须决策项，按阻塞实际完整列出>
3. 默认推进：<可默认项 + 默认值>
4. 下一步：<将执行的动作与验证方式>

#### 例外与不适用场景

- 与本附录无关的目录或上下文
- 不满足触发条件的改动范围

#### 验收与检查

- 约束可落地且可验证
- 路径与引用可在仓库内解析；涉及 `.cursor` 时与 [`AGENTS.md`](../../../AGENTS.md) 及索引一致
- 检查命令（按需）：无统一自动化脚本

#### Skill 文档维护

- 本 Skill 的 `description` 宜覆盖 WHAT + WHEN
- 正文中的路径、Skill/流水线用名以**当前仓库** `.cursor/` 为准，随文档更新同步修订

---

### 编码规范

#### 适用范围

与 plan **附录 A** 模块列表一致：`CTQ_IMKit`、`CTQ_IMLib`、`CTQ_IMLibBase`、`CQBase`、`CTQ_RTCLib`、`CTQ_RTCKit`、`CTQIMApplication`（含子目录）。

#### 硬性约束

- **命名**：`CQ` / `CTQ` 前缀与既有后缀；语义清晰、不随意缩写。
- **分层与复用**：遵守 plan **附录 A** 与本 Skill **Instructions** 中的 Layering；改动前先检索同模块调用链与既有抽象，**能接到现有类/扩展上就不新造平行入口**（避免只为单点需求再堆一层 `*NewManager`）。具体「数据写哪、UI 从哪取」以当次方案为准，不在本附录写死某种三层分工口号。
- **语言与属性**：以**被改文件**既有语言为准（OC 文件继续 OC，Swift 继续 Swift）；跨语言混用仅在明确迁移/桥接方案下进行。对外暴露、语义上不可变的 `NSString` / `NSArray` / `NSDictionary` 等属性优先 `copy`。
- **线程与性能**：重逻辑后台；列表热路径无重 IO/重复计算。
- **注释**：兼容分支、边界、降级 — 中文为主。

#### 会话沉淀约束（执行优先）

- **最小改动**：需求已明确时，优先小步快改；不做无关重构，不扩大影响面。
- **布局策略**：当需求明确要求不改父子 frame/约束关系时，优先通过 `contentInset` / `scrollIndicatorInsets` 等内边距手段实现视觉间距调整。
- **数据与展示分层**：Model 仅承载接口字段映射（如 MJ）；展示兜底文案（`@""`、`@"--"` 等）放在 Cell 的配置方法，不写死在 Model。
- **列表刷新安全**：请求发起时禁止先 `removeAllObjects` 清空正在展示的数据源；使用局部临时数组承接结果，在主线程一次性替换并 `reloadData`，避免中间态越界与空闪。
- **请求并发约束（列表页）**：默认采用轻量 `isLoading` 防重入；若产品策略是“重复下拉不排队”，允许直接丢弃重复刷新并及时结束刷新动画。
- **请求结果状态命名**：布尔状态优先使用 `*Succeeded`/`*Success` 单一语义，避免同一请求同时维护 `success + failed` 双标记导致分支膨胀。
- **异步回调生命周期处理**：默认使用 `kWeakSelf` + 回调落地处 `__strong typeof(weakSelf) strongSelf = weakSelf; if (!strongSelf) return;`；`strongSelf` 仅在当前回调作用域内使用，不将其持久化到属性。
- **可见性与生命周期解耦**：`weakSelf` 判空用于生命周期安全；是否拦截离屏行为（如离屏不弹 toast）属于产品策略，按页面约定显式选择，不与生命周期判断混用。
- **网络层契约依赖声明**：当业务逻辑依赖“成功/失败/取消均回调”时，需在方法注释或实现处显式声明该契约，便于定位职责边界。
- **批量模型映射优先**：接口返回数组优先使用 MJExtension `mj_objectArrayWithKeyValuesArray` 批量转换，再用谓词/过滤补业务条件，减少逐条转换样板代码。
- **错误提示收敛**：并发请求统一在收敛点提示一次错误；优先展示首个可用错误响应（`firstErrorResponse`），无可用响应再兜底通用文案。
- **防御式 UI 计算**：涉及 `tableView` 宽高计算时，必须考虑早期布局阶段的 0 值场景，提供安全兜底，避免负宽/越界。
- **VC 排版顺序**：默认按 `Lifecycle -> Data/Business -> Layout -> Action -> DataSource -> Delegate -> Lazy load` 组织；使用 `#pragma mark -` 明确分组。
- **视觉常量化**：header 高度、文本边距、底距等可调参数优先抽成常量，便于后续迭代微调。
- **结果回报**：每轮实现后至少输出「改动文件、风险点、验证结果」；纯结构重排需明确“逻辑未变”。

#### 交付说明（编码）

1. 复用了哪些类/服务。
2. 命名与职责是否符合本附录（无例外写「符合」）；线程/列表性能/日志/错误码 — 无则「不适用」。
3. 最小自检：命名与目录、**跨层（对附录 A）**、线程与可观测。

#### 交付说明（分层·提纲）

全文见 plan **附录 A**。

1. 所在层、依赖、禁止跨层点。
2. 落层依据与兼容口径；用户明确要求时补回滚/处置预案。
3. 数据流变化时的链路与最小回归范围。
