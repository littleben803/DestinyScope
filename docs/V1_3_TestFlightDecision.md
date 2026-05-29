# DestinyScope V1.3 TestFlight Decision

更新日期：2026-05-29

## 1. 决策摘要

推荐结论：

- **Conditional Go**：允许进入“受限 TestFlight 内测实现设计 / 准备”。
- **No-Go**：不允许进入 App Store 正式发布。
- **No-Go**：不允许默认开启本地模型。
- **No-Go**：不允许把本地模型直接接入默认结果页。

本决策只允许进入下一阶段的实现准备和拆解，不代表可以直接改生产主流程。

## 2. 允许进入 TestFlight 的前提

必须满足：

- 功能默认关闭。
- 用户手动开启。
- 首次开启展示实验说明。
- 只对 Tier A 或允许的 Tier B 设备展示。
- Tier C 默认不展示或不可用。
- 只用于 `TextRefining` 润色。
- 不生成新的命理结论。
- 不替代称骨计算和模板规则。
- 不保存润色结果。
- 不覆盖原始结果。
- 失败回退 `TemplateTextRefiner`。
- Release 默认隐藏。
- 不宣传为 AI 算命。
- 不上传用户数据。
- 不上传模型输入输出。
- 不上传历史记录。

如果任一前提无法满足，不应进入 TestFlight 内测实现。

## 3. 当前可以做的下一步

可以进入 V1.4 或 V1.3-Implementation Planning：

- 设计 TestFlight 内测开关实现。
- 设计设备 tier 检测。
- 设计本地润色预览卡片实现。
- 设计本地模型文件分发 / 导入内测方案。
- 设计 App 内开源许可页面。
- 设计隐私页面更新。
- 继续保持默认输出路径不变。

下一阶段仍应先做实现拆解和技术设计，不建议直接大改 Swift 代码。

## 4. 当前不能做的事

- 不能进入 App Store 正式发布。
- 不能默认启用本地模型。
- 不能在 App Store 元数据宣传 AI / 本地模型。
- 不能承诺预测准确性。
- 不能宣传改命、化解、转运、必然发财。
- 不能把模型生成结果作为命理结论。
- 不能上传出生信息或模型输入输出。
- 不能分发 license 未完全确认的模型。
- 不能把本地模型接入默认结果页主流程。
- 不能让模型替代规则引擎。

## 5. Go / No-Go 表

| 维度 | 状态 | 说明 |
| --- | --- | --- |
| 技术可行性 | Pass | V1.2 已验证 llama.cpp + Qwen2.5 0.5B Q4 GGUF 可加载和生成。 |
| 高端设备性能 | Pass | iPhone 17 Pro Max 约 1 秒级，适合受限内测。 |
| 低端设备性能 | Risk | iPhone 12 mini 约 4 到 5 秒，不适合默认开启。 |
| 安全回退 | Pass / Partial | SafetyChecker 和 fallback 已生效，但仍需更多样例和实现级保护。 |
| Prompt 稳定性 | Partial | 已优化 prompt，但出现过特殊 token 泄露，需要继续处理。 |
| 设备分级策略 | Partial | 已有 Tier A / B / C 设计，尚未实现设备检测。 |
| 隐私草案 | Partial | 已有草案，但尚未更新正式 App 内页面和 GitHub Pages。 |
| License / notice | Partial | 已完成初步审计，仍需人工确认和落地 notice。 |
| App Store 审核 | Risk | 算命和 AI 表述有审核风险，正式发布前需更严格材料。 |
| 正式发布准备度 | No-Go | 不能进入 App Store 正式发布。 |
| TestFlight 内测准备度 | Conditional Go | 可进入受限 TestFlight 实现准备。 |

## 6. TestFlight 前置清单

在真正实现 TestFlight 内测前，仍需要完成：

- 人工确认 Qwen base repo license。
- 人工确认 Qwen GGUF repo license。
- 人工确认 llama.cpp license。
- 准备 App 内开源许可 / notice 页面。
- 确认模型文件如何进入 TestFlight 构建或如何由测试人员导入。
- 确认模型不会误提交仓库。
- 实现设备 tier 检测。
- 实现低电量 / 过热 / 超时回退。
- 实现本地润色预览卡片。
- 更新 App 内隐私政策页面草案。
- 更新 GitHub Pages 隐私页草案。
- 更新 TestFlight 测试说明。
- 明确 TestFlight 包是否包含模型文件。
- 明确如果不含模型，测试人员如何导入模型。

## 7. 建议下一阶段

推荐下一阶段命名：

- V1.4：TestFlight 本地模型内测实现准备。
- 或 V1.3 Implementation：TestFlight 实验功能实现规划。

建议第一阶段仍不要直接大改代码，而是先做：

- TestFlight 实现拆解文档。
- 设备 tier 检测技术设计。
- 模型分发方式最终选择。
- 开源许可页面设计。
- 隐私页面和 GitHub Pages 更新计划。
- 测试人员说明文案定稿。

## 8. 最终结论

V1.3 证明本地模型具备进入受限 TestFlight 内测的条件。

但正式 App Store 发布仍不具备条件。

下一步应进入 TestFlight 实现准备阶段，而不是直接接入生产主流程。
