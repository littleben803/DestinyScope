# DestinyScope V1.5 页面清单

## 1. 默认用户路径

| 页面 / 组件 | 文件路径 | 页面职责 | 默认用户路径 | Debug / TestFlight 实验路径 | 隐私 / 合规说明 | V1.5 是否建议优化 |
|---|---|---:|---:|---:|---:|---:|
| 根导航 | `DestinyScope/UI/MainContentView.swift` | TabView 根结构：首页、知识库、历史、关于 | 是 | 否 | 否 | 是 |
| 首页 | `DestinyScope/UI/Home/HomeView.swift` | 出生日期、时辰输入，触发称骨计算，保存本地历史 | 是 | 否 | 是 | 是 |
| 结果页 | `DestinyScope/UI/Result/DestinyResultView.swift` | 展示称骨结果、权重明细、命格洞察、命理问答、模板解读、免责声明 | 是 | 含实验卡片条件展示 | 是 | 是 |
| 命理问答 | `DestinyScope/UI/Result/FortuneQuestionView.swift` | 展示五个预设问题和本地模板回答 | 是 | 否 | 是 | 是 |
| 知识库列表 | `DestinyScope/UI/Knowledge/KnowledgeListView.swift` | 加载并展示 29 篇知识库文章列表 | 是 | 否 | 否 | 是 |
| 知识库详情 | `DestinyScope/UI/Knowledge/KnowledgeDetailView.swift` | 展示文章正文、标签、source/version | 是 | 否 | 有 source 说明 | 是 |
| 历史记录 | `DestinyScope/UI/History/HistoryListView.swift` | 展示本地历史记录，支持删除单条和清空全部 | 是 | 否 | 是 | 是 |
| 设置页 / 关于 Tab | `DestinyScope/UI/Settings/SettingsView.swift` | 设置入口：关于、隐私、免责声明、开源许可、Debug 实验入口 | 是 | Debug 入口 | 是 | 是 |
| 关于页 | `DestinyScope/UI/Settings/AboutView.swift` | App 定位说明，Legal 入口 | 是 | 否 | 是 | 是 |
| 隐私政策 | `DestinyScope/UI/Legal/PrivacyPolicyView.swift` | 当前正式功能、本地历史、本地模型实验、模型下载边界说明 | 是 | 是 | 是 | 是 |
| 免责声明 | `DestinyScope/UI/Legal/DisclaimerView.swift` | 结果参考边界、非专业建议、本地模型润色边界 | 是 | 是 | 是 | 是 |
| 开源许可 | `DestinyScope/UI/Legal/OpenSourceLicensesView.swift` | llama.cpp、ggml/GGUF、Qwen2.5 license / notice 草案 | 是 | 是 | 是 | 是 |

## 2. 本地模型实验路径

| 页面 / 组件 | 文件路径 | 页面职责 | 默认用户路径 | Debug / TestFlight 实验路径 | 隐私 / 合规说明 | V1.5 是否建议优化 |
|---|---|---:|---:|---:|---:|---:|
| 本地润色预览卡片 | `DestinyScope/UI/Components/LocalRefiningPreviewCard.swift` | 结果页底部可选本地润色预览，只在实验条件满足时展示 | 否 | 是 | 是 | 是 |
| 本地模型润色实验设置 | `DestinyScope/UI/Settings/LocalModelExperimentSettingsView.swift` | 实验说明、确认、开关、设备 tier、模型文件状态 | 否 | 是 | 是 | 是 |
| 本地模型 PoC Debug 页 | `DestinyScope/UI/Debug/LocalModelDebugView.swift` | Debug-only 模型加载、TextRefining、安全测试和 benchmark | 否 | Debug-only | 是 | 是 |

## 3. DesignSystem / 组件

| 组件 | 文件路径 | 职责 | 默认用户路径 | Debug / TestFlight 实验路径 | 隐私 / 合规说明 | V1.5 是否建议优化 |
|---|---|---:|---:|---:|---:|---:|
| Theme | `DestinyScope/UI/Theme/AppTheme.swift` | 颜色、间距、圆角、字体 token | 是 | 是 | 否 | 是 |
| 背景 | `DestinyScope/UI/Components/AppBackground.swift` | 统一页面背景 | 是 | 是 | 否 | 低优先级 |
| 卡片 | `DestinyScope/UI/Components/AppCard.swift` | 统一卡片容器 | 是 | 是 | 否 | 是 |
| 主按钮 | `DestinyScope/UI/Components/AppPrimaryButton.swift` | 统一主按钮 | 是 | 是 | 否 | 是 |
| 分区标题 | `DestinyScope/UI/Components/AppSectionHeader.swift` | 统一 section header | 是 | 是 | 否 | 是 |

## 4. 页面关系

- `MainContentView` 是根视图，使用四个 Tab：首页、知识库、历史、关于。
- `HomeView` 成功计算后跳转 `DestinyResultView`。
- `DestinyResultView` 只展示结果，不重新计算；本地润色卡片只在受控实验条件满足时展示。
- `KnowledgeListView` 进入 `KnowledgeDetailView`。
- `SettingsView` 和 `AboutView` 都提供 Legal / 开源许可入口。
- `LocalModelDebugView` 仅在 `#if DEBUG` 下可见，不属于默认用户路径。

## 5. V1.5 优化优先级摘要

P0：

- 结果页信息层级和长文本阅读。
- 知识库 29 篇文章的浏览效率。
- 历史记录本地保存说明和详情能力。
- 本地模型实验入口避免误解。
- Legal / 开源许可长文阅读。
- 小屏、深色模式和 VoiceOver 基础审计。

P1：

- 知识库分类筛选 / 搜索。
- 历史记录详情页。
- 结果页折叠 / 展开。
- 首次打开说明页。

P2：

- 标签视觉优化。
- 截图文案复查。
- 细节动效和空状态润色。
