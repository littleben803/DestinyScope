# DestinyScope V1.4 Roadmap

更新日期：2026-05-29

V1.4 目标是 TestFlight 本地模型内测实现准备，不是 App Store 正式生产化。所有阶段都必须保持本地模型默认关闭、用户手动触发、失败回退模板。

## 当前状态

- V1.3 最终决策为 Conditional Go for limited TestFlight。
- App Store 正式发布仍为 No-Go。
- 本地模型不得默认开启。
- 本地模型不得接入默认结果页主流程。
- V1.4 阶段 1 已启动：TestFlight 实现拆解文档。
- V1.4 阶段 2 已完成：实验开关与配置模型。

## V1.4 阶段 1：TestFlight 实现拆解文档

阶段目标：

- 拆解 TestFlight 内测实现范围。
- 明确开关、设备 tier、模型检测、润色卡片、回退、开源许可和隐私说明的实现顺序。
- 保持默认输出路径不变。

允许修改范围：

- `docs/V1_4_TestFlightImplementationPlan.md`
- `docs/V1_4_Roadmap.md`
- `docs/V1_4_RiskChecklist.md`
- `docs/AppStoreChecklist.md`
- `docs/TestFlightChecklist.md`

不允许做的事：

- 不改 Swift 代码。
- 不改 UI。
- 不改 Xcode 工程配置。
- 不提交模型文件。
- 不提交 `llama.xcframework`。
- 不接生产入口。

验收标准：

- V1.4 实现拆解文档存在。
- V1.4 roadmap 存在。
- V1.4 风险清单存在。
- App Store / TestFlight checklist 已记录 V1.4 状态。

建议 commit message：

```text
Document V1.4 TestFlight implementation plan
```

## V1.4 阶段 2：实验开关与配置模型

阶段目标：

- 设计并实现 `LocalModelExperimentSettings`。
- 默认关闭。
- 仅 Debug / TestFlight 可用。
- Release 正式版默认隐藏或不可用。

允许修改范围：

- `DestinyScope/Domain/TextRefining/*`，仅配置相关文件。
- `DestinyScope/UI/Settings/*`，仅 TestFlight / Debug 实验开关入口。
- `docs/V1_4_Roadmap.md`
- `docs/TestFlightChecklist.md`

不允许做的事：

- 不改变默认 `TextRefinerFactory.makeDefaultRefiner()`。
- 不接默认结果页。
- 不提交模型文件。

验收标准：

- 开关默认关闭。
- 用户可手动开启 / 关闭。
- Release 不展示实验入口。
- 默认输出路径不变。
- 已新增 `LocalModelExperimentConfig`、`LocalModelExperimentSettings`、`LocalModelExperimentAvailability` 和 `LocalModelExperimentSettingsView`。
- 入口当前保守放在 `#if DEBUG` 下，TestFlight 判断留待后续实现。
- 下一阶段为 V1.4 阶段 3：设备 tier 检测技术设计。

建议 commit message：

```text
Add local model experiment settings
```

## V1.4 阶段 3：设备 tier 检测技术设计

阶段目标：

- 设计并实现设备 model identifier 读取。
- 判断 Tier A / Tier B / Tier C。
- 未识别设备默认禁用或谨慎。
- 将低电量模式和 thermal state 作为运行时禁用条件。

允许修改范围：

- `DestinyScope/Services/Device/*`
- `DestinyScope/Domain/TextRefining/*`
- `docs/V1_4_Roadmap.md`

不允许做的事：

- 不默认启用本地模型。
- 不绕过用户开关。
- 不影响主流程。

验收标准：

- 能识别当前设备 tier。
- Tier C 不显示本地润色入口。
- 未识别设备不默认启用。
- 有可测试的回退路径。

建议 commit message：

```text
Add device tier detection for local model experiment
```

## V1.4 阶段 4：模型可用性检测与导入路径整理

阶段目标：

