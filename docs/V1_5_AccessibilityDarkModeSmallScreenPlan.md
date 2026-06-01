# DestinyScope V1.5 Accessibility / Dark Mode / Small Screen Plan

## 1. 阶段定位

本阶段是 V1.5 的可访问性、深色模式、小屏适配专项规划。

本阶段只做检查和实现规划，不直接修改 Swift 代码，不改变默认输出路径，不默认启用本地模型。本地模型润色仍是受控实验路径，普通用户主流程继续使用本地规则引擎和模板系统。

## 2. 检查页面范围

需要覆盖以下页面和组件：

| 页面 / 组件 | 文件或模块 | 检查重点 |
|---|---|---|
| 首页 | `HomeView` | 输入区、DatePicker、时辰选择、查询按钮、错误提示 |
| 结果页 | `DestinyResultView` | 长结果阅读、卡片层级、免责声明、长文滚动 |
| 本地润色预览 | `LocalRefiningPreviewCard` | 实验边界、按钮状态、失败回退提示 |
| 命理问答 | `FortuneQuestionView` | 预设问题按钮、回答区域、可读顺序 |
| 知识库列表 | `KnowledgeListView` | 分类 chips、搜索、空状态 |
| 知识库详情 | `KnowledgeDetailView` | 长文段落、tags、source/version |
| 历史记录列表 | `HistoryListView` | 本地保存说明、记录卡片、删除入口 |
| 历史详情 | `HistoryDetailView` | 轻量记录边界、本地保存说明 |
| 设置页 | `SettingsView` | 入口层级、实验入口隐藏策略 |
| 关于页 | `AboutView` | App 定位、能力摘要、Legal 入口 |
| 隐私政策 | `PrivacyPolicyView` | 长文顺序、摘要、分区 |
| 免责声明 | `DisclaimerView` | 使用边界、非专业建议说明 |
| 开源许可 | `OpenSourceLicensesView` | 长 URL 换行、license item 可读性 |
| 本地模型实验设置 | `LocalModelExperimentSettingsView` | 说明文案、设备 tier、模型状态 |
| 本地模型 Debug | `LocalModelDebugView` | Debug-only、工程化信息、模型导入/测试状态 |

## 3. Accessibility 检查项

P0 检查：

- 关键按钮必须有清晰 `accessibilityLabel`。
- 删除、清空、导入、生成、重新生成等高影响操作必须有 `accessibilityHint`。
- 错误状态必须能被读出，并说明下一步。
- 空状态必须能被读出，不只依赖图形或颜色。
- 本地模型实验说明不得让用户误以为模型参与命理结论。
- Legal 长文应按摘要、分区、正文顺序阅读。
- VoiceOver 焦点顺序应与视觉顺序一致。

重点控件：

- 首页查询按钮。
- 结果页折叠区和命理问答按钮。
- 本地润色预览生成 / 重新生成 / 收起入口。
- 知识库搜索和分类筛选。
- 历史记录删除单条和清空全部。
- 设置页隐私政策、免责声明、开源许可入口。
- 本地模型实验开关、导入 GGUF、检查模型文件、运行 benchmark。

## 4. Dynamic Type 检查项

需要至少检查以下文字大小：

- 默认。
- Large。
- Extra Large。
- Accessibility Large。

检查标准：

- 首页输入区不挤压，DatePicker / Picker 仍可操作。
- 结果页卡片不截断，长标题和按钮可换行。
- 权重明细、tags、chips 不横向溢出。
- 知识库分类 chips 可横向滚动。
- 知识库详情正文和 source URL 不撑破布局。
- 历史记录卡片仍能读出标题、时间、出生信息和总重量。
- Legal 页面完整可滚动，摘要和分区标题不遮挡。
- 本地模型实验设置页说明文案不出现固定高度截断。

## 5. 深色模式检查项

检查维度：

- 背景与卡片层级是否清楚。
- 主文字 / 次文字对比是否足够。
- 朱砂红按钮在深色背景下是否仍可读。
- 暗金色文字、badge、divider 是否过暗。
- 标签 / badge / chip 是否能区分选中和未选中。
- 错误提示、fallback 提示是否明显但不过度刺眼。
- Legal 长文是否阅读疲劳。
- 开源许可长 URL 在深色模式下是否可读。

人工检查页面：

- 首页。
- 结果页。
- 知识库列表和详情。
- 历史记录列表和详情。
- 设置、关于、隐私政策、免责声明、开源许可。
- 本地模型实验设置和 Debug 页面。

## 6. 小屏适配检查项

目标设备：

- iPhone SE。
- iPhone mini。
- 标准 iPhone。
- Pro Max。
- iPad。

检查项：

- TabView 是否拥挤，标签是否明确。
- 首页 DatePicker / Picker 是否可操作。
- 查询按钮是否换行或截断。
- 结果页长文是否完整滚动。
- 权重明细两列是否挤压。
- tags / badge / chip 是否换行或横向滚动。
- 知识库分类 chip 是否横向滚动。
- 历史记录删除入口是否容易误触。
- Legal 页面长 URL 是否换行，不撑破卡片。
- iPad 上内容宽度是否过宽或留白过大。

## 7. 本地模型实验路径 QA

必须保持：

- Release 不展示本地模型实验入口。
- `makeDefaultRefiner()` 仍返回 `TemplateTextRefiner`。
- 实验开关默认关闭。
- 未接受说明不能开启。
- Tier C 不可用。
- unknown 设备默认不可用。
- 模型不存在时不可用或回退。
- 用户手动点击才生成。
- 原始文本始终保留。
- 失败回退本地模板文本。
- 安全检查失败回退。
- 不写历史记录。
- 不上传模型输入输出。

本阶段不验证模型质量，只验证入口受控、文案清楚、回退不破坏主流程。

## 8. 输出与后续

本阶段输出规划文档和 QA checklist。后续若进入实现阶段，应按 P0 优先级处理：

1. VoiceOver 标签和高影响操作 hint。
2. Dynamic Type 下的小屏截断。
3. 深色模式对比度。
4. Legal 长文和长 URL 换行。
5. 本地模型实验路径说明和 fallback 状态可读性。

