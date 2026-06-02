# DestinyScope V1.7 Roadmap

## V1.7 阶段 1：多设备人工验收与无障碍修复计划

状态：

- 已完成。
- 新增 `docs/V1_7_AccessibilityDeviceQAPlan.md`。
- 新增 `docs/V1_7_DeviceTestMatrix.md`。
- 新增 `docs/V1_7_AccessibilityIssueBacklog.md`。
- 新增 `docs/V1_7_ManualTestTemplate.md`。
- 本阶段只修改 docs，不修改 Swift、工程配置、资源、CSV、JSON、依赖或模型文件。

阶段目标：

- 明确 V1.7 的多设备、VoiceOver、Dynamic Type、深色模式、小屏和长文验收范围。
- 建立人工测试矩阵、问题 backlog 和记录模板。
- 冻结“不上传 TestFlight、不上架、不扩大本地模型路径”的当前策略。

允许修改范围：

- V1.7 规划文档。
- App Store / TestFlight checklist。
- `docs/CODEX_PROJECT_STATE.md`。

不允许做的事：

- 不修改 Swift 代码。
- 不修改 UI 页面。
- 不修改工程配置、资源、CSV、JSON、依赖或模型文件。

验收标准：

- V1.7 目标和边界清晰。
- 多设备测试矩阵覆盖 iPhone SE、mini、标准 iPhone、Pro Max、iPad、Simulator。
- Accessibility / Dynamic Type / Dark Mode / 小屏检查项明确。
- P0 / P1 / P2 风险定义明确。

建议 commit message：

- `docs: plan v1.7 accessibility qa`

下一阶段：

- V1.7 阶段 2：人工验收记录汇总。

## V1.7 阶段 2：人工验收记录汇总

状态：

- 记录框架已完成，并已根据用户人工自测反馈更新验收状态。
- 已新增 `docs/V1_7_ManualTestRecords.md`。
- 已新增 `docs/V1_7_ManualTestSummary.md`。
- 用户反馈 iPhone 17 Pro Max、iPhone 12 mini、VoiceOver、Dynamic Type、深色模式、小屏、iPad、本地模型加载和运行等均已人工自测 OK。
- 当前没有已确认 P0 issue；阶段 3 暂无需要修复的问题，可跳过到阶段 6 回归测试或阶段 7 自测与下一步决策。

阶段目标：

- 基于 `docs/V1_7_ManualTestTemplate.md` 汇总人工测试记录。
- 标记已测设备、未测设备和待复现问题。
- 将问题落入 `docs/V1_7_AccessibilityIssueBacklog.md`。

允许修改范围：

- `docs/V1_7_ManualTestReport.md`，如新增。
- `docs/V1_7_AccessibilityIssueBacklog.md`。
- `docs/V1_7_DeviceTestMatrix.md`。
- checklist 文档。

不允许做的事：

- 不修复代码。
- 不新增产品功能。
- 不上传 TestFlight。

验收标准：

- 至少记录 Simulator 和已有真机测试状态。
- 未覆盖设备明确标记为待人工验证。
- P0 / P1 / P2 初步分类完成。

建议 commit message：

- `docs: summarize v1.7 manual qa findings`

## V1.7 阶段 3：P0 可访问性与小屏修复

状态：

- No-op，已完成修复范围复核。
- 已新增 `docs/V1_7_FixTriageDecision.md`。
- 当前无已确认 P0 issue。
- 本阶段不需要代码修复，不修改 Swift、工程配置、资源、CSV、JSON、依赖或模型文件。

阶段目标：

- 修复阻断主流程、危险误触、读屏无法使用、Release 暴露实验入口等 P0 问题。
- 重点覆盖首页、结果页、历史删除 / 清空、本地数据管理危险操作。

允许修改范围：

- 受影响 SwiftUI 页面和轻量组件。
- checklist 文档。

不允许做的事：

- 不改变称骨计算。
- 不改变默认输出路径。
- 不默认启用本地模型。
- 不新增网络、权限、支付或模型下载。

验收标准：

- P0 问题均关闭或降级。
- Debug / Release 构建通过。
- `makeDefaultRefiner()` 仍返回 `TemplateTextRefiner`。
- Release 不展示本地模型实验入口。

建议 commit message：

- `fix: address p0 accessibility issues`

## V1.7 阶段 4：深色模式与 Dynamic Type 修复

状态：

