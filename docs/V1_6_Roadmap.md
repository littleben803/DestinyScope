# DestinyScope V1.6 Roadmap

## V1.6 阶段 1：产品功能打磨目标与路线冻结

阶段目标：

- 明确 V1.6 的功能打磨边界、优先级和阶段拆分。
- 冻结“不上架、不上传 TestFlight、不扩大本地模型生产化”的当前策略。
- 明确新增本地数据类型的隐私边界。

允许修改范围：

- `docs/V1_6_ProductFeaturePlan.md`
- `docs/V1_6_Roadmap.md`
- `docs/V1_6_DataPrivacyPlan.md`
- `docs/V1_6_FeatureBacklog.md`
- checklist 文档

不允许做的事：

- 不修改 Swift 代码。
- 不修改工程配置、资源、CSV、JSON、依赖或模型文件。

验收标准：

- V1.6 P0 / P1 和明确不做事项已记录。
- V1.6 阶段拆分已记录。
- 新增本地数据的隐私原则已记录。

建议 commit message：

- `docs: define v1.6 feature polish plan`

## V1.6 阶段 2：首次使用说明 / Onboarding

状态：

- 已完成。
- 新增 `OnboardingStateStore`，使用 `UserDefaults` 保存 `hasCompletedOnboarding`。
- 新增 `OnboardingPage`、`OnboardingView` 和 `OnboardingPageCard`。
- 首次启动时由 `MainContentView` 通过 `fullScreenCover` 展示。
- 用户点击“开始使用”后标记完成，后续启动不再自动展示。
- 设置页和关于页均提供“使用说明”入口，可再次查看，不重置完成状态。
- 未改默认主流程、命理计算、本地模型实验逻辑或 `makeDefaultRefiner()`。

阶段目标：

- 增加轻量首次使用说明，让新用户理解 App 定位、隐私和使用边界。
- 说明出生信息仅本地处理。
- 说明结果仅供娱乐、自我探索和传统文化学习参考。

允许修改范围：

- SwiftUI onboarding 页面或轻量弹层。
- 本地 `UserDefaults` onboarding seen flag。
- 设置 / 关于页入口，如需要。
- checklist 文档。

不允许做的事：

- 不做账号登录。
- 不接网络。
- 不做营销式落地页。
- 不宣传精准预测或本地模型正式能力。

验收标准：

- 首次打开可看到简短说明。
- 用户可继续进入首页。
- 再次打开不重复打扰。
- 可在设置或关于中重新查看说明。

建议 commit message：

- `feat: add local-first onboarding`

下一阶段：

- V1.6 阶段 3：常用出生资料 / 本地 Profile。

## V1.6 阶段 3：常用出生资料 / 本地 Profile

状态：

- 已完成。
- 新增 `SavedBirthProfile`，字段包括 `id`、`displayName`、`birthDate`、`hour`、`createdAt`、`updatedAt`。
- 新增 `SavedBirthProfileStore`，使用 Application Support 下 `DestinyScope/saved_birth_profiles.json` 保存，最多保留 20 条。
- 首页新增“常用资料”区域，可保存当前出生日期和时辰，也可选择资料填入输入。
- 选择常用资料只填入首页输入，不自动查询、不保存历史、不重新计算。
- 设置页新增“常用出生资料”管理入口，可查看、删除单条和清空全部。
- App 内隐私政策和 GitHub Pages 隐私页已补充常用出生资料仅本地保存、不上传、不同步、可删除说明。
- 未改命理计算、历史记录保存逻辑、本地模型实验路径或 `makeDefaultRefiner()`。

阶段目标：

- 设计并实现本地常用出生资料，用于快速复用输入。
- 明确出生资料仅保存在设备端，可删除。

允许修改范围：

- 新增本地 Profile model。
- 新增本地 Profile store。
- 首页输入复用入口。
- 本地数据隐私说明。
- checklist 文档。

不允许做的事：

- 不做登录。
- 不做 iCloud / CloudKit 同步。
- 不上传出生资料。
- 不把 Profile 接入服务端。

验收标准：

- 可保存常用出生日期和时辰。
- 可从首页选择常用资料填充输入。
- 可删除本地 Profile。
- Profile 数据只本地保存。

建议 commit message：

- `feat: add local birth profiles`

下一阶段：

- V1.6 阶段 4：结果页复制与纯文本分享文案。

## V1.6 阶段 4：结果页复制与纯文本分享文案

阶段目标：

