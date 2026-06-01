# DestinyScope V1.5 Roadmap

## V1.5 阶段 1：产品体验优化目标与路线冻结

阶段目标：

- 冻结 V1.5 产品体验优化目标、阶段路线、质量门槛和优先级。
- 明确 V1.5 不上传 TestFlight、不准备 App Store 上架、不默认启用本地模型。

允许修改范围：

- `docs/V1_5_ProductExperiencePlan.md`
- `docs/V1_5_Roadmap.md`
- `docs/V1_5_UXAuditPlan.md`
- `docs/V1_5_QualityGate.md`
- `docs/AppStoreChecklist.md`
- `docs/TestFlightChecklist.md`

不允许做的事：

- 不改 Swift 代码、UI、工程配置、资源、CSV、JSON、依赖或模型文件。
- 不改变默认输出路径。

验收标准：

- V1.5 文档齐全。
- 阶段 2 明确优先处理 `.gitignore` 的 `Models/` 误伤问题。
- 明确任何阶段都不得默认启用本地模型。
- 明确任何阶段都不得改变 `makeDefaultRefiner()` 默认返回 `TemplateTextRefiner`。

建议 commit message：

- `docs: freeze v1.5 product experience plan`

## V1.5 阶段 2：source-control 与工程卫生修复

状态：已完成。

阶段目标：

- 优先修复 `.gitignore` 中 `Models/` 规则误伤 Swift 源码目录的问题。
- 确保 `DestinyScope/Domain/Models/*.swift` 可以被 git 跟踪。
- 确保模型文件和本地模型目录仍被忽略。

允许修改范围：

- `.gitignore`
- 必要的 Docs checklist
- 如只为 source-control 验证，可不改 Swift 源码

不允许做的事：

- 不改业务逻辑。
- 不提交模型文件、`llama.xcframework` 或 llama.cpp 源码。
- 不新增依赖。

验收标准：

- `git check-ignore -v DestinyScope/Domain/Models/OpenSourceLicenseItem.swift` 不再命中误伤规则。
- `OpenSourceLicenseItem.swift` 可被 git 跟踪。
- `LocalModels/`、`*.gguf`、`*.xcframework` 等仍被忽略。
- Debug / Release 构建通过。

完成记录：

- 已将 `.gitignore` 中宽泛的 `Models/` / `LocalModels/` 收窄为仓库根目录规则 `/Models/` / `/LocalModels/`。
- 已保留 `.gguf`、`.bin`、`.safetensors`、`.mlmodel`、`.mlmodelc`、`.xcframework` 等模型和 framework 文件忽略规则。
- 已补充 `DestinyScope/LocalModels/` 忽略规则。
- `DestinyScope/Domain/Models/OpenSourceLicenseItem.swift` 不再被忽略，并已加入 git 索引。
- 已新增 `docs/V1_5_SourceControlAudit.md` 记录本阶段审计和验证结果。
- Debug / Release 模拟器构建通过。

下一阶段：

- V1.5 阶段 3：UI / UX 全量审计。

建议 commit message：

- `chore: fix gitignore model source tracking`

## V1.5 阶段 3：UI / UX 全量审计

状态：已完成。

阶段目标：

- 按页面完成 UI / UX 审计，输出问题、优先级、建议和风险。
- 暂不修改 UI。

允许修改范围：

- `docs/V1_5_UXAuditReport.md`
- `docs/V1_5_UXAuditPlan.md`
- checklist 文档

不允许做的事：

- 不改 UI。
- 不新增功能。
- 不默认启用本地模型。

验收标准：

- 首页、结果页、知识库、历史、设置、Legal、本地模型实验入口均完成审计。
- 每个问题都有 P0 / P1 / P2 优先级。

完成记录：

- 已新增 `docs/V1_5_PageInventory.md`，记录当前页面清单、职责、默认路径 / 实验路径和优化建议。
- 已新增 `docs/V1_5_UXAuditReport.md`，覆盖根导航、首页、结果页、命理问答、本地模型实验、知识库、历史、设置、Legal 和 DesignSystem。
- 已新增 `docs/V1_5_UXIssueBacklog.md`，记录 30 项 UX issue，并映射到后续阶段。
- 本阶段未修改 Swift、UI、工程配置、资源、CSV、JSON、依赖或模型文件。

后续阶段重点微调：

