# DestinyScope 当前项目状态

## 当前方向

当前 V1.8 方向已经发生用户明确变更：

- 本地模型从 Debug / TestFlight 风格实验能力升级为生产候选能力。
- 设备评分达到标准时默认启用本地 AI 润色能力和入口。
- 模拟器默认启用本地 AI 能力。
- 模型文件计划直接打包进 App 安装包。
- 首页第一屏必须聚焦生辰查询，查询按钮应尽量首屏可见。
- 阶段缩短，加速实现。

当前仍暂不准备：

- 上传 TestFlight
- 上架 App Store
- 增加服务端
- 增加在线 AI
- 增加登录
- 增加支付订阅
- 做模型下载
- 做 RAG
- 做开放聊天
- 做流式 UI

当前重点：

- V1.8 生产环境本地 AI 润色与首页主路径强化
- 让首页第一屏更聚焦出生日期、出生时辰和查询按钮
- 通过设备评分决定是否默认启用本地 AI 润色
- 将本地模型作为生产候选能力接入结果页润色展示
- 保持默认主流程稳定
- 保持本地优先
- 保持隐私友好
- 保持本地模型只做表达润色，不生成新的命理结论
- 保持失败、超时、低电量、过热、设备不达标和安全检查失败时回退模板

## 已完成版本

### V1.0

Native 基线版本：

- 本地称骨计算引擎
- 模板式命理解读
- 本地知识库
- 隐私政策
- 免责声明
- App Icon
- Launch Screen
- GitHub Pages 隐私页
- App Store 元数据草案

### V1.1

离线体验增强：

- LifeWeightInsight 命格洞察
- 本地模板命理问答
- 29 篇知识库文章
- rag_chunks 预留
- 本地历史记录
- TextRefining 接口预留

### V1.2

本地小模型 PoC：

- llama.cpp + Qwen2.5-0.5B Q4 GGUF Debug PoC 跑通
- TextRefining PoC 跑通
- SafetyChecker 和 fallback 生效
- 结论：技术可行，但不进入生产

### V1.3

本地模型生产化方案设计：

- 设备分级策略
- TestFlight 实验开关设计
- 本地润色入口设计
- 隐私和审核材料草案
- license / notice 初步审计
- 结论：Conditional Go for limited TestFlight，不进入正式 App Store

### V1.4

TestFlight 本地模型内测实现准备：

- 实验开关
- 设备 tier 检测
- 模型文件可用性检测
- 本地润色预览卡片
- 超时、低电量、过热和失败回退
- 开源许可页面
- 隐私政策更新
- TestFlight readiness 决策
- 当前不上传 TestFlight

### V1.5

产品体验优化：

- source-control 修复
- UI / UX 全量审计
- 结果页阅读体验优化
- 知识库浏览体验优化
- 历史记录体验优化
- 设置 / 关于 / Legal / 开源许可体验优化
- 可访问性、深色模式、小屏适配 QA 规划
- V1.5 自测和 readiness 决策
- 结论：继续产品打磨，不上传 TestFlight，不上架 App Store

## 当前推荐下一版本

V1.8：生产环境本地 AI 润色与首页主路径强化。

候选方向：

- 模型内置到 App Bundle。
- llama framework 生产候选接入。
- 设备评分默认启用。
- 模拟器默认启用。
- 首页第一屏重构，聚焦生辰查询。
- 结果页展示本地润色版，模板结果始终保留。
- 失败回退模板。
- 继续不接服务端、在线 AI、模型下载、RAG、开放聊天、流式 UI 或付费订阅。

当前 V1.8 进度：