- Skipped。
- 原因：V1.7 阶段 2 人工验收反馈深色模式和 Dynamic Type 均 OK，阶段 3 复核确认无对应修复项。
- 如后续新增真实问题，再重新打开本阶段。

阶段目标：

- 修复深色模式对比不足、Dynamic Type 截断、固定高度导致内容不可见等 P1 问题。

允许修改范围：

- UI 页面、AppTheme、小组件样式。
- checklist 文档。

不允许做的事：

- 不重做视觉风格。
- 不引入第三方 UI 库。
- 不新增图片资源。

验收标准：

- Default / Large / Extra Large / Accessibility Large 下关键按钮不截断。
- 深色模式下文字、按钮、tag、badge、错误提示可读。
- Debug / Release 构建通过。

建议 commit message：

- `fix: improve dark mode and dynamic type`

## V1.7 阶段 5：Legal 长文与开源许可可读性修复

状态：

- Skipped。
- 原因：V1.7 阶段 2 人工验收反馈 Legal 长文、开源许可、VoiceOver 和深色模式均 OK，阶段 3 复核确认无对应修复项。
- 如后续新增真实问题，再重新打开本阶段。

阶段目标：

- 修复隐私政策、免责声明、开源许可和本地数据管理说明的长文阅读问题。
- 确认长 URL 不撑破布局，VoiceOver 顺序合理。

允许修改范围：

- Legal / Settings 相关 SwiftUI 页面。
- checklist 文档。

不允许做的事：

- 不改变法律含义。
- 不打开外链。
- 不请求网络。
- 不新增本地模型宣传。

验收标准：

- Legal 长文可滚动阅读。
- 长 URL 可换行。
- 读屏顺序清楚。
- 文案仍保持当前隐私和免责声明边界。

建议 commit message：

- `fix: improve legal readability`

当前下一阶段：

- V1.7 阶段 6：首页 / 结果页 / 知识库 / 历史回归测试。
- 如需要节省步骤，也可合并进入 V1.7 阶段 7：V1.7 自测与下一步决策。

## V1.7 阶段 6：首页 / 结果页 / 知识库 / 历史回归测试

状态：

- Merged into V1.7 阶段 7。
- 本轮无单独代码修复项，回归结果随阶段 7 构建检查、静态扫描和人工验收回顾一起记录。

阶段目标：

- 对核心用户路径做回归测试。
- 确认前序修复未破坏首页查询、结果页、知识库、历史、设置和本地数据管理。

允许修改范围：

- 测试报告和 checklist。
- 明确回归 bug 的最小修复。

不允许做的事：

- 不新增功能。
- 不调整算法。
- 不接服务端或在线 AI。

验收标准：

- 首页查询、结果页阅读、知识库筛选搜索收藏、历史收藏置顶复查、本地数据管理均通过人工回归。
- Debug / Release 构建通过。
- 仓库无模型文件或 framework。

建议 commit message：

- `test: add v1.7 regression results`

## V1.7 阶段 7：V1.7 自测与下一步决策

状态：

- 已完成。
- 已新增 `docs/V1_7_TestReport.md`。
- 已新增 `docs/V1_7_NextStepDecision.md`。
- Debug build：通过。
- Release build：通过。
- 仓库内未发现 `.gguf`、`.bin`、`.safetensors`、`.mlmodel`、`.mlmodelc` 或 `.xcframework`。
- `makeDefaultRefiner()` 仍返回 `TemplateTextRefiner()`。
- 当前无 P0 / P1 / P2 issue。
- V1.7 总体完成。

阶段目标：

- 汇总 V1.7 修复和人工验收结果。
- 判断是否继续打磨、恢复 TestFlight 准备，或进入上架素材准备。

允许修改范围：

- `docs/V1_7_TestReport.md`。
- `docs/V1_7_NextStepDecision.md`。
- checklist 和项目状态文档。

不允许做的事：

- 不上传 TestFlight。
- 不创建 App Store Connect 记录。
- 不修改 Bundle ID / Signing / Team / Version / Build，除非只是检查记录。

验收标准：

- 多设备和无障碍状态明确。
- P0 问题关闭。
- 下一步决策明确。

建议 commit message：

- `docs: add v1.7 qa decision`

## V1.7 总结

最终结论：

- V1.7 Accessibility & Multi-device QA：Pass。
- P0 / P1 / P2 Fix Required：No。
- TestFlight Upload：Not Now。
- App Store Release：No-Go。
- Local Model Default Enablement：No-Go。
- Continue Product Polish：Go。

下一步建议：

- V1.8：产品细节继续打磨。
