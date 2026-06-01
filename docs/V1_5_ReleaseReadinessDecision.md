# DestinyScope V1.5 Release Readiness Decision

## 1. 决策摘要

推荐结论：

| 维度 | 决策 |
|---|---|
| Product Experience Optimization | Pass |
| TestFlight Upload | Not Now |
| App Store Release | No-Go |
| Local Model Default Enablement | No-Go |
| Continue Product Polish | Go |

## 2. 结论说明

V1.5 已明显优化普通用户路径：

- 结果页阅读层级更清晰。
- 知识库支持本地分类筛选和搜索。
- 历史记录支持详情页、删除确认和本地保存说明。
- 设置 / 关于 / Legal / 开源许可页面分区更清晰。
- source-control 风险已修复。
- Accessibility、Dark Mode、小屏适配和 QA 检查规划已补齐。

默认主流程仍保持稳定：

- 称骨计算规则未改变。
- `LifeWeightResult` 结构语义未改变。
- 知识库 JSON 未修改。
- 历史记录存储结构未改变。
- `makeDefaultRefiner()` 仍返回 `TemplateTextRefiner`。
- 本地模型实验仍是受控路径，默认关闭。

## 3. 为什么不是 TestFlight Upload

当前不建议立即上传 TestFlight：

- 仍未执行完整人工 Accessibility / Dynamic Type / Dark Mode / 小屏 / iPad 验证。
- Apple Developer Program、Bundle ID、Signing、Version、Build、Archive 未进入上传准备。
- License / notice 仍需人工最终确认。
- GitHub Pages 隐私页与 App 内隐私页上架前仍需复核一致性。
- TestFlight 审核备注和测试人员说明需要按最新 V1.5 状态重新整理。
- Release 构建日志仍出现 Debug llama embed 脚本阶段被调度，虽然脚本在 Release 下 no-op，建议后续清理以降低审核前误解。

## 4. 为什么不是 App Store Release

当前 App Store Release 仍为 No-Go：

- 尚未完成完整多设备人工验收。
- 尚未完成截图、元数据、审核备注、隐私 URL、license / notice 的最终确认。
- 尚未确认 App Icon 原创 / 授权。
- 尚未进入 Archive / signing / build number / App Store Connect 准备。
- 本地模型仍不是正式 Release 功能，不应在当前 App Store 元数据中宣传。

## 5. 为什么本地模型默认启用仍为 No-Go

本地模型仍不应默认启用：

- V1.2 / V1.3 决策为 Conditional Go，仅允许受限 TestFlight 实验准备。
- iPhone 12 mini / A14 级别设备表现约 4-5 秒，不适合默认开启。
- 仍缺更多设备、内存、CPU、Energy、Thermal 数据。
- 安全过滤仍是规则式，需要持续验证。
- 模型 license / notice 仍需人工最终确认。
- 本地模型只允许做文本润色，不允许生成新的命理结论。

## 6. 当前 Go / No-Go 表

| 项目 | 状态 | 说明 |
|---|---|---|
| Debug build | Pass | 构建通过 |
| Release build | Pass | 构建通过 |
| 默认主流程 | Pass | 未依赖本地模型 |
| 结果页体验 | Pass | 已优化阅读层级 |
| 知识库体验 | Pass | 已增加本地筛选和搜索 |
| 历史记录体验 | Pass | 已增加详情、删除确认和本地说明 |
| Legal 体验 | Pass | 已分区优化 |
| Source-control | Pass | `Domain/Models` 不再被误忽略 |
| 模型文件入仓 | Pass | 未发现 `.gguf` / `.xcframework` 等文件 |
| 网络 / 支付 / 权限 | Pass | Swift 源码未发现新增网络、StoreKit、CloudKit、追踪或敏感权限 |
| Accessibility 人工验证 | Pending | 待执行 |
| Dark Mode 人工验证 | Pending | 待执行 |
| Small Screen / iPad 人工验证 | Pending | 待执行 |
| License / notice | Pending | 需人工最终确认 |
| TestFlight 上传准备 | Not Now | 暂不上传 |
| App Store 发布准备 | No-Go | 不具备发布条件 |
| 本地模型默认启用 | No-Go | 仍保持受控实验路径 |

## 7. 下一阶段建议

建议二选一：

1. V1.6：可访问性和多设备人工验收。
   - 执行 `docs/V1_5_QAChecklist.md`。
   - 执行 `docs/V1_5_DeviceTestMatrix.md`。
   - 修复实际发现的小屏、深色、VoiceOver、Dynamic Type 问题。

2. V1.6：截图与上架素材准备。
   - 在产品体验稳定后更新截图规划。
   - 复核 App Store 元数据。
   - 准备审核备注和测试说明。

如果目标是短期上架，应优先选择“可访问性和多设备人工验收”。如果目标是继续打磨产品表达，则可以先做截图和文案规划。

## 8. 最终结论

V1.5 产品体验优化通过。当前不建议上传 TestFlight，不建议进入 App Store Release，不建议默认启用本地模型。

下一步建议继续产品打磨，优先做 V1.6 可访问性和多设备人工验收。