- 阶段 1：生产本地 AI 与首页主路径方案冻结已完成。
- 已新增 `docs/V1_8_ProductionLocalAIPlan.md`。
- 已新增 `docs/V1_8_DeviceScoringPlan.md`。
- 已新增 `docs/V1_8_BundledModelPlan.md`。
- 已新增 `docs/V1_8_HomeFirstScreenPlan.md`。
- 已新增 `docs/V1_8_Roadmap.md`。
- 本阶段只修改 docs，没有修改 Swift、工程配置、资源、CSV、JSON、依赖或模型文件。
- 当前下一阶段建议：V1.8 阶段 2，模型内置、llama framework 生产化、设备评分默认启用。
- 阶段 2：生产候选本地 AI 能力一次性接入和首页第一屏重构已完成。
- 已新增 `.gitattributes`，GGUF 和 `llama.xcframework` 指定走 Git LFS。
- 已将 `qwen2.5-0.5b-instruct-q4_k_m.gguf` 放入 `DestinyScope/Resources/Models/`。
- 已将 `llama.xcframework` 放入 `DestinyScope/Frameworks/`。
- 已移除旧的手工 `Embed llama.xcframework` 脚本阶段，改由 Xcode 标准 `ProcessXCFramework` 处理。
- 已新增设备评分服务和生产候选可用性判断：模拟器默认启用，高分设备默认启用，iPhone 12 mini / `iPhone13,1` 默认模板。
- `makeDefaultRefiner()` 已按 V1.8 用户方向变更调整为 `AutoLocalTextRefiner()`；本地模型不可用或失败时回退 `TemplateTextRefiner`。
- 结果页新增生产候选本地润色版展示，模板结果始终保留，本地润色不写入历史、不生成新的命理结论。
- 首页第一屏已前置生辰查询输入卡片，压缩 Hero 和隐私说明，辅助入口后置。
- App 内隐私政策、开源许可说明和 GitHub Pages 隐私页已补充生产候选本地模型说明。
- Debug build：通过。
- Release build：通过。
- 阶段 3：生产候选自测与上线风险收口已完成。
- 已新增 `docs/V1_8_ProductionCandidateTestReport.md`。
- 已新增 `docs/V1_8_ReleaseRiskDecision.md`。
- Debug build：通过。
- Release build：通过。
- GGUF 已由 Git LFS 跟踪，文件大小 `491400032 bytes`，sha256 为 `74a4da8c9fdbcd15bd1f6d01d621410d31c6fc00986f5eb687824e7b93d7a9db`。
- Release Simulator `.app` 约 `502M`，已包含 GGUF 和 `Frameworks/llama.framework/llama`。
- 决策结论：Production Candidate: Conditional Go。
- 当前仍不得上传 App Store。
- 当前仍不建议上传 TestFlight，除非用户明确要求并重新执行 TestFlight readiness。
- 当前下一阶段建议：V1.8 阶段 4，真机生产包复测与上线前材料修复。

当前 V1.7 进度：

- 阶段 1：多设备人工验收与无障碍修复计划已完成。
- 已新增 `docs/V1_7_AccessibilityDeviceQAPlan.md`。
- 已新增 `docs/V1_7_Roadmap.md`。
- 已新增 `docs/V1_7_DeviceTestMatrix.md`。
- 已新增 `docs/V1_7_AccessibilityIssueBacklog.md`。
- 已新增 `docs/V1_7_ManualTestTemplate.md`。
- 阶段 2：人工验收记录汇总框架已完成。
- 已新增 `docs/V1_7_ManualTestRecords.md`。
- 已新增 `docs/V1_7_ManualTestSummary.md`。
- 用户已反馈 iPhone 17 Pro Max、iPhone 12 mini、VoiceOver、Dynamic Type、深色模式、小屏、iPad、本地模型加载和运行等均已人工自测 OK。
- 当前没有已确认 P0 issue；V1.7 阶段 3 暂无需要修复的问题，可跳过到阶段 6 回归测试或阶段 7 自测与下一步决策。
- 本阶段只修改 docs，没有修改 Swift、工程配置、资源、CSV、JSON、依赖或模型文件。
- 当前下一阶段建议：如不需要补录更多设备细节，可进入 V1.7 阶段 6：首页 / 结果页 / 知识库 / 历史回归测试，或阶段 7：V1.7 自测与下一步决策。
- 阶段 3：人工验收结果复核与修复范围冻结已完成。
- 已新增 `docs/V1_7_FixTriageDecision.md`。
- V1.7 阶段 3 为 no-op：当前无 P0 / P1 / P2 修复项。
- V1.7 阶段 4 / 5 当前 skipped：无深色模式、Dynamic Type、Legal 长文或开源许可可读性修复项。
- 阶段 6：回归测试已合并到阶段 7。
- 阶段 7：V1.7 自测与下一步决策已完成。
- 已新增 `docs/V1_7_TestReport.md`。
- 已新增 `docs/V1_7_NextStepDecision.md`。
- Debug build：通过。
- Release build：通过。
- 当前无 P0 / P1 / P2 修复项。
- V1.7 Accessibility & Multi-device QA：Pass。
- TestFlight Upload：Not Now。
- App Store Release：No-Go。
- Local Model Default Enablement：No-Go。
- Continue Product Polish：Go。
- 当前下一阶段建议：V1.8 产品细节继续打磨。

