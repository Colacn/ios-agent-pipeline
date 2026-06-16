# 附录 A：CTQ IM/RTC 分层与依赖边界

> 项目 overlay `ctq-ios`。plan / review / develop / test 阶段涉及落层推断时读取本文。

## A.1 作用范围

适用于下列目录（含子目录）的方案推断、落点推演与条文维护：

- `CTQ_IMKit`
- `CTQ_IMLib`
- `CTQ_IMLibBase`
- `CQBase`
- `CTQ_RTCLib`
- `CTQ_RTCKit`
- `CTQIMApplication`

## A.2 例外与不适用

- 与本分层约束无关的目录或上下文（以其他工程约定为准）。
- 未触碰上述目录的改动可不对照本节作落层说明（除非方案主动引用 IM/RTC）。

## A.3 目标落层速查（改什么 → 放哪层）

| 改动内容 | 目标 Target |
| --- | --- |
| 通用 UI 基类、用户模型、公共资源/工具 | `CQBase` |
| IM 登录态、token、协议连接、基础数据中心 | `CTQ_IMLibBase` |
| 消息/会话/联系人等协议无关 IM 能力接口 | `CTQ_IMLib` |
| 消息业务规则、会话/未读业务聚合、对 App 暴露 API | `CTQ_IMKit` |
| 音视频信令、房间与流管理（无业务 UI） | `CTQ_RTCLib` |
| 通话业务逻辑与 UI 组件 | `CTQ_RTCKit` |
| 启动、工作台、导航与壳层集成 | `CTQIMApplication` |

## A.4 核心依赖边界

- App（`CTQIMApplication`）不得直接依赖底层 IM/RTC SDK。
- IM 业务层不得绕过 `CTQ_IMLib` / `CTQ_IMLibBase` 直接操作底层协议状态。
- `CTQ_RTCKit` 必须经由 `CTQ_RTCLib` 访问底层 RTC 能力，不直连第三方 SDK。
- 会话、未读、用户与组织状态读写必须走既有 `Manager` / `Service` / `DataCenter`，禁止旁路写入。

## A.5 模块职责约束

- `CQBase`：公共基座与可复用组件；上层新增公共能力时优先下沉此层。
- `CTQ_IMLibBase`：协议与基础数据中心；不承载 UI 或复杂业务流程。
- `CTQ_IMLib`：稳定、协议无关的 IM 能力接口层；优先保持对上游 API 稳定。
- `CTQ_IMKit`：业务编排与规则聚合层；内部按 `Manager` / `Service` / `RuleEngine` 分责。
- `CTQ_RTCLib`：RTC 能力封装层；不含具体业务 UI。
- `CTQ_RTCKit`：通话业务和 UI 层；通过 IMKit 做 IM 侧协同入口。
- `CTQIMApplication`：应用壳与集成层；不落地底层协议或数据库细节。

## A.6 架构原则

- 分层先行：先确定落层，再落代码；不允许先实现后补分层解释。
- 依赖单向：上层可依赖下层，下层不得反向依赖上层业务模块。
- 数据流单通道：消息/会话/未读等核心状态仅通过既有主链路流转，不新增旁路。
- 兼容前置：涉及消息模型、存储结构、协议字段变更时，先定义兼容窗口；回滚路径仅在用户明确要求时补充。

## A.7 IM/RTC 场景补充

- 涉及消息发送、接收、入库、会话、未读、转发、回执变更时，须按全链路梳理影响（状态、存储、UI、兼容口径），并与现有模块边界、主数据流保持一致。
- 新增 IM 能力优先在 `CTQ_IMLib` 补接口，再由 `CTQ_IMKit` 做业务封装对 App 暴露。
- 从聊天发起音视频通话必须经由既有 IMKit 协同入口，不在 RTCKit 中新建 IM 旁路依赖。

## A.8 方案交付时必须交代

1. **执行前说明**：当前改动所在层级、上下游依赖与禁止跨层点。
2. **方案与交付说明**：落层依据、依赖影响、兼容说明；若用户明确要求，再补充发布后处置与回滚内容。
3. **回归与验证**：若涉及数据流变化，显式标注受影响链路与最小回归范围。
