---
name: plan
description: Use this skill when turning analyze-stage outputs into reviewable iOS/IM/RTC technical plans, especially for cross-module changes, layered dependency decisions, and Appendix A evolution. It defines implementation boundaries, risks, validation, and handoff-ready planning outputs.
---

# Plan（方案规划）

## Instructions

1. 完整执行规范见 [`references/execution-playbook.md`](references/execution-playbook.md)（**优先通读**）。**runs 工区**：落盘 **plan** 技术方案 `outputs/plan.solution.md` 前若尚无 `/runs/<slug>/`，在仓库根执行 [`scripts/bootstrap-run.sh`](scripts/bootstrap-run.sh) `<slug>`（转发至 `/.cursor/scripts` 权威实现；与其他 Skill 同源）。
2. **Layering authority**：本 Skill **附录 A** 为 IM/RTC 分层与依赖条文的维护载体。
3. **编码与协作侧约定（实现时对照）**：`.cursor/skills/develop/SKILL.md` **Appendix**（「协作与质量纪律」+「编码规范」）。
4. **Process**：产研流水线与门禁见 [`AGENTS.md`](../../../AGENTS.md)「Cursor 路由与工作流」；演进附录 A 或改动共享底座文档（如 `AGENTS.md`）须**征得用户同意**（见 `AGENTS.md`「执行前确认」）。
5. **Upstream / downstream**：输入优先来自 `analyze`（经对齐的边界与材料，或规格化需求包）；输出面向 `review` 与 `develop`。
6. **流水线硬门禁**：以 [`AGENTS.md`](../../../AGENTS.md) 路由总览 + [`../../references/workflow/pipeline.md`](../../references/workflow/pipeline.md) 细则为准；本 Skill 仅补充 plan 侧特有执行细则。
7. **内容边界承接**：**analyze** 的 `outputs/analyze.requirements.md` 默认只承载需求与验收口径；**plan** 的 `outputs/plan.solution.md` 负责落层、设计决策、实现路径与技术取舍等实现细节。
8. **承接「极简需求清单」**（与 `analyze` 第 9 条对表）：
   - 当 **analyze** 需求清单 `analyze.requirements.md` 仅为**少量编号条目**时，**不得**因需求侧清单变短而缺失约束；须在 `plan.solution.md` 内用 **§0 对表索引** + **后文各章中的可验收细则** 把约束写全，并保证**阻塞项、条数/体积、分档、兼容**等均有落点可稽核。
   - **正文为真源，不单拧 §0.1**：与每条需求相关的**实现口径、边界、状态机、测试**等**应写在对应的方案章节**（如现状/决策/范围/迁移/测试等），**不要**在文首再整节 **「§0.1 需求清单 N 条 — 本方案细则承接」** 与后文**重复铺陈**；§0 保留 **与《需求清单》对应关系** 的**索引表**即可（必要时在正文用「（需求第 k 条）」子标题或一句交叉引用，仍属正文而非单独「说明区」）。
   - **元说明禁写**：**不要**在方案中加「从 PRD/评审迁入、analyze 需求清单不再逐条展开」等**仅作分工注脚、无验收信息**的句子；与 `analyze` 的边界（见上第 7 条与 analyze Skill）**不须在方案中复述**。
   - **措辞**：与 analyze 一致，方案正文**默认不**以「移动端 / iOS 端」等作无信息增益的装饰；跨端对照（如 Harmony 与**本端**）可保留，但须有必要性。

## On-demand references（按需读取）

- 需要快速核对方案结构与必填项时：读取 `references/plan-checklist.md`
- 用户明确要求回滚/处置预案时：读取 `references/risk-gate.md`
- 需要完整 SOP（结构/流程/澄清/闸门）时：读取 `references/execution-playbook.md`

## Quick start

- 先读 **附录 A** 与 `references/execution-playbook.md`「方案规划原则」再追 1～2 条真实调用链。
- 方案中必须显式：落层、依赖方向、兼容口径、数据流受影响范围；并与上游分析条目可对表。  
  - 回滚/处置预案默认不作为必填；仅当用户明确要求时补充完整方案。
- **走流水线**时方案须含 **第 11）测试策略与验证衔接**（见 execution-playbook，含测试范围与优先级），供 `review` / `develop` 衔接。

## When not to use

- 仅改文案/UI 且不动分层与接口（可由 `develop` 在明确边界下处理）。
- 无任何需求/分析上下文且用户拒绝补充。