- 阶段 4 优先处理结果页长滚动、权重明细、标签换行、命理问答占位和本地润色预览卡片简化。
- 阶段 5 优先处理知识库分类筛选，再评估搜索。
- 阶段 6 优先处理历史记录详情、本地保存说明和清空确认。
- 阶段 7 优先处理设置 / Legal 长文目录、实验入口分组和开源许可摘要。
- 阶段 8 优先处理小屏、深色模式、Dynamic Type 和 VoiceOver。

下一阶段：

- V1.5 阶段 4：结果页阅读体验优化。

建议 commit message：

- `docs: add v1.5 ux audit report`

## V1.5 阶段 4：结果页阅读体验优化

状态：已完成。

阶段目标：

- 优化结果页信息层级、长文本阅读、区块顺序和小屏展示。
- 保留原始结果、诗文、权重、解读、洞察和问答。

允许修改范围：

- 结果页相关 SwiftUI 文件。
- UI components 的小范围复用优化。
- checklist 文档。

不允许做的事：

- 不改称骨计算规则。
- 不改 `LifeWeightResult` 结论生成。
- 不自动替换结果页文本。
- 不让本地模型生成命理结论。
- 不改变 `makeDefaultRefiner()`。

验收标准：

- 默认结果页内容完整。
- 长结果页仍可滚动。
- 小屏不明显截断。
- 本地润色预览仍只在受控条件下展示。

完成记录：

- 已新增 `ResultSummaryCard`，将命格标题、农历生日、出生时辰、总重量和短提示作为顶部摘要。
- 已将称骨诗文独立为结果页卡片，原始诗文文案不变。
- 已新增 `WeightBreakdownCard`，用两列紧凑卡片展示年 / 月 / 日 / 时权重。
- 已新增 `InsightTagsView`，用 adaptive grid 展示命格标签，改善小屏换行。
- 已新增 `InterpretationCard`，将五类解读放入同一张卡，并使用轻量 `DisclosureGroup` 降低长文压迫感。
- `FortuneQuestionView` 逻辑保持不变。
- `LocalRefiningPreviewCard` 仍靠后展示，展示条件、调用逻辑、失败回退和历史写入边界均未改变。
- 未修改任何命理计算逻辑、数据模型含义、历史记录结构或默认 TextRefiner。
- Debug / Release 模拟器构建通过。

仍需人工检查：

- 小屏 iPhone 的两列权重卡片、标签 grid、DisclosureGroup 是否拥挤。
- 深色模式下暗金 / 朱砂对比度。
- Dynamic Type 下结果页长标题、按钮和折叠区是否稳定。

下一阶段：

- V1.5 阶段 5：知识库浏览体验优化。

建议 commit message：

- `ui: improve result page readability`

## V1.5 阶段 5：知识库浏览体验优化

状态：已完成。

阶段目标：

- 优化知识库列表和详情页的浏览体验。
- 可按优先级考虑分类筛选或搜索。

允许修改范围：

- Knowledge UI。
- 必要的本地 view state。
- checklist 文档。

不允许做的事：

- 不改 `knowledge_articles.json` 内容，除非发现明确数据错误并单独说明。
- 不接服务端、CMS、远程搜索或 RAG。

验收标准：

- 29 篇知识库可正常加载。
- 分类、摘要、标签、source/version 展示清晰。
- 空状态和错误状态友好。

完成记录：

- 已新增 `KnowledgeArticleFilter`，在本地数组中完成分类、计数和搜索过滤，不请求网络。
- 已新增 `KnowledgeCategoryFilterView`，基于文章 `category` 动态生成分类 chips，第一个分类为“全部”，并显示每类文章数量。
- 已新增 `KnowledgeArticleRowView`，列表项展示 category、title、summary 和最多 3 个 tags，弱化 source/version，提升扫读效率。
- 已新增 `KnowledgeTagFlowView`，用于列表和详情页 tags 换行展示。
- `KnowledgeListView` 已接入本地搜索，搜索范围覆盖 title、summary、category、tags 和 body，并在当前分类内搜索。
- `KnowledgeDetailView` 已拆分为标题摘要、正文和元信息卡片；正文按换行或句组拆分为段落，source/version 置于底部弱化区域。
- 未修改 `knowledge_articles.json` 内容。
- 未修改 `KnowledgeRepository` 读取逻辑。
- Debug / Release 模拟器构建通过。

仍需人工检查：

- 小屏 iPhone 上分类横向滚动、搜索框和 tag chip 是否拥挤。
- 深色模式下 category / tag chip 对比度。
- 长 source URL 在详情页底部的换行可读性。

