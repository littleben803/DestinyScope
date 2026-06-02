# DestinyScope V1.7 Manual Test Records

记录日期：2026-06-02

## 1. 文档说明

本文档用于记录 DestinyScope V1.7 多设备人工验收结果。

记录原则：

- 只记录真实测试结果。
- 未实际执行的体验测试项必须标记为 `Pending`。
- 用户明确反馈已经人工自测通过的项目，记录为 `Pass`，并在备注中标明来源为用户人工反馈。
- 本文档不作为 App Store 上架证明。
- 当前仍不上传 TestFlight，不准备 App Store 上架。
- 已通过既有构建记录或当前静态扫描确认的项目，会在备注中明确写出验证来源。

状态可选值：

- `Pass`
- `Fail`
- `Partial`
- `Pending`
- `Not Applicable`

## 2. 测试记录表

| id | date | tester | device | os | build | testArea | status | issues | notes |
|---|---|---|---|---|---|---|---|---|---|
| MTR-A01 | 2026-06-02 | Codex | iOS Simulator generic | 未重新运行 | V1.6 记录 | Debug build | Pass | none | Verified by prior V1.6 build record in `docs/CODEX_PROJECT_STATE.md`; V1.7 阶段 2 未重新运行 Xcode build |
| MTR-A02 | 2026-06-02 | Codex | iOS Simulator generic | 未重新运行 | V1.6 记录 | Release build | Pass | none | Verified by prior V1.6 build record in `docs/CODEX_PROJECT_STATE.md`; V1.7 阶段 2 未重新运行 Xcode build |
| MTR-A03 | 2026-06-02 | Codex | Local repo | macOS | 当前工作区 | 模型文件 / xcframework 仓库检查 | Pass | none | Verified by current static scan: `find . -iname "*.gguf" -o -iname "*.bin" -o -iname "*.safetensors" -o -iname "*.mlmodel" -o -iname "*.mlmodelc" -o -iname "*.xcframework"` returned no files |
| MTR-A04 | 2026-06-02 | Codex | Local repo | macOS | 当前工作区 | `makeDefaultRefiner()` 检查 | Pass | none | Verified by static scan: `TextRefinerFactory.makeDefaultRefiner()` still returns `TemplateTextRefiner()` |
| MTR-A05 | 2026-06-02 | Codex | Local repo | macOS | 当前工作区 | 新增网络 / 支付 / 权限 / 追踪扫描 | Pass | none | Verified by current static scan: Swift source did not match `URLSession`, `OpenAI`, `StoreKit`, `CloudKit`, tracking or sensitive permission keys |
| MTR-B01 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini | 用户未补充 | 用户未补充 | 首页查询 | Pass | none | User manual test feedback: OK |
| MTR-B02 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini | 用户未补充 | 用户未补充 | 结果页 | Pass | none | User manual test feedback: OK |
| MTR-B03 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini | 用户未补充 | 用户未补充 | 命理问答 | Pass | none | User manual test feedback: OK |
| MTR-B04 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini | 用户未补充 | 用户未补充 | 结果复制与分享 | Pass | none | User manual test feedback: OK |
| MTR-B05 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini | 用户未补充 | 用户未补充 | 历史保存 | Pass | none | User manual test feedback: OK |
| MTR-C01 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini | 用户未补充 | 用户未补充 | Onboarding | Pass | none | User manual test feedback: OK |
| MTR-C02 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini | 用户未补充 | 用户未补充 | 常用出生资料 | Pass | none | User manual test feedback: OK |
| MTR-C03 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini | 用户未补充 | 用户未补充 | 知识库收藏 / 最近阅读 | Pass | none | User manual test feedback: OK |
| MTR-C04 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini | 用户未补充 | 用户未补充 | 历史收藏 / 置顶 / 快速复查 | Pass | none | User manual test feedback: OK |
| MTR-C05 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini | 用户未补充 | 用户未补充 | 本地数据管理 | Pass | none | User manual test feedback: OK |
| MTR-D01 | 2026-06-02 | User | iPhone 12 mini | 用户未补充 | 用户未补充 | 小屏 / Dynamic Type | Pass | none | User manual test feedback: 小屏和 Dynamic Type OK；iPhone SE 专项机型信息未补充 |
| MTR-D02 | 2026-06-02 | User | iPhone 12 mini | 用户未补充 | 用户未补充 | 小屏 / Tier C 本地模型边界 | Pass | none | User manual test feedback: OK |
| MTR-D03 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini | 用户未补充 | 用户未补充 | 默认主流程回归 | Pass | none | User manual test feedback: OK |
| MTR-D04 | 2026-06-02 | User | iPhone 17 Pro Max | 用户未补充 | 用户未补充 | 大屏 / 本地模型实验参考 | Pass | none | User manual test feedback: OK |
| MTR-D05 | 2026-06-02 | User | iPad | 用户未补充 | 用户未补充 | iPad 布局 | Pass | none | User manual test feedback: iPad OK；具体 iPad 型号未补充 |
| MTR-D06 | 2026-06-02 | User | Simulator | 用户未补充 | 用户未补充 | Simulator 手工体验 | Pass | none | User manual test feedback: OK |
| MTR-D07 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini / iPad | 用户未补充 | 用户未补充 | 深色模式 | Pass | none | User manual test feedback: OK |
| MTR-D08 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini / iPad | 用户未补充 | 用户未补充 | Dynamic Type | Pass | none | User manual test feedback: OK |
| MTR-D09 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini / iPad | 用户未补充 | 用户未补充 | VoiceOver | Pass | none | User manual test feedback: OK |
| MTR-E01 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini | 用户未补充 | 用户未补充 | Release 隐藏实验入口 | Pass | none | User manual test feedback: OK |
| MTR-E02 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini | 用户未补充 | 用户未补充 | 本地模型实验默认关闭 | Pass | none | User manual test feedback: OK |
| MTR-E03 | 2026-06-02 | User | iPhone 12 mini | 用户未补充 | 用户未补充 | Tier C 禁用 | Pass | none | User manual test feedback: OK |
| MTR-E04 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini | 用户未补充 | 用户未补充 | 模型不存在时不可用 | Pass | none | User manual test feedback: OK |
| MTR-E05 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini | 用户未补充 | 用户未补充 | 本地模型失败回退 | Pass | none | User manual test feedback: OK |
| MTR-E06 | 2026-06-02 | User | iPhone 17 Pro Max / iPhone 12 mini | 用户未补充 | 用户未补充 | 本地模型结果不写历史 | Pass | none | User manual test feedback: OK |
| MTR-E07 | 2026-06-02 | Codex | Local repo | macOS | 当前工作区 | `makeDefaultRefiner` 仍为 `TemplateTextRefiner` | Pass | none | 与 MTR-A04 同源，作为本地模型边界重复登记 |

## 3. 人工反馈记录规则

- 用户已反馈 iPhone 17 Pro Max、iPhone 12 mini、VoiceOver、Dynamic Type、深色模式、小屏、iPad、本地模型加载和运行等均已人工自测通过。
- 当前没有真实人工测试失败项，因此不新增确认问题。
- 具体 iOS 版本、App build 和 iPad 型号未在本次反馈中补充，后续如用于上架或 TestFlight，建议补齐。
- 后续每次人工测试应使用 `docs/V1_7_ManualTestTemplate.md` 记录，并同步更新本文件和 `docs/V1_7_AccessibilityIssueBacklog.md`。