- 提供结果摘要复制能力。
- 准备纯文本分享文案，不做图片分享。
- 分享文案保持安全、克制、参考性。

允许修改范围：

- 结果页 UI。
- 分享文案 builder。
- 剪贴板或系统分享 sheet，如仅本地文本。
- checklist 文档。

不允许做的事：

- 不做图片分享。
- 不生成营销海报。
- 不上传结果。
- 不包含确定性预测或高风险承诺。

验收标准：

- 可复制结果摘要。
- 文案包含标题、总重量、短解读和安全提示。
- 不包含出生资料的过度细节，除非用户明确操作。
- 文案不包含精准预测、改命、化解、必然发财等表达。

建议 commit message：

- `feat: add result text copy`

## V1.6 阶段 5：知识库收藏与最近阅读

阶段目标：

- 支持收藏知识文章。
- 支持最近阅读列表。
- 全部本地保存。

允许修改范围：

- Knowledge UI。
- 本地收藏 / 最近阅读 store。
- 设置或数据管理入口，如需要。
- checklist 文档。

不允许做的事：

- 不接账号。
- 不同步收藏。
- 不请求网络。
- 不修改知识库 JSON 内容，除非另开阶段。

验收标准：

- 文章详情可收藏 / 取消收藏。
- 知识库列表可查看收藏状态。
- 最近阅读自动记录，数量有限制。
- 可清空收藏或最近阅读。

建议 commit message：

- `feat: add local knowledge favorites`

## V1.6 阶段 6：历史记录收藏 / 置顶 / 快速复查

阶段目标：

- 增强历史记录管理能力。
- 支持收藏或置顶历史记录。
- 支持快速复查或快速重新填充输入。

允许修改范围：

- History UI。
- HistoryRecord 展示或本地附加状态。
- 首页复用入口，如需要。
- checklist 文档。

不允许做的事：

- 不重新计算历史记录详情。
- 不把本地模型润色结果写入历史。
- 不上传历史。
- 不同步历史。

验收标准：

- 可标记收藏 / 置顶。
- 收藏 / 置顶仅影响本地排序或过滤。
- 可从历史快速复用出生日期和时辰。
- 不改变历史记录原始字段含义。

建议 commit message：

- `feat: improve local history reuse`

## V1.6 阶段 7：首页信息架构优化

阶段目标：

- 优化首页结构，让输入、常用资料、最近记录、隐私提示更清晰。
- 降低首次使用理解成本。

允许修改范围：

- HomeView。
- 首页组件。
- 本地 Profile / 最近历史入口。
- checklist 文档。

不允许做的事：

- 不做营销 landing page。
- 不接网络。
- 不加入本地模型默认入口。

验收标准：

- 首页核心输入仍是第一优先级。
- 常用资料或最近记录不喧宾夺主。
- 隐私提示清楚但不打扰。
- 小屏不拥挤。

建议 commit message：

- `ui: refine home information architecture`

## V1.6 阶段 8：本地数据管理入口

阶段目标：

- 提供统一入口管理本地数据。
- 覆盖历史记录、收藏、最近阅读、Profile 和 onboarding 状态。

允许修改范围：

- Settings / Data Management 页面。
- 本地 store 清理方法。
- Privacy copy。
- checklist 文档。

不允许做的事：

- 不做云端删除。
- 不做账号注销。
- 不做远程数据说明。
- 不接网络。

验收标准：

- 用户能看到当前版本保存了哪些本地数据。
- 用户能清空历史、收藏、最近阅读、Profile。
- 删除前有确认。
- 文案说明只影响本设备。

建议 commit message：

- `feat: add local data management`

## V1.6 阶段 9：V1.6 自测与下一步决策

阶段目标：

- 完成 V1.6 自测报告。
- 判断是否继续产品功能打磨、进入可访问性多设备验收，或恢复 TestFlight / 上架准备。

允许修改范围：

- `docs/V1_6_TestReport.md`
- `docs/V1_6_Decision.md`
- checklist 文档
- 明确小 bug 可最小修复并说明原因

不允许做的事：

- 不上传 TestFlight。
- 不创建 App Store Connect 记录。
- 不改 Bundle ID / Signing / Team / Version / Build，除非只是检查并记录。

验收标准：

- Debug / Release 构建通过。
- 默认主流程通过。
- 新增本地数据可删除。
- 本地模型实验路径仍受控。
- 下一步决策明确。

建议 commit message：

- `docs: add v1.6 test report and decision`
