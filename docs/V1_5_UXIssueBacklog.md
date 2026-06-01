# DestinyScope V1.5 UX Issue Backlog

| id | page | issue | priority | status | suggestedFix | requiresCodeChange | risk | targetStage |
|---|---|---|---|---|---|---:|---|---|
| UX-001 | 结果页 | 页面内容过长，结果、洞察、问答、解读、润色预览和免责声明集中在一条长滚动中 | P0 | partially addressed | 已拆分顶部摘要、诗文卡、权重卡、五类解读卡并调整展示顺序；仍需真机检查长页体感 | 是 | 长页压迫感影响主流程理解 | V1.5 阶段 4 |
| UX-002 | 结果页 | 权重明细 HStack 在小屏可能挤压 | P0 | addressed | 已改为 `WeightBreakdownCard` 两列紧凑展示年 / 月 / 日 / 时 | 是 | 小屏截断 | V1.5 阶段 4 |
| UX-003 | 结果页 | tagList 当前不是真正自动换行，标签多时可能拥挤 | P0 | addressed | 已新增 `InsightTagsView`，使用 adaptive grid 改善小屏换行 | 是 | 小屏可读性 | V1.5 阶段 4 |
| UX-004 | 结果页 | 多处 safetyNotice 分散且可能重复 | P1 | partially addressed | 顶部摘要和底部保留短提示，五类解读内保留原 safetyNotice；仍需人工检查重复感 | 是 | 审核边界不能削弱 | V1.5 阶段 4 |
| UX-005 | 命理问答 | 五个问题按钮占用空间较大 | P1 | not addressed | 阶段 4 保持现有逻辑，后续可改为紧凑 chips 或折叠问答区 | 是 | 长页加重 | V1.5 阶段 4 |
| UX-006 | 本地润色预览 | 卡片展示 engine / wasRefined / 耗时等技术字段，TestFlight 用户可能困惑 | P0 | not addressed | 阶段 4 仅保持靠后展示，不改模型调用逻辑；后续阶段 7 做 Debug/TestFlight 信息分层 | 是 | 用户误以为模型参与结论 | V1.5 阶段 7 |
| UX-007 | 本地润色预览 | “使用原始文本”可能被理解为关闭实验或覆盖结果 | P1 | not addressed | 阶段 4 未改 `LocalRefiningPreviewCard` 交互；后续可改为“收起预览”并补充说明 | 是 | 语义误解 | V1.5 阶段 7 |
| UX-008 | 知识库列表 | 29 篇文章缺少分类筛选 | P0 | addressed | 已新增动态分类 chips，按文章 category 去重生成，并显示分类文章数量 | 是 | 浏览效率低 | V1.5 阶段 5 |
| UX-009 | 知识库列表 | 缺少搜索 | P1 | addressed | 已新增本地搜索，覆盖标题、摘要、分类、标签和正文，并在当前分类内过滤 | 是 | 文章增多后发现困难 | V1.5 阶段 5 |
| UX-010 | 知识库列表 | category 只是文本，不够像可扫读标签 | P2 | addressed | 已在列表项中将 category 以弱化 badge 展示 | 是 | 视觉层级一般 | V1.5 阶段 5 |
| UX-011 | 知识库详情 | 正文为单个长 Text，段落层级弱 | P1 | addressed | 已将详情页拆成标题摘要、正文、元信息卡片，并在 UI 层按换行或句组分段显示 | 是 | 长文阅读疲劳 | V1.5 阶段 5 |
| UX-012 | 知识库详情 | 标签单行拼接，小屏可能拥挤 | P1 | addressed | 已新增 `KnowledgeTagFlowView`，详情页标签改为换行 chip 展示 | 是 | 小屏可读性 | V1.5 阶段 5 |
| UX-013 | 历史记录 | 缺少详情页，只能看摘要 | P0 | addressed | 已新增轻量 `HistoryDetailView`，展示已保存的标题、时间、出生信息、农历生日、总重量、诗文、标签和本地说明 | 是 | 历史回看价值不足 | V1.5 阶段 6 |
| UX-014 | 历史记录 | 清空全部缺少二次确认 | P0 | addressed | 已为清空全部增加确认弹窗，取消不会删除 | 是 | 误删风险 | V1.5 阶段 6 |
| UX-015 | 历史记录 | 缺少页面级“仅本地保存”说明 | P0 | addressed | 已新增 `HistoryLocalNoticeView`，列表顶部、空状态和详情页均说明仅本机保存、不上传、不同步、可删除 | 是 | 隐私说明不够明显 | V1.5 阶段 6 |
| UX-016 | 历史记录 | 删除按钮仅图标，VoiceOver 标签可能不足 | P1 | partially addressed | 已为列表删除按钮增加 accessibilityLabel / hint；仍需后续阶段 8 做系统性 VoiceOver 人工检查 | 是 | 可访问性 | V1.5 阶段 8 |
| UX-017 | 设置页 | “关于” Tab 承载设置、Legal 和实验入口，语义略窄 | P1 | partially addressed | `SettingsView` 页面标题已改为“设置”，并分为应用信息、隐私与安全、实验功能；Tab 名称仍待后续统一评估 | 是 | 导航理解成本 | V1.5 阶段 7 |
| UX-018 | 设置页 | Debug 实验入口和普通入口混排 | P1 | addressed | Debug 实验入口已独立放入“实验功能”分区，普通 Legal 入口集中在“隐私与安全”分区 | 是 | 用户误解实验功能 | V1.5 阶段 7 |
| UX-019 | 本地模型实验设置 | 设备、模型、说明、开关信息密度大 | P0 | partially addressed | 设置页入口已弱化为实验功能并明确只做文本润色；实验设置详情页信息密度仍需后续单独优化 | 是 | 用户误解模型能力 | V1.5 阶段 7 |
| UX-020 | 本地模型 Debug | 页面过于工程化，不适合产品化 | P1 | partially addressed | Debug 页仍保持 DEBUG-only，设置页中作为实验功能入口展示；Debug 页本身未产品化 | 是 | 误入 Release 风险 | V1.5 阶段 7 |
| UX-021 | 隐私政策 | 内容完整但长，缺少顶部摘要 / 目录 | P0 | addressed | 已增加 `LegalSummaryCard`，并按账号、出生信息、历史记录、本地模型实验、网络、权限、追踪、未来变更和联系方式分区 | 是 | 隐私理解成本 | V1.5 阶段 7 |
| UX-022 | 免责声明 | 长卡片阅读效率一般 | P1 | addressed | 已增加摘要卡，并按传统文化、使用边界、非专业建议、健康、财务、婚恋、本地润色和重大决策分区 | 是 | 审核边界需保持 | V1.5 阶段 7 |
| UX-023 | 开源许可 | 技术内容对普通用户偏重 | P1 | addressed | 已增加开源许可摘要，license item 改为卡片化展示 name、license、source URL 和说明，强调仍需人工复核 | 是 | 审核 / license 透明度 | V1.5 阶段 7 |
| UX-024 | 首页 | 时辰选择只显示小时，不解释传统时辰 | P1 | not addressed | 增加轻量说明或显示时辰别名，不改计算逻辑 | 是 | 用户理解成本 | V1.5 阶段 8 |
| UX-025 | 首页 | DatePicker / Picker 在小屏和 Dynamic Type 下可能拥挤 | P0 | planned | 已纳入 `V1_5_AccessibilityDarkModeSmallScreenPlan.md` 和 `V1_5_QAChecklist.md`；后续需真机 / 模拟器验证 | 是 | 小屏截断 | V1.5 阶段 9 |
| UX-026 | DesignSystem | `AppPrimaryButton` disabled 状态视觉可能不明显 | P1 | not addressed | 增加 disabled token 或样式 | 是 | 操作反馈不足 | V1.5 阶段 8 |
| UX-027 | DesignSystem | 深色模式下 shadow / 暗金 / 朱砂对比度需人工确认 | P0 | planned | 已纳入深色模式 QA gate，需覆盖背景、卡片、朱砂红、暗金、错误提示和 Legal 长文 | 是 | 深色可读性 | V1.5 阶段 9 |
| UX-028 | 全局 | VoiceOver 标签未系统性补充 | P0 | planned | 已纳入 Accessibility QA gate，重点检查删除、生成、导入、导航、Legal 入口等 label / hint | 是 | 可访问性 | V1.5 阶段 9 |
| UX-029 | 全局 | iPad 留白和卡片宽度未专项优化 | P2 | planned | 已纳入设备测试矩阵，需在 iPad 上检查内容宽度和横竖屏留白 | 是 | iPad 视觉松散 | V1.5 阶段 9 |
| UX-030 | 截图 / 文案 | 截图规划需随 V1.5 页面优化更新 | P2 | deferred | 阶段 9 调整为可访问性 / 适配 / QA 规划；截图和文案复查后续并入阶段 10 或上架资源确认 | 否 | 上架素材质量 | V1.5 阶段 10 |
| UX-031 | 全局 | Dynamic Type 未覆盖默认、Large、Extra Large、Accessibility Large 全量检查 | P0 | planned | 使用 `V1_5_QAChecklist.md` 对首页、结果页、知识库、历史、Legal 和实验页做字体尺寸检查 | 是 | 大字号截断 / 可访问性不足 | V1.5 阶段 9 |
| UX-032 | 结果页 | 长结果页在 VoiceOver 下的分区朗读顺序需要确认 | P0 | planned | 检查顶部摘要、诗文、权重、洞察、解读、问答、润色预览、免责声明的焦点顺序 | 是 | 结果理解困难 | V1.5 阶段 9 |
| UX-033 | 知识库 | 分类 chips 和搜索在 Dynamic Type / 小屏下可能拥挤 | P1 | planned | 检查横向滚动、搜索框高度、无结果状态和 tags 换行 | 是 | 浏览效率下降 | V1.5 阶段 9 |
| UX-034 | 历史记录 | 删除 / 清空确认在 VoiceOver 下需要确认不可恢复提示 | P0 | planned | 检查 confirmationDialog / alert 的 label、hint 和取消路径 | 是 | 误删风险 | V1.5 阶段 9 |
| UX-035 | Legal | 隐私政策、免责声明、开源许可长文在 Accessibility Large 下可能阅读压力大 | P1 | planned | 检查摘要卡、分区标题、长 URL 和邮箱换行 | 是 | 合规信息难以阅读 | V1.5 阶段 9 |
| UX-036 | 本地模型实验 | 实验开关、模型状态、导入和生成按钮在 VoiceOver 下可能不够明确 | P0 | planned | 检查 label / hint 明确说明实验性质、设备端处理、失败回退和不生成命理结论 | 是 | 用户误解实验功能 | V1.5 阶段 9 |
| UX-037 | 本地模型实验 | Release 隐藏、Tier C 不可用、模型不存在回退需要纳入 QA gate | P0 | planned | 使用 `V1_5_QAChecklist.md` 和设备矩阵覆盖受控实验路径 | 是 | 实验能力泄露到默认路径 | V1.5 阶段 9 |
| UX-038 | 全局 | 错误状态和空状态是否被 VoiceOver 正确读出未系统验证 | P1 | planned | 检查首页错误、知识库空状态、历史空状态、本地模型不可用原因 | 是 | 异常状态不可理解 | V1.5 阶段 9 |
| UX-039 | 全局 | iPhone SE / mini / Pro Max / iPad 设备矩阵尚未执行 | P0 | planned | 按 `V1_5_DeviceTestMatrix.md` 执行人工设备测试 | 否 | 上架前适配风险 | V1.5 阶段 9 |
| UX-040 | 全局 | QA 结果尚未形成 V1.5 自测报告和下一步决策 | P0 | planned | 阶段 10 输出 V1.5 自测报告和是否恢复 TestFlight / 上架准备决策 | 否 | 下一步决策依据不足 | V1.5 阶段 10 |
