# DestinyScope V1.7 Accessibility Issue Backlog

| id | page | issue | priority | category | reproduction | suggestedFix | targetStage | status |
|---|---|---|---|---|---|---|---|---|
| A11Y-001 | Onboarding | Dynamic Type 下页面按钮是否截断待验证 | P1 | Dynamic Type | 在 Accessibility Large 下打开首次使用说明 | 无需修复，用户反馈 OK | V1.7 阶段 4 | verified-pass |
| A11Y-002 | HomeView | iPhone SE / mini 上首页卡片是否过长、查询按钮是否容易找到待验证 | P1 | Small Screen | 小屏打开首页并滚动到输入区 | 无需修复，用户反馈 OK | V1.7 阶段 3/4 | verified-pass |
| A11Y-003 | HomeView | DatePicker / Picker 在大字号下是否可操作待验证 | P1 | Dynamic Type | Accessibility Large 下选择出生日期和时辰 | 无需修复，用户反馈 OK | V1.7 阶段 4 | verified-pass |
| A11Y-004 | DestinyResultView | 权重明细、标签和折叠区在小屏是否溢出待验证 | P1 | Small Screen | iPhone SE / mini 打开结果页 | 无需修复，用户反馈 OK | V1.7 阶段 3/4 | verified-pass |
| A11Y-005 | ResultTextShareCard | 复制 / 分享按钮 VoiceOver label / hint 是否清楚待验证 | P1 | VoiceOver | VoiceOver 下聚焦复制和分享按钮 | 无需修复，用户反馈 OK | V1.7 阶段 3 | verified-pass |
| A11Y-006 | LocalRefiningPreviewCard | 本地润色预览是否会被误解为默认结论待验证 | P0 | Local Model Boundary | 开启实验路径后查看结果页 | 无需修复，用户反馈 OK | V1.7 阶段 3 | verified-pass |
| A11Y-007 | KnowledgeListView | 分类 chips 和搜索在小屏 / 大字号下是否可用待验证 | P1 | Small Screen | 小屏下切换分类和搜索 | 无需修复，用户反馈 OK | V1.7 阶段 4 | verified-pass |
| A11Y-008 | KnowledgeDetailView | tags 和 source URL 是否撑破布局待验证 | P1 | Long Text | 打开含长 source 的文章详情 | 无需修复，用户反馈 OK | V1.7 阶段 5 | verified-pass |
| A11Y-009 | HistoryListView | 删除单条和清空全部 confirmation 文案读屏是否清楚待验证 | P0 | Destructive Action | VoiceOver 下触发删除 / 清空 | 无需修复，用户反馈 OK | V1.7 阶段 3 | verified-pass |
| A11Y-010 | HistoryDetailView | “填入首页重新查询”是否明确不会自动查询待验证 | P1 | Copy / UX | 历史详情点击快速复查 | 无需修复，用户反馈 OK | V1.7 阶段 3 | verified-pass |
| A11Y-011 | LocalDataManagementView | 清空全部本地用户数据是否存在误触风险待验证 | P0 | Destructive Action | 进入本地数据管理并触发清空全部 | 无需修复，用户反馈 OK | V1.7 阶段 3 | verified-pass |
| A11Y-012 | SettingsView | Release 是否隐藏本地模型实验入口需持续验证 | P0 | Local Model Boundary | Release build 打开设置页 | 无需修复，用户反馈 OK | V1.7 阶段 3 | verified-pass |
| A11Y-013 | PrivacyPolicyView | 长文在 VoiceOver 下顺序是否合理待验证 | P1 | VoiceOver / Legal | VoiceOver 朗读隐私政策 | 无需修复，用户反馈 OK | V1.7 阶段 5 | verified-pass |
| A11Y-014 | DisclaimerView | 长文在深色模式下可读性待验证 | P1 | Dark Mode / Legal | 深色模式打开免责声明 | 无需修复，用户反馈 OK | V1.7 阶段 5 | verified-pass |
| A11Y-015 | OpenSourceLicensesView | 长 URL 是否换行且不影响读屏待验证 | P1 | Legal / Long Text | 打开开源许可页面 | 无需修复，用户反馈 OK | V1.7 阶段 5 | verified-pass |
| A11Y-016 | TabView | TabView 读屏顺序和标签是否清楚待验证 | P1 | VoiceOver | VoiceOver 下遍历底部 Tab | 无需修复，用户反馈 OK | V1.7 阶段 3 | verified-pass |

## 使用规则

- P0 问题必须优先修复，不能推迟到 V1.7 结束后。
- P1 问题应在 V1.7 阶段 4 / 5 集中处理。
- P2 问题可记录为后续 polish，不阻断 V1.7 结论。
- 修复完成后将 `status` 改为 `addressed`，并在测试报告中记录验证设备。

## V1.7 阶段 2 记录状态

- 用户已反馈 iPhone 17 Pro Max、iPhone 12 mini、VoiceOver、Dynamic Type、深色模式、小屏、iPad、本地模型加载和运行等均已人工自测 OK。
- 尚无真实人工测试失败记录，因此未新增已确认 issue。
- 上表所有候选项已按用户反馈标记为 `verified-pass`。
- 当前没有已确认 P0 issue；如后续人工测试发现 P0，必须补充复现步骤、设备、系统版本和截图 / 录屏路径。
