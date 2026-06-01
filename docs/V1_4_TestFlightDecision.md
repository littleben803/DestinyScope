# DestinyScope V1.4 TestFlight Decision

决策日期：2026-06-01

## 1. 决策摘要

推荐结论：

- Conditional Go for internal TestFlight preparation。
- No-Go for public App Store release。
- No-Go for default local model enablement。
- No-Go for replacing default result page output。

解释：

- V1.4 已完成受控实验路径的核心准备，包括开关、设备 tier、模型文件状态、结果页润色预览、失败回退、隐私说明和开源许可页面草案。
- 默认主流程仍保持本地规则和模板输出。
- 本地模型仍不能默认开启，也不能作为命理结论生成来源。
- 进入公开 App Store 发布前，license / notice、隐私、审核、设备覆盖和账号签名仍未完全闭环。

## 2. 可以进入的下一步

允许进入受限 TestFlight 内测准备：

- 准备 TestFlight Upload 清单。
- 确认 Apple Developer Program 账号状态。
- 确认 Bundle ID / Signing / Team / Version / Build。
- 准备 Release Archive。
- 准备 TestFlight 审核备注和测试人员说明。
- 人工确认 license / notice。
- 人工确认 GitHub Pages 隐私页公网 URL。
- 继续保持默认输出路径不变。

## 3. 当前不能做的事

当前仍不能：

- 直接进入 App Store 正式发布。
- 默认启用本地模型。
- 把本地模型输出替换默认结果页内容。
- 在 App Store 元数据中宣传本地模型或 AI 能力。
- 把模型生成内容作为命理结论。
- 上传出生信息、命理结果、历史记录、模型输入或模型输出。
- 分发 license / notice 未完全确认的模型文件。
- 提交模型文件、`llama.xcframework` 或 llama.cpp 源码到仓库。

## 4. Go / No-Go 表

| 维度 | 状态 | 说明 |
| --- | --- | --- |
| Debug 构建 | Pass | 模拟器 Debug 构建通过。 |
| Release 构建 | Pass | 模拟器 Release 构建通过。 |
| 默认主流程 | Pass | 默认仍使用本地规则和模板。 |
| 默认 TextRefiner | Pass | `makeDefaultRefiner()` 仍返回 `TemplateTextRefiner()`。 |
| 本地模型实验开关 | Pass | 默认关闭，需用户确认后开启。 |
| 设备 tier | Partial | 已有最小实现，仍需更多机型数据。 |
| 高端设备性能 | Pass | iPhone 17 Pro Max 约 1 秒级。 |
| 低端设备性能 | Risk | iPhone 12 mini 约 4 到 5 秒，不适合默认开启。 |
| 安全回退 | Pass / Partial | 已有安全检查、超时、低电量、过热和失败回退，仍需真机覆盖。 |
| 隐私说明 | Partial | App 内和 GitHub Pages 草案已更新，公网 URL 仍需人工确认。 |
| 开源许可 | Partial | 页面草案已落地，license / notice 仍需人工最终确认。 |
| App Store 审核 | Risk | fortune telling 类和本地模型能力表述仍需谨慎。 |
| TestFlight 内测准备度 | Conditional Go | 可进入准备阶段，但不建议直接上传。 |
| App Store 正式发布准备度 | No-Go | 缺少账号/签名/Archive/license/公网 URL/更多真机测试闭环。 |

## 5. TestFlight 前必须完成项

在真正上传 TestFlight 前，必须完成：

- Apple Developer Program 账号状态确认。
- Bundle ID / Signing / Team / Version / Build 确认。
- 真机完整流程测试。
- GitHub Pages 隐私页公网可访问确认。
- Qwen base repo license 人工留档。
- Qwen GGUF repo license 人工留档。
- llama.cpp license 人工留档。
- 当前实际 GGUF 文件来源 URL 留档。
- 开源许可页面人工审核。
- App Icon 原创或授权确认。
- Release Archive 检查。
- TestFlight 审核备注准备。
- 测试人员说明准备。
- 修正或确认 `OpenSourceLicenseItem.swift` 被 `.gitignore` 忽略的问题。

如果当前 Apple Developer Program 账号尚未付费或未配置：

- 上传 TestFlight 被账号状态阻塞。
- 技术准备和文档准备可以继续。
- 不应尝试上传。

## 6. 下一阶段建议

如果不准备付费 Apple Developer Program：

- 暂停 TestFlight 上传。
- 转入 V1.5 产品体验优化，或继续本地模型质量和安全过滤优化。

如果准备 TestFlight：

- 进入 V1.5 / TestFlight Upload Preparation。
- 聚焦 Bundle ID、Signing、Version、Build、Archive、Review Notes、测试说明和 license / notice 归档。

## 7. 最终结论

V1.4 证明 DestinyScope 的本地模型实验路径已经具备受限内测准备基础，但仍不具备公开 App Store 发布条件。下一阶段应进入 TestFlight 上传准备或产品体验优化，而不是默认启用本地模型或接入生产主流程。