当前 V1.6 进度：

- 阶段 1：产品功能打磨目标与路线冻结已完成。
- 阶段 2：首次使用说明 / Onboarding 已完成。
- Onboarding 使用 `UserDefaults` key `hasCompletedOnboarding` 保存完成状态。
- 首次启动自动展示，完成后不再自动展示。
- 设置页和关于页可再次打开使用说明。
- 阶段 3：常用出生资料 / 本地 Profile 曾完成，后续产品优化中已下线。
- 首页“常用资料”卡片和“保存为常用资料”入口已移除。
- 设置页常用出生资料管理入口已移除。
- 阶段 4：结果页系统分享能力已调整。
- 结果页底部“复制与分享”卡片已移除；当前通过 titlebar 分享按钮调用系统分享，只分享称骨诗文和命格详解，不保存分享记录、不上传。
- 阶段 5：知识库收藏与最近阅读已完成。
- 知识库收藏和最近阅读使用 Application Support 下 `DestinyScope/knowledge_library_state.json` 本地保存。
- 收藏只保存 `articleId` 列表，最近阅读只保存 `articleId` 和 `viewedAt`；不保存文章全文或搜索关键词。
- 文章详情页支持收藏 / 取消收藏，知识库列表支持“收藏”分类、“我的知识库”摘要和最近阅读入口。
- 阶段 6：历史记录基础回看已完成。
- 历史列表按查询时间倒序直接展示记录，不再显示顶部“本地保存”说明卡片；单条记录删除使用 iOS 左滑操作。
- 历史详情页当前只保留称骨诗文、命格详解和系统分享入口，分享内容与首页查询结果页一致。
- 历史记录收藏、置顶和填入首页重新查询入口已按后续产品优化移除。
- 阶段 7：首页信息架构优化已完成。
- 首页已拆分为定位说明、本地隐私提示、输入卡片、最近历史摘要和知识库入口。
- 首页“最近查询”仅在本机存在历史记录时展示；只读取本机历史记录，不调用模型、不请求网络。
- 阶段 8：本地数据管理入口已完成。
- 设置页新增“本地数据管理”，可查看历史记录、知识库收藏、最近阅读和首次使用说明状态。
- 支持清理历史记录、知识库收藏、知识库最近阅读、首次使用说明状态和全部本地用户数据。
- 每个清理操作均需要确认，只影响当前设备，不删除内置知识库、称骨数据、模型文件或 App 资源。
- 阶段 9：V1.6 自测与下一步决策已完成。
- Debug build：通过。
- Release build：通过。
- 已新增 `docs/V1_6_TestReport.md` 和 `docs/V1_6_NextStepDecision.md`。
- V1.6 Product Feature Polish：Pass。
- TestFlight Upload：Not Now。
- App Store Release：No-Go。
- Local Model Default Enablement：No-Go。
- Continue Product Polish：Go。
- 当前下一阶段建议：V1.7 多设备人工验收与无障碍修复。

## 当前硬边界

- 不接服务端
- 不做登录
- 不接在线 AI
- 不加分析或追踪
- 不做付费订阅
- 不做模型下载
- V1.8 范围内允许按设备评分默认启用本地 AI 润色
- 不把本地模型输出作为命理结论
- 不把本地模型润色结果写入历史记录
- 不做 TestFlight 上传
- 不准备 App Store 上架