## Related rules

- `AGENTS.md`（产研流水线与工作流）
- `.cursor/skills/develop/SKILL.md` **Appendix**「协作与质量纪律」

---

## Appendix A：分层与依赖边界

### A.1 作用范围

适用于下列目录（含子目录）的方案推断、落点推演与条文维护：

- `CTQ_IMKit`
- `CTQ_IMLib`
- `CTQ_IMLibBase`
- `CQBase`
- `CTQ_RTCLib`
- `CTQ_RTCKit`
- `CTQIMApplication`

### A.2 例外与不适用

- 与本分层约束无关的目录或上下文（以其他工程约定为准）。
- 未触碰上述目录的改动可不对照本节作落层说明（除非方案主动引用 IM/RTC）。

### A.3 协作分工

- 产研流水线与门禁：[`AGENTS.md`](../../../AGENTS.md)「产研流水线与工作流」
- 编码实现约束：`.cursor/skills/develop/SKILL.md` — Appendix（编码规范）

### A.4 硬性约束

#### 1) 目标落层速查（改什么 → 放哪层）

| 改动内容 | 目标 Target |
| --- | --- |
| 通用 UI 基类、用户模型、公共资源/工具 | `CQBase` |
| IM 登录态、token、协议连接、基础数据中心 | `CTQ_IMLibBase` |
| 消息/会话/联系人等协议无关 IM 能力接口 | `CTQ_IMLib` |
| 消息业务规则、会话/未读业务聚合、对 App 暴露 API | `CTQ_IMKit` |
| 音视频信令、房间与流管理（无业务 UI） | `CTQ_RTCLib` |
| 通话业务逻辑与 UI 组件 | `CTQ_RTCKit` |
| 启动、工作台、导航与壳层集成 | `CTQIMApplication` |

#### 2) 核心依赖边界

- App（`CTQIMApplication`）不得直接依赖底层 IM/RTC SDK。
- IM 业务层不得绕过 `CTQ_IMLib` / `CTQ_IMLibBase` 直接操作底层协议状态。
- `CTQ_RTCKit` 必须经由 `CTQ_RTCLib` 访问底层 RTC 能力，不直连第三方 SDK。
- 会话、未读、用户与组织状态读写必须走既有 `Manager` / `Service` / `DataCenter`，禁止旁路写入。

#### 3) 模块职责约束

- `CQBase`：公共基座与可复用组件；上层新增公共能力时优先下沉此层。
- `CTQ_IMLibBase`：协议与基础数据中心；不承载 UI 或复杂业务流程。
- `CTQ_IMLib`：稳定、协议无关的 IM 能力接口层；优先保持对上游 API 稳定。
- `CTQ_IMKit`：业务编排与规则聚合层；内部按 `Manager` / `Service` / `RuleEngine` 分责。
- `CTQ_RTCLib`：RTC 能力封装层；不含具体业务 UI。
- `CTQ_RTCKit`：通话业务和 UI 层；通过 IMKit 做 IM 侧协同入口。
- `CTQIMApplication`：应用壳与集成层；不落地底层协议或数据库细节。

#### 4) 架构原则

- 分层先行：先确定落层，再落代码；不允许先实现后补分层解释。
- 依赖单向：上层可依赖下层，下层不得反向依赖上层业务模块。
- 数据流单通道：消息/会话/未读等核心状态仅通过既有主链路流转，不新增旁路。
- 兼容前置：涉及消息模型、存储结构、协议字段变更时，先定义兼容窗口；回滚路径仅在用户明确要求时补充。

#### 5) IM/RTC 场景补充

- 涉及消息发送、接收、入库、会话、未读、转发、回执变更时，须按全链路梳理影响（状态、存储、UI、兼容口径），并与现有模块边界、主数据流保持一致。
- 新增 IM 能力优先在 `CTQ_IMLib` 补接口，再由 `CTQ_IMKit` 做业务封装对 App 暴露。
- 从聊天发起音视频通话必须经由既有 IMKit 协同入口，不在 RTCKit 中新建 IM 旁路依赖。

### A.5 方案交付时必须交代

1. **执行前说明**：当前改动所在层级、上下游依赖与禁止跨层点。
2. **方案与交付说明**：落层依据、依赖影响、兼容说明；若用户明确要求，再补充发布后处置与回滚内容。
3. **回归与验证**：若涉及数据流变化，显式标注受影响链路与最小回归范围。