- 检查模型文件是否存在。
- 检查 llama framework 是否可用。
- 检查模型大小。
- 整理 Debug / TestFlight 手动导入路径。

允许修改范围：

- `DestinyScope/Domain/TextRefining/LocalModelDebugConfig.swift`
- `DestinyScope/Services/Storage/LocalModelFileImporter.swift`
- `DestinyScope/Domain/TextRefining/*`
- `docs/V1_4_Roadmap.md`

不允许做的事：

- 不自动下载模型。
- 不把模型复制进 Bundle。
- 不提交模型文件。

验收标准：

- 模型不存在时能显示不可用或回退。
- 模型存在时能通过可用性检查。
- 仓库内无模型文件。

建议 commit message：

```text
Add local model availability checks
```

## V1.4 阶段 5：结果页本地润色预览卡片

阶段目标：

- 在结果页底部设计受控“本地润色预览”卡片。
- 仅实验开关开启、设备支持、模型存在时展示。
- 用户手动点击生成。
- 原始结果始终保留。

允许修改范围：

- `DestinyScope/UI/Result/*`
- `DestinyScope/Domain/TextRefining/*`
- `docs/TestFlightChecklist.md`

不允许做的事：

- 不覆盖原始结果。
- 不写入历史记录。
- 不参与命理问答推理。
- 不做流式 UI。

验收标准：

- 实验关闭不展示入口。
- Tier C 不展示入口。
- 点击生成后原始结果仍可见。
- 失败时显示回退文案。

建议 commit message：

```text
Add TestFlight local refining preview card
```

## V1.4 阶段 6：超时、低电量、过热和失败回退

阶段目标：

- 实现 Tier A / Tier B 超时。
- 实现低电量和 thermal state 禁用。
- 实现连续失败保护。
- 所有失败回退模板。

允许修改范围：

- `DestinyScope/Domain/TextRefining/*`
- `DestinyScope/Services/Device/*`
- `DestinyScope/UI/Result/*`
- `docs/TestFlightChecklist.md`

不允许做的事：

- 不暴露内部错误栈。
- 不让模型失败影响结果页主内容。
- 不保存失败的模型输出。

验收标准：

- Tier A 超过 3 秒回退。
- Tier B 超过 5 秒回退。
- Tier C 不启用。
- 安全检查失败回退。
- 低电量 / 过热回退。

建议 commit message：

```text
Add local model timeout and fallback guards
```

## V1.4 阶段 7：开源许可页面和隐私页面草案落地

阶段目标：

- 准备 App 内“开源许可”入口。
- 准备隐私政策页面更新草案。
- 准备 TestFlight 说明文案。

允许修改范围：

- `DestinyScope/UI/Settings/*`
- `DestinyScope/UI/Legal/*`
- `docs/V1_4_Roadmap.md`
- `docs/AppStoreChecklist.md`

不允许做的事：

- 不更新 App Store Connect 正式元数据。
- 不宣称 AI 算命。
- 不绕过 license / notice 人工确认。

验收标准：

- 开源许可说明覆盖 Qwen、llama.cpp、ggml。
- 隐私说明覆盖本地处理、不上传和回退。
- Release 文案不夸大模型能力。

建议 commit message：

```text
Add local model legal notices draft
```

## V1.4 阶段 8：TestFlight 自测与是否提交内测决策

阶段目标：

- 完成 Debug / Release 构建。
- 完成 Tier A / B / C 行为验证。
- 决定是否提交 TestFlight 内测。

允许修改范围：

- `docs/V1_4_TestReport.md`
- `docs/TestFlightChecklist.md`
- `docs/AppStoreChecklist.md`

不允许做的事：

- 不直接提交 App Store 正式发布。
- 不默认开启本地模型。
- 不宣传本地 AI 功能。

验收标准：

- Debug / Release 构建通过。
- Release 不展示实验入口。
- 默认输出路径不变。
- 仓库无模型文件或 xcframework。
- 输出 TestFlight 决策。

建议 commit message：

```text
Document local model TestFlight readiness
```