## 已知非阻断问题

- V1.8 阶段 3 检查中未发现旧 Debug-only `Embed llama.xcframework` run script phase 残留。
- 构建日志仍有既有 `Metadata extraction skipped. No AppIntents.framework dependency found.` warning。
- 构建日志仍有既有 `IDERunDestination` 和 `JoJoBuildVersion does not exist` 环境提示。
- 这些不是当前功能阻塞项。
- 本地模型后台 preload 延迟执行；如果用户过快进入结果页，可能先回退模板，这是体验风险但不阻断主流程。
- Release Simulator `.app` 约 `502M`，包体风险高，真实 Archive / IPA / App Store 分发体积待记录。
- Qwen2.5 GGUF、Qwen base 和 llama.cpp license / notice 已由用户人工确认通过；当前剩余上线前重点转为 signing / IPA export / App Store Connect / final release checklist。

## 当前工作建议

后续继续阶段化推进：

1. 先写 docs 规划
2. 再做小范围实现
3. 每阶段跑 Debug / Release build
4. 每阶段检查模型文件和 framework 是否进入仓库
5. 当前结果页已临时关闭本地润色展示；`makeDefaultRefiner()` 当前应返回 `TemplateTextRefiner()`，后续如重新接入更好模型再更新默认路径。

当前建议下一步：

- V1.8 阶段 9：Distribution signing / IPA export / App Store Connect 前最终复核。
- 复测 iPhone 17 Pro Max 生产内置模型路径。
- 复测 iPhone 12 mini 生产内置模型禁用 / fallback 路径。
- 记录 Archive / IPA / App Store 分发体积。
- License / notice 人工最终留档已完成。
- 仍不上传 TestFlight。
- 仍不准备 App Store 上架。
- 仍不接服务端、在线 AI、模型下载、RAG、开放聊天、流式 UI 或付费订阅。

## V1.8 阶段 5 上线前材料修复状态

- 已新增 `DestinyScope/Resources/PrivacyInfo.xcprivacy`。
- 已新增 `docs/V1_8_AppStoreConnectDraft.md`。
- 已新增 `docs/V1_8_PrivacyNutritionLabelDraft.md`。
- 已新增 `docs/V1_8_AppReviewNotesFinalDraft.md`。
- 已新增 `docs/V1_8_ScreenshotAndCopyPlan.md`。
- 已新增 `docs/V1_8_LicenseNoticeFinalChecklist.md`。
- 已新增 `docs/V1_8_PreLaunchMaterialsReport.md`。
- 已更新 `docs/AppStoreMetadata.md`、`docs/AppReviewNotes.md`、`docs/ScreenshotPlan.md`。
- 已更新 App 内 `PrivacyPolicyView`、`DisclaimerView`、`OpenSourceLicensesView` 和 `OpenSourceLicenseItem`。
- 已同步 `docs/privacy/privacy.md` 与 `docs/privacy/index.html`。
- `PrivacyInfo.xcprivacy` 当前声明 UserDefaults / CA92.1 与 FileTimestamp / C617.1，不收集数据，不追踪。
- 当前仍不上传 TestFlight。
- 当前仍不直接上传 App Store。
- 下一阶段建议：V1.8 阶段 6，Archive / App Store Connect 准备前最终检查。

## V1.8 阶段 7 License / Notice 人工复核与分发硬化状态

