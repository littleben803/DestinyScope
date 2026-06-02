# DestinyScope V1.7 Fix Triage Decision

更新日期：2026-06-02

## 1. 决策摘要

结论：

- 当前无 P0 / P1 / P2 可访问性、小屏、深色模式或 Dynamic Type 问题需要修复。
- V1.7 阶段 3 / 4 / 5 原计划的修复型阶段当前不需要代码改动。
- 允许进入 V1.7 收尾回归与下一步决策。
- 不进入 TestFlight 上传。
- 不进入 App Store 上架。
- 不默认启用本地模型。

本阶段只冻结修复范围，不修改 Swift、工程配置、资源、CSV、JSON、依赖或模型文件。

## 2. 决策依据

依据 V1.7 阶段 2 人工验收结果：

- iPhone 17 Pro Max：人工自测 OK。
- iPhone 12 mini：人工自测 OK。
- VoiceOver：人工自测 OK。
- Dynamic Type：人工自测 OK。
- 深色模式：人工自测 OK。
- 小屏：人工自测 OK。
- iPad：人工自测 OK。
- 本地模型加载和运行：人工自测 OK。
- `pendingCount = 0`。
- 当前无 P0 / P1 / P2 issue。

备注：

- 具体 iOS 版本、App build、iPad 型号和 iPhone SE 专项机型记录仍建议在 TestFlight 或上架前补齐。
- 当前结论基于用户人工自测反馈和既有构建 / 静态扫描记录。

## 3. 修复阶段处理

| phase | decision | reason |
|---|---|---|
| V1.7 阶段 3：P0 可访问性与小屏修复 | No-op | 当前无已确认 P0 issue；本阶段完成修复范围复核 |
| V1.7 阶段 4：深色模式与 Dynamic Type 修复 | Skipped | 当前无深色模式 / Dynamic Type 修复项 |
| V1.7 阶段 5：Legal 长文与开源许可可读性修复 | Skipped | 当前无 Legal 长文 / 开源许可可读性修复项 |

如果未来新增人工反馈问题，应重新打开对应修复阶段，并补充：

- 设备型号。
- iOS 版本。
- App build。
- 复现步骤。
- 截图 / 录屏路径。
- P0 / P1 / P2 优先级。

## 4. 保持边界

继续保持：

- `makeDefaultRefiner()` 返回 `TemplateTextRefiner`。
- 本地模型实验默认关闭。
- Release 不暴露实验入口。
- 默认主流程不依赖本地模型。
- 不上传用户数据。
- 不新增网络 / StoreKit / CloudKit / 追踪 / 敏感权限。
- 不提交模型文件或 `xcframework`。
- 不做模型下载。
- 不接服务端或在线 AI。
- 不进入 App Store 上架流程。
- 不上传 TestFlight。

## 5. 下一步建议

推荐下一步：

- 如果想严格按 Roadmap，进入 V1.7 阶段 6：回归测试与最终自测。
- 如果节省步骤，可合并进入 V1.7 阶段 7：V1.7 自测与下一步决策。

阶段 6 建议重点：

- 默认主流程回归。
- Onboarding / 首页 / 结果页 / 知识库 / 历史 / 设置 / Legal / 本地数据管理回归。
- 仓库模型文件和 framework 检查。
- `makeDefaultRefiner()` 默认路径确认。
- 当前仍不上传 TestFlight、不上架、不默认启用本地模型。
