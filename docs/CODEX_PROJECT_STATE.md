# DestinyScope 当前项目状态

## 当前方向

当前暂不准备：

- 上传 TestFlight
- 上架 App Store
- 默认启用本地模型
- 将本地模型接入默认结果页
- 增加服务端
- 增加在线 AI
- 增加登录
- 增加支付订阅

当前重点：

- 继续产品功能打磨和多设备人工验收
- 保持默认主流程稳定
- 保持本地优先
- 保持隐私友好
- 保持本地模型实验受控、默认关闭、失败回退

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

V1.7：多设备人工验收与无障碍修复。

候选方向：

- iPhone SE / mini / Pro Max / iPad 多设备验收。
- VoiceOver 焦点顺序和按钮 label / hint 修复。
- Dynamic Type 默认、Large、Extra Large、Accessibility Large 验收。
- 深色模式和小屏布局修复。
- Legal 长文、开源许可长 URL 和本地数据管理页可读性复查。
- 继续保持不上传 TestFlight、不准备 App Store 上架，除非另行决策。

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

当前 V1.6 进度：

- 阶段 1：产品功能打磨目标与路线冻结已完成。
- 阶段 2：首次使用说明 / Onboarding 已完成。
- Onboarding 使用 `UserDefaults` key `hasCompletedOnboarding` 保存完成状态。
- 首次启动自动展示，完成后不再自动展示。
- 设置页和关于页可再次打开使用说明。
- 阶段 3：常用出生资料 / 本地 Profile 已完成。
- 常用出生资料使用 Application Support 下 `DestinyScope/saved_birth_profiles.json` 本地保存，最多 20 条。
- 首页可保存当前出生资料，也可选择常用资料填入输入；不会自动查询或保存历史。
- 设置页可管理常用出生资料，支持删除单条和清空全部。
- 阶段 4：结果页复制与纯文本分享文案已完成。
- 结果页可复制和系统分享纯文本摘要；默认不包含完整出生信息、不保存分享记录、不上传。
- 阶段 5：知识库收藏与最近阅读已完成。
- 知识库收藏和最近阅读使用 Application Support 下 `DestinyScope/knowledge_library_state.json` 本地保存。
- 收藏只保存 `articleId` 列表，最近阅读只保存 `articleId` 和 `viewedAt`；不保存文章全文或搜索关键词。
- 文章详情页支持收藏 / 取消收藏，知识库列表支持“收藏”分类、“我的知识库”摘要和最近阅读入口。
- 阶段 6：历史记录收藏 / 置顶 / 快速复查已完成。
- 历史收藏和置顶使用 Application Support 下 `DestinyScope/history_record_user_state.json` 本地保存，只保存 `HistoryRecord.id` 集合和 `updatedAt`。
- 历史列表按置顶优先展示，历史详情页可收藏、置顶，并可把记录中的出生日期和时辰填回首页输入。
- 快速复查通过内存态 `HomeInputDraft` 传递，不自动查询、不重新计算、不保存新历史。
- 阶段 7：首页信息架构优化已完成。
- 首页已拆分为定位说明、本地隐私提示、历史草稿提示、常用资料、输入卡片、最近历史摘要和知识库入口。
- 常用资料和历史草稿只填入首页输入，不自动查询、不自动保存历史、不重新计算。
- 最近历史摘要只读取本机轻量历史记录，不调用模型、不请求网络。
- 阶段 8：本地数据管理入口已完成。
- 设置页新增“本地数据管理”，可查看历史记录、常用资料、知识库收藏、最近阅读、历史收藏、历史置顶和首次使用说明状态。
- 支持清理历史记录、历史收藏 / 置顶、常用出生资料、知识库收藏、知识库最近阅读、首次使用说明状态和全部本地用户数据。
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
- 不默认启用本地模型
- 不把本地模型输出作为命理结论
- 不把本地模型润色结果写入历史记录
- 不做 TestFlight 上传
- 不准备 App Store 上架

## 已知非阻断问题

- Release 日志可能仍出现 `Embed Debug llama.xcframework` script phase dependency analysis 相关提示。
- 这不是当前功能阻塞项。
- 不要在非工程卫生阶段主动修改 Xcode 工程脚本。

## 当前工作建议

后续继续阶段化推进：

1. 先写 docs 规划
2. 再做小范围实现
3. 每阶段跑 Debug / Release build
4. 每阶段检查模型文件和 framework 是否进入仓库
5. 每阶段确认 `makeDefaultRefiner()` 默认仍是 `TemplateTextRefiner`