- 已创建 `docs/legal_evidence/` 证据目录结构。
- 已保存 Qwen2.5-0.5B-Instruct README / LICENSE / HF API metadata。
- 已保存 Qwen2.5-0.5B-Instruct-GGUF README / LICENSE / HF API metadata。
- 已保存 llama.cpp README / LICENSE。
- 已新增 `docs/legal_evidence/LOCAL_MODEL_DISTRIBUTION_RECORD.md`。
- 已新增 `docs/V1_8_LicenseNoticeHumanReview.md`。
- 已新增 `docs/V1_8_DistributionHardeningReport.md`。
- 已更新 `docs/V1_8_LicenseNoticeFinalChecklist.md`。
- 已更新 `docs/V1_8_PreLaunchMaterialsReport.md`、`docs/AppStoreChecklist.md`、`docs/TestFlightChecklist.md`。
- 本阶段未修改 Swift、业务逻辑、本地模型运行逻辑、Xcode 工程配置、签名、Bundle ID、Version 或 Build。
- 本阶段未下载 `.gguf`、`.bin`、`.safetensors`、`.mlmodel`、`.mlmodelc` 或 `.xcframework` 到 `docs/legal_evidence`。
- Qwen base、Qwen GGUF、bundled GGUF、llama.cpp 和 `llama.xcframework` 分发 license 状态为 Pass。
- 当前仍不进入 App Store Connect。
- 当前仍不上传 TestFlight。
- 当前待完成事项：分发签名、IPA export、IPA 体积记录、隐私 URL 公网确认、截图和 App Store Connect 字段最终复核。

## V1.8 License / Notice 人工确认状态更新

- 用户已人工确认 Qwen2.5-0.5B-Instruct license 分发无问题。
- 用户已人工确认 Qwen2.5-0.5B-Instruct-GGUF / `qwen2.5-0.5b-instruct-q4_k_m.gguf` App 内分发无问题。
- 用户已人工确认 llama.cpp / `llama.xcframework` 分发无问题。
- 用户已人工确认 App 内开源许可页面列出的 Qwen / GGUF / llama.cpp / ggml-GGUF attribution 可接受。
- Qwen GGUF 和 llama.cpp 分发 license 状态为 Pass。
- 当前剩余上线前重点：Distribution signing、IPA export、App Store Connect、final release checklist。

## V1.8 阶段 8 用户可见文案清理状态

- 已新增 `docs/V1_8_UserFacingCopyCleanupReport.md`。
- 已清理 App 内 About / Settings / Open Source Licenses / Privacy Policy 中的上线前内部状态文案。
- `OpenSourceLicenseItem` 已从 review / distribution status 展示字段调整为正式 license 信息字段。
- Open Source Licenses 页面当前展示名称、来源、License、用途、Copyright / Notice 和说明。
- `docs/privacy/privacy.md` 与 `docs/privacy/index.html` 已同步 V1.8 正式隐私口径。
- `docs/AppStoreMetadata.md`、`docs/AppReviewNotes.md`、`docs/ScreenshotPlan.md` 和 `docs/V1_8_AppStoreConnectDraft.md` 已同步去除生产候选口径。
- Release 用户可见 Swift 页面不应展示草案、待确认、Risk、Blocker、生产候选等内部状态词。
- `SettingsView` 的 Debug-only 本地模型状态入口仍保留在 `#if DEBUG` 内。
- 本阶段未修改业务逻辑、本地模型运行逻辑、设备评分、首页、结果页、历史记录、Xcode 工程配置、签名、Bundle ID、Version、Build、模型文件或 framework。
- 当前剩余上线前重点：Distribution signing、IPA export、隐私 URL 公网确认、截图和 App Store Connect final release checklist。

## 结果页命格详解重构状态

- 结果页结构已调整为：命格、称骨诗、命格详解、免责声明；系统分享入口收敛到 titlebar。
- 原独立的命格洞察、命理师解读、命理问答卡片已从结果页 UI 移除，相关模型和模板逻辑仍保留用于兜底和分享。
- `命格详解` 卡片副标题为 `基于称骨结果的传统文化解读`。
- 主要内容来自 `DestinyScope/Resources/Readings/life_weight_readings.json`，按首页选择的 `male` / `female` 读取；缺失时 fallback `general`；仍缺失时 fallback 到现有本地模板内容。
- `keywords` 字段在卡片顶部以标签样式展示。
- `original_poem`、`original_note`、`rewrite_notes` 不在前端展示。
- 当前阶段结果页不展示本地润色版或本地润色卡片，不自动调用本地模型。
- `TextRefinerFactory.makeDefaultRefiner()` 已恢复为 `TemplateTextRefiner()`。
- 未删除模型文件、未删除 `llama.xcframework`，未修改底层本地模型运行逻辑。
