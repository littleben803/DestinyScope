# DestinyScope V1.7 Accessibility Issue Backlog

| id | page | issue | priority | category | reproduction | suggestedFix | targetStage | status |
|---|---|---|---|---|---|---|---|---|
| A11Y-001 | Onboarding | Dynamic Type 下页面按钮是否截断待验证 | P1 | Dynamic Type | 在 Accessibility Large 下打开首次使用说明 | 如截断，调整按钮布局或允许垂直堆叠 | V1.7 阶段 4 | pending |
| A11Y-002 | HomeView | iPhone SE / mini 上首页卡片是否过长、查询按钮是否容易找到待验证 | P1 | Small Screen | 小屏打开首页并滚动到输入区 | 如拥挤，压缩辅助卡片或调整间距 | V1.7 阶段 3/4 | pending |
| A11Y-003 | HomeView | DatePicker / Picker 在大字号下是否可操作待验证 | P1 | Dynamic Type | Accessibility Large 下选择出生日期和时辰 | 如不可操作，拆分输入区或增加可滚动空间 | V1.7 阶段 4 | pending |
| A11Y-004 | DestinyResultView | 权重明细、标签和折叠区在小屏是否溢出待验证 | P1 | Small Screen | iPhone SE / mini 打开结果页 | 如溢出，调整 grid / tag wrapping | V1.7 阶段 3/4 | pending |
| A11Y-005 | ResultTextShareCard | 复制 / 分享按钮 VoiceOver label / hint 是否清楚待验证 | P1 | VoiceOver | VoiceOver 下聚焦复制和分享按钮 | 补充或调整 accessibilityLabel / hint | V1.7 阶段 3 | pending |
| A11Y-006 | LocalRefiningPreviewCard | 本地润色预览是否会被误解为默认结论待验证 | P0 | Local Model Boundary | 开启实验路径后查看结果页 | 如文案不清，强化“预览、手动、只润色、不生成结论” | V1.7 阶段 3 | pending |
| A11Y-007 | KnowledgeListView | 分类 chips 和搜索在小屏 / 大字号下是否可用待验证 | P1 | Small Screen | 小屏下切换分类和搜索 | 如不可用，调整横向滚动和搜索框布局 | V1.7 阶段 4 | pending |
| A11Y-008 | KnowledgeDetailView | tags 和 source URL 是否撑破布局待验证 | P1 | Long Text | 打开含长 source 的文章详情 | 增加换行策略或弱化元信息布局 | V1.7 阶段 5 | pending |
| A11Y-009 | HistoryListView | 删除单条和清空全部 confirmation 文案读屏是否清楚待验证 | P0 | Destructive Action | VoiceOver 下触发删除 / 清空 | 如不清楚，补充 label / hint 和确认文案 | V1.7 阶段 3 | pending |
| A11Y-010 | HistoryDetailView | “填入首页重新查询”是否明确不会自动查询待验证 | P1 | Copy / UX | 历史详情点击快速复查 | 如误导，调整按钮文案和 hint | V1.7 阶段 3 | pending |
| A11Y-011 | LocalDataManagementView | 清空全部本地用户数据是否存在误触风险待验证 | P0 | Destructive Action | 进入本地数据管理并触发清空全部 | 如风险高，强化分组、确认和按钮样式 | V1.7 阶段 3 | pending |
| A11Y-012 | SettingsView | Release 是否隐藏本地模型实验入口需持续验证 | P0 | Local Model Boundary | Release build 打开设置页 | 若暴露，修复编译 / 展示条件 | V1.7 阶段 3 | pending |
| A11Y-013 | PrivacyPolicyView | 长文在 VoiceOver 下顺序是否合理待验证 | P1 | VoiceOver / Legal | VoiceOver 朗读隐私政策 | 如顺序混乱，调整 section 层级和 accessibility | V1.7 阶段 5 | pending |
| A11Y-014 | DisclaimerView | 长文在深色模式下可读性待验证 | P1 | Dark Mode / Legal | 深色模式打开免责声明 | 如对比不足，调整文本 / 卡片色值 | V1.7 阶段 5 | pending |
| A11Y-015 | OpenSourceLicensesView | 长 URL 是否换行且不影响读屏待验证 | P1 | Legal / Long Text | 打开开源许可页面 | 如撑破布局，增加 URL wrapping 或分段显示 | V1.7 阶段 5 | pending |
| A11Y-016 | TabView | TabView 读屏顺序和标签是否清楚待验证 | P1 | VoiceOver | VoiceOver 下遍历底部 Tab | 如不清楚，补充 tab accessibility 文案 | V1.7 阶段 3 | pending |

## 使用规则

- P0 问题必须优先修复，不能推迟到 V1.7 结束后。
- P1 问题应在 V1.7 阶段 4 / 5 集中处理。
- P2 问题可记录为后续 polish，不阻断 V1.7 结论。
- 修复完成后将 `status` 改为 `addressed`，并在测试报告中记录验证设备。