下一阶段：

- V1.5 阶段 6：历史记录体验优化。

建议 commit message：

- `ui: improve knowledge browsing experience`

## V1.5 阶段 6：历史记录体验优化

状态：已完成。

阶段目标：

- 优化历史记录列表、删除、清空和本地保存说明。
- 可评估历史记录详情页。

允许修改范围：

- History UI。
- 必要的轻量模型展示适配。
- checklist 文档。

不允许做的事：

- 不上传历史记录。
- 不接 iCloud、账号或同步。
- 不保存本地模型润色结果，除非后续单独设计并更新隐私说明。

验收标准：

- 历史记录新增、删除、清空可靠。
- 用户能理解历史记录仅本地保存。
- 最多 50 条策略不变。

完成记录：

- 已新增 `HistoryLocalNoticeView`，在历史列表、空状态和详情页明确说明当前版本历史记录仅保存在本设备，不上传、不同步，也不会用于在线服务。
- 已新增 `HistoryEmptyStateView`，空状态说明完成一次查询后会以轻量记录保存在本机。
- 已新增 `HistoryRecordRowView`，列表卡片展示命格标题、创建时间、出生日期和时辰、农历生日、总重量和最多 3 个 tags，不再在列表里展示长诗文。
- 已新增 `HistoryDetailView`，点击历史记录可进入轻量详情页，展示已保存字段：标题、查询时间、出生信息、农历生日、总重量、称骨诗文、tags 和本地保存说明。
- 详情页不重新调用 `LifeWeightEngine`、`TemplateFortuneInterpreter`、`LifeWeightInsightGenerator` 或本地模型。
- 删除单条和清空全部均增加确认弹窗，取消不会删除。
- 已为删除按钮增加基础 accessibility label / hint。
- 未修改历史记录存储字段、保存时机、最多 50 条策略或本地模型路径。
- Debug / Release 模拟器构建通过。

仍需人工检查：

- 小屏 iPhone 上删除按钮和列表卡片是否拥挤。
- 深色模式下本地保存说明、tag chip 和 destructive 按钮对比度。
- Dynamic Type / VoiceOver 对历史列表和确认弹窗的表现。

下一阶段：

- V1.5 阶段 7：设置 / 关于 / Legal / 开源许可体验优化。

建议 commit message：

- `ui: improve local history experience`

## V1.5 阶段 7：设置 / 关于 / Legal / 开源许可体验优化

状态：已完成。

阶段目标：

- 优化设置、关于、隐私政策、免责声明、开源许可的阅读和入口层级。
- 确认本地模型实验入口不会误导用户。

允许修改范围：

- Settings / About / Legal UI。
- GitHub Pages 隐私页仅在确有必要时同步。
- checklist 文档。

不允许做的事：

- 不改 App Store 元数据生产文案。
- 不夸大本地模型能力。
- 不新增外链打开或网络请求。

验收标准：

- 隐私政策、免责声明、开源许可均可打开。
- 文案不包含高风险营销词。
- 本地模型实验仍默认关闭。

完成记录：

- 已新增 `SettingsSectionCard`，设置页按“应用信息”“隐私与安全”“实验功能”分区展示入口。
- `SettingsView` 标题调整为“设置”，普通 Legal 入口和 Debug 实验入口不再混排。
- `AboutView` 已拆分为 App 定位、当前能力、使用边界和法律与隐私入口，减少长段落堆叠。
- 已新增 `LegalSummaryCard`、`LegalSectionCard`、`LegalInfoRow`，统一 Legal 长文的摘要、分区和信息行样式。
- `PrivacyPolicyView` 已按账号与登录、出生信息、本地历史记录、本地模型实验、网络与服务端、系统权限、广告分析与追踪、本地资源、未来版本和联系方式分区。
- `DisclaimerView` 已按使用边界、传统文化、自我探索、非专业建议、健康、财务、婚恋、本地模型润色和重大决策分区。
- `OpenSourceLicensesView` 已增加顶部摘要，每个 license item 使用卡片展示 name、license、source URL 和说明；URL 仍只作为文本显示，不打开外链。
- `OpenSourceLicenseItem` 仅新增展示用 computed 属性 `sourceDisplayText`，未改变存储含义。
- 本地模型实验逻辑、默认输出路径、`makeDefaultRefiner()` 均未改变。
- Debug / Release 模拟器构建通过。

仍需人工检查：

