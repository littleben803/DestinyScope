# DestinyScope V1.6 Next Step Decision

决策日期：2026-06-02

## 1. 决策摘要

| 项目 | 决策 |
|---|---|
| V1.6 Product Feature Polish | Pass |
| TestFlight Upload | Not Now |
| App Store Release | No-Go |
| Local Model Default Enablement | No-Go |
| Continue Product Polish | Go |

V1.6 已完成核心产品功能打磨：首次使用说明、常用出生资料、结果复制 / 分享、知识库收藏 / 最近阅读、历史整理、首页信息架构和本地数据管理。当前建议继续产品打磨和人工验收，不建议立即进入 TestFlight 上传或 App Store 上架。

## 2. 为什么 V1.6 可以标记为 Pass

- Debug / Release 构建通过。
- 默认主流程仍由本地称骨规则、模板解读和本地知识库组成。
- `makeDefaultRefiner()` 仍返回 `TemplateTextRefiner()`。
- 本地模型实验仍受控、默认关闭，不进入默认结果页。
- V1.6 新增数据均只保存在本地设备：
  - Onboarding flag。
  - 常用出生资料。
  - 知识库收藏和最近阅读。
  - 历史收藏 / 置顶状态。
  - 首页快速复查草稿为内存态。
- V1.6 新增数据均有删除或清理路径。
- 结果复制 / 分享为用户手动触发，不保存分享记录，不上传分享内容。
- 静态扫描未发现新增网络请求、支付、追踪或敏感权限。
- 仓库内未发现 `.gguf`、`.bin`、`.safetensors`、`.mlmodel`、`.mlmodelc` 或 `.xcframework`。

## 3. 为什么暂不上传 TestFlight

- 当前策略明确为继续产品功能打磨，而不是上传内测。
- Apple Developer Program、Bundle ID、Signing、Version、Build 和 Archive 尚未作为本阶段目标确认。
- Accessibility、Dynamic Type、深色模式、小屏、iPad、VoiceOver 仍待人工验收。
- GitHub Pages 隐私页公网 URL 仍需人工确认可访问。
- App Icon 授权、license / notice、开源许可最终审计仍需人工留档。
- 如恢复 TestFlight，需要重新执行 V1.4 readiness、V1.5 QA 和 V1.6 新增功能测试。

## 4. 为什么 App Store Release 仍为 No-Go

- 仍未完成完整人工适配验收。
- 仍未完成上架素材、截图、元数据和 Review Notes 最终复核。
- 仍未确认 App Icon 授权、GitHub Pages 隐私 URL 公网可访问、签名和 Archive。
- 本地模型实验仍不是正式发布功能，当前 App Store 元数据不得宣传 AI / 本地模型能力。
- 当前仍未准备 App Store Connect 记录和上传流程。

## 5. 为什么本地模型默认启用仍为 No-Go

- V1.2 / V1.3 决策仍有效：本地模型 PoC 技术可行，但生产化条件未完全闭环。
- iPhone 12 mini / A14 级别设备性能约 4 到 5 秒，不适合默认开启。
- license / notice、模型分发、隐私说明、设备分级和审核文案仍需人工确认。
- 默认用户路径仍应依赖规则引擎和模板系统。
- 本地模型只能作为受控实验路径做文本润色，不能生成命理结论。

## 6. Go / No-Go 表

| 维度 | 状态 | 说明 |
|---|---|---|
| V1.6 功能完成度 | Pass | P0 功能均已实现或形成受控闭环 |
| 构建稳定性 | Pass | Debug / Release 模拟器构建通过 |
| 默认主流程 | Pass | 查询、结果、知识库、历史仍为本地默认路径 |
| 新增本地数据隐私 | Pass | 只本地保存，有删除 / 清理路径 |
| 本地模型默认路径 | Pass | 未默认启用，未替换默认结果页 |
| 网络 / 支付 / 权限 | Pass | Swift 源码未发现新增网络、StoreKit、CloudKit、追踪或敏感权限 |
| Source-control | Pass | Domain/Models Swift 未被忽略，模型文件仍被忽略 |
| Accessibility / 小屏 / 深色 | Partial | 已规划，仍待人工验收 |
| GitHub Pages 隐私 URL | Partial | 本地文件已更新，公网访问需人工确认 |
| TestFlight readiness | Not Now | 暂不上传，恢复前需重新检查 |
| App Store release readiness | No-Go | 上架材料、签名、Archive 和人工验收未完成 |

## 7. 建议下一阶段

推荐下一阶段：

- V1.7：多设备人工验收与无障碍修复。

建议第一批工作：

1. 使用 iPhone SE / mini / Pro Max / iPad 做人工 UI 验收。
2. 覆盖浅色 / 深色模式、Dynamic Type、VoiceOver。
3. 对首页、结果页、知识库、历史、设置、Legal 和本地数据管理逐页记录问题。
4. 只修复明确 UI / accessibility / copy 小问题，不扩大本地模型能力。
5. 继续保持不上传 TestFlight、不准备 App Store 上架，除非另行决策。

备选下一阶段：

- V1.7：截图与上架素材准备。如果目标转为上架，则需要先完成 Apple Developer Program、GitHub Pages URL、Icon 授权、Release Archive 和 App Store Connect 准备。
- V1.7：知识库内容审校。如果目标转为内容质量，则优先人工审校 29 篇知识库和分享文案。

## 8. 最终结论

V1.6 可以标记为产品功能打磨通过。当前不建议上传 TestFlight，不建议 App Store 发布，不建议默认启用本地模型。下一步应进入多设备人工验收和无障碍修复，继续降低上架前体验和合规风险。
