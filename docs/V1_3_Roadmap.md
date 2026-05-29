# DestinyScope V1.3 Roadmap

更新日期：2026-05-29

V1.3 目标是本地模型生产化方案设计，不是立即把本地模型接入正式用户主流程。所有阶段都必须保持本地模型只做文本润色，不能负责命理计算或最终结论。

## 当前状态

- V1.2 PoC 已完成。
- V1.2 最终决策为 Conditional Go。
- V1.3 阶段 1 已启动：生产化方案设计。
- 当前 Release 仍不包含本地模型功能。
- 当前 App Store 元数据不应宣传 AI / 本地模型。

## V1.3 阶段 1：生产化方案设计

阶段目标：

- 明确本地模型不直接进入默认结果页。
- 设计模型分发、设备分级、隐私、审核、安全和回退策略。
- 确定推荐方向为可选实验功能，而不是默认主流程。

允许修改范围：

- `docs/V1_3_LocalModelProductionPlan.md`
- `docs/V1_3_ModelDistributionPlan.md`
- `docs/V1_3_PrivacyAndReviewPlan.md`
- `docs/V1_3_Roadmap.md`
- `docs/AppStoreChecklist.md`

不允许做的事：

- 不改 Swift 代码。
- 不改 UI 页面。
- 不改工程配置。
- 不提交模型文件。
- 不接生产入口。
- 不更新正式隐私政策页面或 App Store 元数据。

验收标准：

- V1.3 生产化方案文档存在。
- 明确推荐方案为默认关闭的本地润色实验开关。
- 明确不建议默认启用本地模型。
- 明确下一阶段为设备分级与最低设备策略。

建议 commit message：

```text
Document V1.3 local model production plan
```

## V1.3 阶段 2：设备分级与最低设备策略

阶段目标：

- 基于 V1.2 benchmark 制定设备分级规则。
- 明确 iPhone 12 mini / A14 级别设备默认关闭或仅实验开启。
- 定义最低设备要求和后续 benchmark 清单。

允许修改范围：

- `docs/V1_3_DevicePolicy.md`
- `docs/V1_2_DeviceBenchmark.md`
- `docs/V1_3_Roadmap.md`

不允许做的事：

- 不实现设备检测代码。
- 不开放生产入口。
- 不修改默认输出路径。

验收标准：

- 明确设备等级。
- 明确最低设备建议。
- 明确哪些设备隐藏或禁用本地模型。
- 明确 Instruments 观察项。

建议 commit message：

```text
Document local model device policy
```

## V1.3 阶段 3：TestFlight 内测开关设计

阶段目标：

- 设计本地模型 TestFlight 内测开关。
- 明确默认关闭。
- 明确仅符合设备策略时显示。
- 明确用户关闭后始终回退模板。

允许修改范围：

- `docs/V1_3_TestFlightTogglePlan.md`
- `docs/V1_3_Roadmap.md`
- `docs/AppStoreChecklist.md`

不允许做的事：

- 不新增真实开关代码。
- 不进入 Release 默认路径。
- 不修改隐私政策正式页面。

验收标准：

- 开关默认状态明确。
- 设备不满足条件时的行为明确。
- 回退和错误提示策略明确。

建议 commit message：

```text
Document TestFlight local model toggle plan
```

## V1.3 阶段 4：本地模型润色入口设计，不进入默认主流程

阶段目标：

- 设计本地模型只用于 `TextRefining` 的入口。
- 不接命理计算。
- 不接普通结果页默认输出。
- 设计用户可理解的“本地润色实验”说明。

允许修改范围：

- `docs/V1_3_TextRefiningEntryPlan.md`
- `docs/V1_3_Roadmap.md`

不允许做的事：

- 不实现生产入口。
- 不修改 `LifeWeightEngine`。
- 不修改结果页默认输出。
- 不做开放聊天。

验收标准：

- 明确输入只来自已生成模板文本。
- 明确输出必须经过 SafetyChecker。
- 明确失败时回退 `TemplateTextRefiner`。

建议 commit message：

```text
Document local model text refining entry
```

## V1.3 阶段 5：隐私政策和审核材料更新草案

阶段目标：

- 准备隐私政策、审核备注和元数据更新草案。
- 说明本地模型只在设备端处理。
- 说明不上传出生信息、结果、模型输入或输出。

允许修改范围：

- `docs/V1_3_PrivacyAndReviewPlan.md`
- `docs/AppReviewNotes_LocalModelDraft.md`
- `docs/PrivacyPolicy_LocalModelDraft.md`
- `docs/AppStoreChecklist.md`

不允许做的事：

- 不修改 App 内隐私政策页面。
- 不修改 GitHub Pages 隐私页。
- 不修改正式 App Store 元数据生产文案。

验收标准：

- 草案覆盖本地处理、无上传、失败回退和免责声明。
- 草案不宣传精准预测或 AI 决定命运。
- 明确正式启用前才更新生产文案。

建议 commit message：

```text
Draft local model privacy and review notes
```

## V1.3 阶段 6：license / notice 审计

阶段目标：

- 审计 Qwen2.5 GGUF 的来源、license、notice、商用和再分发条件。
- 明确是否允许 App 内分发。
- 明确需要展示或打包的 notice 内容。

允许修改范围：

- `docs/V1_3_ModelLicenseAudit.md`
- `docs/V1_3_ModelDistributionPlan.md`
- `docs/AppStoreChecklist.md`

不允许做的事：

- 不提交模型文件。
- 不把模型加入 App Bundle。
- 不在 license 未确认前进入生产。

验收标准：

- 记录模型 repo URL 和 GGUF 文件 URL。
- 记录 license 类型和人工确认人 / 日期。
- 明确是否允许商业使用、再分发和 App 内分发。

建议 commit message：

```text
Document local model license audit
```

## V1.3 阶段 7：是否允许进入 TestFlight 内测

阶段目标：

- 基于设备策略、隐私草案、license 审计和安全策略，决定是否进入 TestFlight 内测代码改造。
- 输出 go / no-go / conditional-go 决策。

允许修改范围：

- `docs/V1_3_TestFlightDecision.md`
- `docs/V1_3_Roadmap.md`
- `docs/AppStoreChecklist.md`

不允许做的事：

- 不在本阶段直接实现 TestFlight 开关。
- 不把模型功能接入 Release。
- 不绕过 license、隐私和安全审查。

验收标准：

- 明确是否允许开始 TestFlight 内测实现。
- 明确仍不能默认进入主流程。
- 明确失败回退和设备分级要求。

建议 commit message：

```text
Document local model TestFlight decision
```