- 深色模式下 Legal 摘要卡、长段落、source URL 和分区标题的对比度。
- Dynamic Type 下长标题、邮箱、URL 是否换行稳定。
- VoiceOver 对设置入口、Legal 分区和开源许可信息的朗读顺序。

下一阶段：

- V1.5 阶段 8：可访问性、深色模式、小屏适配。

建议 commit message：

- `ui: refine settings and legal pages`

## V1.5 阶段 8：可访问性、深色模式、小屏适配

状态：

- 暂未执行 Swift 实现。本阶段仍作为后续代码优化阶段保留。
- V1.5 阶段 9 已先完成可访问性、深色模式、小屏适配及 QA 检查规划，后续若进入代码优化，应以阶段 9 输出的 `V1_5_AccessibilityDarkModeSmallScreenPlan.md`、`V1_5_QAChecklist.md` 和 `V1_5_DeviceTestMatrix.md` 为准。

阶段目标：

- 检查并优化 Dynamic Type、VoiceOver 标签、深色模式、小屏 iPhone 和 iPad 适配。

允许修改范围：

- SwiftUI 页面和组件样式。
- 必要的 accessibility label / hint。
- checklist 文档。

不允许做的事：

- 不重做整体 UI 架构。
- 不新增高风险功能。

验收标准：

- 深色模式基础可读。
- 小屏不明显截断。
- 长文案不遮挡。
- 核心按钮和入口可被 VoiceOver 理解。

建议 commit message：

- `ui: improve accessibility and responsive layout`

## V1.5 阶段 9：可访问性、深色模式、小屏适配及 QA 检查规划

状态：

- 已完成规划。
- 已新增 `docs/V1_5_AccessibilityDarkModeSmallScreenPlan.md`。
- 已新增 `docs/V1_5_QAChecklist.md`。
- 已新增 `docs/V1_5_DeviceTestMatrix.md`。
- 本阶段只修改文档，未修改 Swift 代码、工程配置、资源、CSV、JSON、依赖或模型文件。

阶段目标：

- 制定 Accessibility、Dark Mode、小屏适配、Dynamic Type、VoiceOver 和 QA 测试规划。
- 明确页面范围、P0 QA 检查项、设备测试矩阵和本地模型实验路径 QA。
- 为 V1.5 阶段 10 自测与下一步决策准备执行清单。

允许修改范围：

- Docs 文档。

不允许做的事：

- 不修改 Swift 代码。
- 不修改 UI 页面。
- 不修改工程配置、资源、CSV、JSON、依赖或模型文件。
- 不默认启用本地模型。
- 不改变默认输出路径。

验收标准：

- Accessibility 检查范围覆盖首页、结果页、知识库、历史、设置、Legal 和本地模型实验路径。
- Dynamic Type 检查覆盖默认、Large、Extra Large 和 Accessibility Large。
- 深色模式检查覆盖主要页面、Legal 长文、tag / chip / badge 和错误状态。
- 小屏适配检查覆盖 iPhone SE、iPhone mini、标准 iPhone、Pro Max 和 iPad。
- 本地模型实验 QA 保持 Release 隐藏、默认关闭、失败回退、不写历史记录。

仍需后续执行：

- 按 `docs/V1_5_QAChecklist.md` 做人工 QA。
- 按 `docs/V1_5_DeviceTestMatrix.md` 做设备覆盖。
- 截图规划和产品文案复查可作为 V1.5 阶段 10 或后续上架资源确认的一部分继续处理。

下一阶段：

- V1.5 阶段 10：V1.5 自测与下一步决策。

建议 commit message：

- `docs: add v1.5 accessibility and qa plan`

## V1.5 阶段 10：V1.5 自测与下一步决策

阶段目标：

- 完成 V1.5 自测报告。
- 判断下一步是继续产品体验优化、恢复 TestFlight 准备，还是进入上架资源确认。

允许修改范围：

- `docs/V1_5_TestReport.md`
- `docs/V1_5_Decision.md`
- checklist 文档
- 明确小 bug 可最小修复并说明原因

不允许做的事：

- 不上传 TestFlight。
- 不创建 App Store Connect 记录。
- 不改 Bundle ID / Signing / Team / Version / Build，除非只是检查并记录。

验收标准：

- Debug / Release 构建通过。
- 默认主流程通过。
- 本地模型实验路径受控。
- source-control 风险已关闭。
- 下一步决策明确。

建议 commit message：

- `docs: add v1.5 test report and decision`
