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

建议 commit message：

- `docs: add v1.5 ux audit report`

## V1.5 阶段 4：结果页阅读体验优化

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

建议 commit message：

- `ui: improve result page readability`

## V1.5 阶段 5：知识库浏览体验优化

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

建议 commit message：

- `ui: improve knowledge browsing experience`

## V1.5 阶段 6：历史记录体验优化

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

建议 commit message：

- `ui: improve local history experience`

## V1.5 阶段 7：设置 / 关于 / Legal / 开源许可体验优化

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

建议 commit message：

- `ui: refine settings and legal pages`

## V1.5 阶段 8：可访问性、深色模式、小屏适配

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

## V1.5 阶段 9：截图规划和产品文案复查

阶段目标：

- 更新截图规划和产品文案检查清单。
- 确保截图、描述、提示文案不包含高风险承诺。

允许修改范围：

- Docs 文档。
- 如需微调截图相关页面文案，必须小范围且单独说明。

不允许做的事：

- 不生成图片。
- 不上传 App Store Connect。
- 不宣传 AI / 本地模型为正式功能。

验收标准：

- 截图规划覆盖首页、结果、知识库、历史、隐私和免责声明。
- 文案不包含精准预测、改命、化解、必然发财等词。

建议 commit message：

- `docs: refresh screenshot and copy review plan`

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
