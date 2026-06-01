# DestinyScope V1 TestFlight 前自测报告

检查日期：2026-05-26

本报告覆盖 V1 阶段 12A：TestFlight 前自测和发布风险检查。本阶段未修改 Swift 业务代码、UI 页面、资源文件、工程配置、CSV 或知识库 JSON。

## 1. 构建检查

执行命令：

```bash
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Debug -destination 'generic/platform=iOS Simulator' build
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Release -destination 'generic/platform=iOS Simulator' build
```

检查结果：

- Debug 构建：通过。
- Release 构建：通过。
- 脚本或资源报错：未发现阻断性错误。
- 既有 `DestinyScope/Lib search path not found`：未复现。
- 当前构建日志仍有非阻断环境提示：
  - `IDERunDestination: Supported platforms for the buildables in the current scheme is empty.`
  - `The domain/default pair of (com.bytedance.jojo, JoJoBuildVersion) does not exist`

结论：当前模拟器 Debug / Release 构建可用于进入 TestFlight 前下一轮真机验证。上述两条日志未阻断构建，但上架前仍建议在正式 Archive 环境再次确认。

## 2. 主流程检查

代码检查范围：

- `DestinyScope/UI/MainContentView.swift`
- `DestinyScope/UI/Home/HomeView.swift`
- `DestinyScope/UI/Result/DestinyResultView.swift`

检查结果：

- App 根视图使用 `TabView`，包含：首页、知识库、关于。
- 首页输入出生日期和时辰，点击“查询”后调用 `LifeWeightEngine`。
- 查询成功后生成 `LifeWeightResult` 和 `FortuneInterpretation`，再进入 `DestinyResultView`。
- 结果页展示命格标题、农历生日、总重量、称骨诗文。
- 结果页展示权重明细：年、月、日、时。
- 结果页展示五类解读：总评、性格、事业、财运、关系。
- 查询失败时，`HomeView` 会清空 `calculation` 和 `interpretation`，关闭结果跳转，并展示错误文案，避免继续展示上一次成功结果。
- 结果页使用 `ScrollView`，长结果内容可滚动。

待人工确认：

- 在真机或模拟器上完整点击一次主流程，确认 Launch Screen、首页、结果页转场和返回行为符合预期。
- 使用边界日期和不同时辰抽样测试，确认错误提示和成功结果都能正常展示。

## 3. 知识库检查

执行命令：

```bash
node -e 'const fs=require("fs"); const a=JSON.parse(fs.readFileSync("DestinyScope/Resources/Knowledge/knowledge_articles.json","utf8")); console.log(a.length);'
```

检查结果：

- 本地知识库 JSON 可解析。
- 当前共有 5 篇文章：
  - 称骨算命是什么
  - 农历与时辰
  - 生肖基础
  - 五行基础
  - 如何理性看待命理结果
- `KnowledgeListView` 使用 `KnowledgeRepository` 加载文章列表。
- 列表展示 title、summary、category。
- 点击文章进入 `KnowledgeDetailView`。
- 详情页展示 title、category、summary、body、tags、source/version。
- 知识库列表和详情页均使用滚动容器。

待人工确认：

- 在真机或模拟器上逐篇打开文章，确认中文排版、标签和 source/version 不截断。

## 4. 设置和合规检查

代码检查范围：

- `DestinyScope/UI/Settings/SettingsView.swift`
- `DestinyScope/UI/Settings/AboutView.swift`
- `DestinyScope/UI/Legal/PrivacyPolicyView.swift`
- `DestinyScope/UI/Legal/DisclaimerView.swift`
- `DestinyScope/UI/Result/DestinyResultView.swift`

检查结果：

- 关于页可从关于 Tab 进入。
- 隐私政策页入口已存在。
- 免责声明页入口已存在。
- 结果页底部有短免责声明：“结果仅供娱乐、自我探索和传统文化学习参考。”
- 隐私政策覆盖：无账号、无登录、出生信息本地处理、不上传、无服务端、无在线 AI、无敏感权限、无广告追踪。
- 免责声明覆盖：传统命理文化和本地模板、仅供娱乐和自我探索、不构成医疗/法律/财务/投资/婚恋/职业建议、不做健康/寿命/疾病预测、不做投资或婚姻确定性判断。

风险词扫描结果：

- 未发现用于营销承诺的“精准预测未来”“改命”“化解”“大师”“必然发财”等表述。
- “寿命”“疾病”“投资收益”等词只出现在免责声明的限制性说明中，用于明确不提供相关预测或建议。

待人工确认：

- App Store 元数据、截图、审核备注也需要保持同样边界，不宣传精准预测、改命、化解或确定性收益。

## 5. 离线能力检查

执行命令：

```bash
rg -n "URLSession|http://|https://|NWConnection|Network|Alamofire|OpenAI|LLM|AVCapture|PHPhotoLibrary|CLLocation|CNContact|requestWhenInUseAuthorization|NSCameraUsageDescription|NSPhotoLibraryUsageDescription|NSLocation|NSMicrophoneUsageDescription|AppTrackingTransparency|ATTrackingManager|StoreKit|SKPayment|Subscription" DestinyScope/UI DestinyScope/Domain DestinyScope/Services DestinyScope/Bizs DestinyScope/Model DestinyScope/DestinyScopeApp.swift DestinyScope/Resources
```

检查结果：

- 未发现 `URLSession`、HTTP URL、网络连接库或服务端请求代码。
- 未发现 OpenAI SDK、在线 AI SDK 或本地 LLM 推理接入。
- 未发现定位、相机、相册、通讯录、麦克风、广告追踪权限申请代码。
- 未发现 StoreKit、订阅或支付代码。
- 唯一 AI/LLM 命中来自隐私政策文案，内容是说明 V1 不接在线 AI、不使用真实本地 LLM 推理。

结论：当前 V1 核心功能符合“完全 Native、无服务端、无在线 AI、出生信息本地处理”的定位。

## 6. 资源检查

执行命令：

```bash
sips -g pixelWidth -g pixelHeight -g hasAlpha DestinyScope/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png
rg -n "UILaunchStoryboardName|LaunchScreen|ASSETCATALOG_COMPILER_APPICON_NAME|ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME" DestinyScope.xcodeproj/project.pbxproj DestinyScope/LaunchScreen.storyboard
```

检查结果：

- `AppIcon-1024.png` 存在。
- App Icon 尺寸：1024x1024。
- App Icon alpha：无。
- `AppIcon.appiconset/Contents.json` 已引用 `AppIcon-1024.png`。
- `AccentColor` 已配置，浅色为朱砂红 `#9E2D24`，深色为 `#D65C49`。
- 工程已配置 `ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon`。
- 工程已配置 `ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor`。
- 工程已配置 `INFOPLIST_KEY_UILaunchStoryboardName = LaunchScreen`。
- `DestinyScope/LaunchScreen.storyboard` 存在，使用静态文本和宣纸米白背景。

待人工确认：

- App Icon 素材版权、授权或原创归属。
- App Icon 在真机主屏小尺寸下的识别度。
- Launch Screen 在 iPhone 和 iPad 上是否居中、无裁切、无闪烁。

## 7. 适配检查

代码检查结果：

- 页面统一使用 `AppBackground`、`AppCard` 和动态 `AppTheme` 色值。
- `AppTheme` 为浅色/深色模式分别配置背景、卡片、主文本、次文本、朱砂红、暗金和分割线颜色。
- 首页、结果页、知识库列表、知识库详情、设置、关于、隐私政策、免责声明均使用滚动容器或可滚动布局。
- 结果页和知识库详情页适合承载长文本。

待人工确认：

- 小屏 iPhone 上 DatePicker、Picker、Tab 文案和结果页权重明细是否有明显截断。
- 深色模式下金色/朱砂色文本与背景对比度是否足够。
- iPad 上 Launch Screen 和主要页面留白是否正常。

## 8. App Store 风险检查

当前缓解项：

- Fortune telling 类低质量风险：V1 已加入本地知识库、隐私政策、免责声明、权重明细和模板解读，不是单纯随机结果页。
- 隐私风险：App 内隐私政策已说明无账号、无服务端、出生信息不上传、无在线 AI、无敏感权限。
- AI 命名风险：代码和隐私文案说明当前为本地模板式解读，不接真实在线 AI。
- 免责声明：结果页和独立免责声明页均可见。
- 离线能力：静态扫描未发现网络请求、权限申请或在线 AI 接入。

剩余风险：

- App Store Connect 仍需要可访问的隐私政策 URL，App 内页面不能替代该 URL。
- App Icon 素材需要用户人工确认原创或授权，避免版权风险。
- 上架截图、描述、关键词、审核备注尚未检查，不能使用“精准预测未来”“改命”“化解”“必然发财”等高风险营销话术。
- 若外部元数据使用“AI 命理师”，需要明确是本地模板式解读，或改用“命理师解读”。
- 仍需一次真机断网测试，确认核心计算、知识库、Legal 页面均不依赖网络。

## 9. 本阶段结论

- Debug 构建通过。
- Release 构建通过。
- 未发现需要本阶段修复的阻断性 Swift 小 bug。
- 本阶段未修改 Swift 文件。
- TestFlight 前仍必须人工确认：真机主流程、断网流程、App Icon 授权、App Store 隐私政策 URL、上架截图和元数据文案。

## 10. V1.1 增量自测状态

检查日期：2026-05-27

新增报告：

- 已新增 `docs/V1_1_TestReport.md`，覆盖 V1.1 阶段 2 到阶段 7 的构建、功能、离线、隐私、JSON 和文案安全检查。

V1.1 当前检查结论：

- Debug 构建通过。
- Release 构建通过。
- 结果页已展示 `LifeWeightInsight`：标签、权重侧重点、优势倾向、需要关注、行动建议。
- 结果页已新增“命理问答”，五个预设问题均存在，回答由本地 `TemplateFortuneQuestionAnswerer` 生成。
- 历史 Tab 已存在，历史记录保存在本地 Application Support 目录，支持删除单条和清空全部，最多保留 50 条。
- 本地知识库已扩充到 29 篇。
- `rag_chunks.json` 已存在且 JSON 合法，当前只作为未来 RAG 预留，不接检索。
- `TextRefining` 接口已存在，默认实现为 `TemplateTextRefiner`，`LocalLLMTextRefiner` 仅为占位并抛出 `localModelNotAvailable`。
- 静态扫描未发现网络请求、在线 AI、真实本地 LLM、Core ML、MLX、llama.cpp、模型文件下载、权限申请、StoreKit、广告追踪或 iCloud 同步。

V1.1 真机前人工检查：

- 首页查询到结果页完整链路。
- 命理问答五个问题点击和回答展示。
- 知识库列表和详情页长文滚动。
- 历史记录新增、删除单条、清空全部。
- 飞行模式下首页查询、知识库、历史记录和 Legal 页面。
- 浅色 / 深色模式可读性。

## 11. V1.3 本地模型润色实验测试项

检查日期：2026-05-29

当前状态：

- V1.3 仅完成 TestFlight 内测开关设计文档。
- 尚未实现生产开关。
- 当前 Release 不展示本地模型实验功能。
- 当前 App Store 元数据不应宣传 AI / 本地模型。

后续若进入 TestFlight 内测实现，必须人工验证：

- Tier A 设备可看到实验开关，默认关闭。
- Tier B 设备如显示开关，必须提示可能较慢或耗电。
- Tier C 设备不显示开关，或显示为不可用。
- 首次开启展示实验说明和用户确认。
- 用户关闭后回退 `TemplateTextRefiner`。
- 模型不存在时回退。
- framework 不可用时回退。
- 加载失败时回退。
- 生成超时时回退。
- 安全检查失败时回退。
- 低电量模式和过热状态行为符合预期。
- 飞行模式下仍可使用本地模板路径。
- 深色 / 浅色模式下说明文案可读。
- App 重启后开关状态符合设计预期。
- 不记录用户出生信息、完整命理结果、完整模型输入输出或可识别个人身份的信息。
- 测试人员说明文案明确：本地模型只做文本润色，不生成新的命理结论。
- 测试人员说明文案明确：不上传出生信息、命理结果、模型输入输出或历史记录。
- 测试人员说明文案避免“AI 算命”“精准预测”“改命”“化解”“保证转运”等表述。
- 本地润色实验隐私说明可见，且与 `docs/V1_3_PrivacyPolicyDraft.md` 保持一致。
- 模型来源已确认，记录实际 GGUF 文件 URL。
- Qwen base repo license 已截图或归档。
- Qwen GGUF repo license 已截图或归档。
- llama.cpp license 已截图或归档。
- 已确认 TestFlight 分发是否允许携带模型文件。
- 已确认是否需要 App 内“开源许可”入口。
- 如果 TestFlight 包含模型或 framework，license / notice 已随包或在 App 内可见。

V1.3 TestFlight Decision：

- 已阅读 `docs/V1_3_TestFlightDecision.md`。
- 结论为 Conditional Go for limited TestFlight。
- 确认 App Store 正式发布仍为 No-Go。
- 确认本地模型默认关闭。
- 确认本地模型不接入默认结果页。
- 确认本地模型只用于 `TextRefining` 润色。
- 确认 Release 默认隐藏本地模型入口。

进入内测前置项：

- Qwen base repo license 已人工确认。
- Qwen GGUF repo license 已人工确认。
- llama.cpp license 已人工确认。
- App 内开源许可 / notice 页面方案已准备。
- 模型分发或测试人员导入方案已确认。
- 已确认模型不会误提交仓库。
- 设备 tier 检测方案已准备。
- 低电量 / 过热 / 超时回退方案已准备。
- 本地润色预览卡片方案已准备。
- App 内隐私政策页面更新草案已准备。
- GitHub Pages 隐私页更新草案已准备。
- TestFlight 测试说明已更新。

本地润色预览卡片测试项：

- 实验开关关闭时，结果页不展示“本地润色预览”入口。
- Tier C 设备不展示入口，或入口显示为不可用。
- 模型不存在时入口不可用，或点击后回退原始模板文本。
- 点击“生成润色版”后，原始结果仍然可见。
- 润色结果不覆盖原始模板文本。
- 润色结果不写入历史记录。
- 润色结果不参与后续命理问答推理。
- 安全检查失败时显示回退文案。
- 超时时显示回退文案。
- 用户取消时保留原始模板文本。
- App 重启后不会把润色结果误认为原始结论。
- Release 默认不展示该入口。
- 小屏 iPhone 和 iPad 基础适配。
- App Icon 和 Launch Screen 真机显示。
- 上架前补充或确认隐私政策中对“历史记录仅保存在本地设备”的说明。

## 12. V1.4 TestFlight 实现准备检查项

当前状态：

- 已准备 `docs/V1_4_TestFlightImplementationPlan.md`。
- 已准备 `docs/V1_4_Roadmap.md`。
- 已准备 `docs/V1_4_RiskChecklist.md`。
- V1.4 阶段 1 仅为实现拆解文档，尚未修改 Swift 代码。

进入 V1.4 阶段 2 前检查：

- 实验开关默认关闭。
- Release 默认隐藏实验入口。
- `makeDefaultRefiner()` 仍应返回 `TemplateTextRefiner`。
- 模型文件不提交仓库。
- `llama.xcframework` 不提交仓库。
- 设备 tier 检测设计已明确。
- 模型可用性检测路径已明确。
- 低电量 / 过热 / 超时回退策略已明确。
- 本地润色预览卡片只作为用户手动触发入口。
- 本地润色结果不覆盖原始结果。
- 本地润色结果不写入历史记录。
- 不上传用户数据或模型输入输出。

V1.4 阶段 2 实验开关测试项：

- 设置页 Debug 入口显示“本地模型润色实验”。
- 初始状态为关闭。
- 未接受说明前不能开启。
- 点击“我理解这是实验功能”后可开启。
- 可关闭开关。
- App 重启后开关状态符合预期。
- 重置后清除开启状态和确认状态。
- Release 不展示入口。
- 打开或关闭开关不调用模型。
- 打开或关闭开关不改变默认结果页输出。

V1.4 阶段 3 设备 tier 检查项：

- 设置页实验入口展示当前设备 identifier。
- 设置页实验入口展示当前设备 tier、说明、是否允许和推荐超时。
- iPhone 17 Pro Max 应识别为 Tier A，或通过后续映射配置为 Tier A。
- iPhone 12 mini / `iPhone13,1` 应识别为 Tier C，并默认禁用。
- Simulator 仅作为 Debug 测试，不代表真机性能。
- 未识别设备应显示为 `Unknown`，默认禁用。
- Tier C 或 `Unknown` 设备不能开启本地模型润色实验。
- 设备 tier 检测不调用模型、不接结果页、不改变默认输出。

V1.4 阶段 4 模型文件状态测试项：

- App Documents 存在 `qwen2.5-0.5b-instruct-q4_k_m.gguf` 时可识别为可用。
- App Documents 存在 alias `qwen2_5_0_5b_instruct_q4.gguf` 时可识别。
- Developer LocalModels 路径在 Debug / Simulator 可识别。
- 模型不存在时显示不可用原因。
- 非 `.gguf` 文件不能导入。
- 导入会复制到 App Documents/LocalModels/DestinyScope/。
- 导入不会上传、不会下载、不会写入 App Bundle。
- 模型文件状态检测不调用模型、不接结果页、不改变默认输出。

V1.4 阶段 5 本地润色预览卡片测试项：

- 实验开关关闭时结果页不展示卡片。
- 用户未接受实验说明时结果页不展示卡片。
- 设备 tier 不允许时结果页不展示卡片。
- 模型文件不可用时结果页不展示卡片。
- 开关开启且模型可用时才展示“本地润色预览”卡片。
- 点击“生成润色版”后才调用本地实验 refiner。
- 原始结果、诗文、命理师解读和命格洞察仍保留。
- 润色结果只显示在卡片内，不覆盖原始文本。
- 生成失败时显示温和回退文案。
- 安全检查失败时显示回退到原始文本。
- 润色结果不写入历史记录。
- Release 不展示本地模型实验入口。

V1.4 阶段 6 运行时保护测试项：

- 低电量模式下不运行本地润色，并保留原始模板文本。
- thermal state 为 serious / critical 时回退原始模板文本。
- thermal state 为 fair 时可继续运行，但应展示温和提示。
- Tier C 不运行本地润色。
- Tier A 超过 3 秒回退。
- Tier B 超过 5 秒回退。
- Simulator Debug 使用测试超时，不代表真机性能。
- 连续失败达到阈值后暂时回退模板文本。
- 安全检查失败仍回退原始文本。
- 原始文本始终保留。
- 润色结果不写入历史记录。
- Release 不展示实验入口。

V1.4 阶段 7 Legal 页面测试项：

- 设置页可打开“开源许可”页面。
- 关于页可打开“开源许可”页面。
- 开源许可页面包含 llama.cpp、ggml / GGUF、Qwen2.5-0.5B-Instruct / GGUF。
- 开源许可页面说明当前内容不是法律意见。
- 隐私政策包含本地历史记录仅保存在设备端的说明。
- 隐私政策包含本地模型润色实验默认关闭、用户手动开启、设备端运行的说明。
- 隐私政策说明本地模型不上传模型输入、模型输出、出生信息、命理结果或历史记录。
- 隐私政策说明润色结果默认不保存到历史记录。
- GitHub Pages 隐私页内容已同步更新。
- 发布前人工确认 `https://littleben803.github.io/DestinyScope/privacy/` 可访问且无 404。

V1.4 阶段 8 TestFlight readiness 决策项：

- 已阅读 `docs/V1_4_TestFlightReadinessReport.md`。
- 已阅读 `docs/V1_4_TestFlightDecision.md`。
- 确认结论为 Conditional Go for internal TestFlight preparation。
- 确认 App Store 正式发布仍为 No-Go。
- 确认本地模型默认开启仍为 No-Go。
- 确认替换默认结果页输出仍为 No-Go。
- Debug 构建通过。
- Release 构建通过。
- `makeDefaultRefiner()` 仍返回 `TemplateTextRefiner()`。
- 仓库内无 `.gguf`、`.bin`、`.safetensors`、`.mlmodel`、`.mlmodelc`、`.xcframework`。
- Apple Developer Program 账号状态已确认。
- Bundle ID / Signing / Team / Version / Build 已确认。
- Release Archive 已完成。
- GitHub Pages 隐私页公网 URL 可访问。
- license / notice 已人工留档。
- App Icon 授权已确认。
- TestFlight 审核备注已准备。
- 测试人员说明已准备。

## 13. V1.5 暂停上传与体验优化检查项

当前状态：

- V1.5 暂停 TestFlight 上传。
- V1.5 暂不进入 App Store 上架。
- V1.5 聚焦产品体验优化、source-control 风险修复、UX 审计和质量门槛完善。
- 本地模型实验仍保持默认关闭、受控展示、失败回退。

后续如恢复 TestFlight，需要重新执行：

- V1.4 TestFlight readiness 检查。
- Debug / Release 构建检查。
- Release Archive 检查。
- license / notice 人工确认。
- GitHub Pages 隐私页公网访问确认。
- TestFlight 审核备注和测试人员说明确认。
- 仓库内无 `.gguf`、`.xcframework`、`.bin`、`.safetensors`、`.mlmodel`、`.mlmodelc`。

V1.5 阶段 2 前置检查：

- `git check-ignore -v DestinyScope/Domain/Models/OpenSourceLicenseItem.swift` 已不再命中误伤规则。
- `OpenSourceLicenseItem.swift` 已加入 git 索引，后续应随源码提交。
- `LocalModels/`、`/Models/`、`DestinyScope/LocalModels/`、模型扩展名和 `*.xcframework` 规则仍必须被忽略。
- 仓库内当前未发现 `.gguf`、`.bin`、`.safetensors`、`.mlmodel`、`.mlmodelc` 或 `.xcframework`。
- source-control 风险已修复，可进入 V1.5 阶段 3：UI / UX 全量审计。

V1.5 阶段 3 UI / UX 人工检查项：

- 结果页长滚动是否易读。
- 权重明细和标签在小屏是否截断。
- 命理问答是否占用过多页面空间。
- 本地润色预览是否明确为临时预览，不覆盖原始结果。
- 知识库 29 篇文章是否需要分类筛选或搜索。
- 历史记录是否清楚说明仅本地保存。
- 清空历史是否需要二次确认。
- 设置 / 关于 / Legal / 开源许可是否过长且难以快速定位。
- 本地模型实验入口是否会误导用户以为模型参与命理结论。
- 深色模式、Dynamic Type、VoiceOver 和 iPad 留白需要专项检查。

V1.5 阶段 4 结果页阅读体验测试项：

- 顶部摘要展示命格标题、农历生日、出生时辰和总重量。
- 称骨诗文独立展示，文案未变化。
- 权重明细年 / 月 / 日 / 时数值未变化。
- 权重明细在小屏上不明显截断。
- 命格标签可以换行，不横向溢出。
- 五类解读可展开 / 收起，默认仍能看到核心内容。
- 命理问答逻辑不变。
- 本地润色预览仍只在实验条件满足时展示。
- 本地润色预览不自动生成、不覆盖原始文本、不写入历史记录。
- 底部免责声明仍可见。
- 深色模式、Dynamic Type 和 VoiceOver 仍需人工验证。

V1.5 阶段 5 知识库浏览体验测试项：

- 知识库列表可加载 29 篇文章。
- 顶部分类 chips 显示“全部”和动态分类。
- 点击分类后列表只显示该分类文章，并显示当前分类数量。
- 搜索为空时显示当前分类结果。
- 搜索关键词能匹配标题、摘要、分类、标签和正文。
- 搜索无结果时显示友好空状态。
- 搜索和筛选不请求网络。
- 列表项展示 title、summary、category 和最多 3 个 tags。
- 详情页展示 title、category、summary、正文、tags、source/version。
- 详情页正文可完整滚动阅读，tags 不横向溢出。
- 小屏、深色模式、Dynamic Type 和长 source URL 仍需人工验证。

V1.5 阶段 6 历史记录体验测试项：

- 历史记录为空时显示空状态。
- 空状态说明历史记录仅本地保存，不上传或同步。
- 完成一次查询后历史记录列表新增轻量记录。
- 列表顶部显示本地保存说明。
- 历史记录卡片展示标题、创建时间、出生日期和时辰、农历生日、总重量和 tags。
- 点击历史记录进入详情页。
- 详情页只展示已保存字段，不重新生成完整报告。
- 详情页不展示本地润色预览，不调用本地模型。
- 删除单条记录前出现确认弹窗。
- 清空全部前出现确认弹窗。
- 取消确认时不删除。
- 删除或清空后列表状态正确刷新。
- 小屏、深色模式、Dynamic Type 和 VoiceOver 仍需人工验证。

V1.5 阶段 7 设置 / Legal 页面测试项：

- 设置页显示应用信息、隐私与安全、实验功能分区。
- Release 构建不展示本地模型实验入口。
- 关于页可打开，且展示 App 定位、当前能力和使用边界。
- 隐私政策可打开，并包含当前版本、本地历史记录和本地模型实验说明。
- 免责声明可打开，并明确内容仅供娱乐、自我探索和传统文化学习参考。
- 开源许可可打开，并展示 llama.cpp、ggml/GGUF、Qwen2.5 条目。
- 开源许可中的 URL 只作为文本显示，不打开外链、不请求网络。
- 本地模型实验入口文案不暗示模型生成命理结论。
- 小屏、深色模式、Dynamic Type 和 VoiceOver 仍需人工验证。

V1.5 阶段 9 Accessibility / Dark Mode / Small Screen QA 项：

- VoiceOver 可按合理顺序读出首页、结果页、知识库、历史、设置和 Legal 页面。
- 首页查询按钮、结果页问答按钮、本地润色预览按钮、知识库搜索、历史删除 / 清空、Legal 入口具备可理解的 label / hint。
- Dynamic Type 默认、Large、Extra Large、Accessibility Large 均需检查。
- iPhone SE / mini 上首页输入、结果页卡片、知识库 chips、历史记录卡片和 Legal 长文不明显截断。
- iPhone 17 Pro Max 上结果页长滚动和卡片间距舒适。
- iPad 上内容宽度和留白需要人工确认。
- 深色模式下背景、卡片、朱砂红、暗金、tag / chip / badge、错误提示和 Legal 长文可读。
- 本地模型实验开关默认关闭，未接受说明不能开启。
- Tier C / unknown 设备不应启用本地模型实验。
- 模型不存在、低电量、过热、超时、安全检查失败时必须回退。
- Release 不展示本地模型实验入口。
- `makeDefaultRefiner()` 默认仍应返回 `TemplateTextRefiner`。
- 润色结果不覆盖原始文本、不写入历史记录。
- 按 `docs/V1_5_DeviceTestMatrix.md` 记录设备、系统、屏幕类别、测试重点和问题。

V1.5 阶段 10 自测与决策：

- 已新增 `docs/V1_5_TestReport.md`。
- 已新增 `docs/V1_5_ReleaseReadinessDecision.md`。
- Debug build 通过。
- Release build 通过。
- 当前暂不上传 TestFlight。
- 当前不进入 App Store Release。
- 本地模型默认启用仍为 No-Go。
- `makeDefaultRefiner()` 仍应返回 `TemplateTextRefiner`。
- 默认主流程不依赖本地模型。
- 仓库内未发现 `.gguf`、`.bin`、`.safetensors`、`.mlmodel`、`.mlmodelc`、`.xcframework`。
- Swift 源码未发现新增网络请求、在线 AI、StoreKit、CloudKit、广告追踪或敏感权限申请。

如恢复 TestFlight，需要重新执行：

- V1.4 readiness 检查。
- V1.5 QA checklist。
- 多设备人工验收。
- GitHub Pages 隐私页公网访问和内容一致性确认。
- license / notice 人工留档。
- TestFlight Review Notes 和测试人员说明。
- Bundle ID / Signing / Version / Build / Archive 检查。

V1.6 产品功能打磨状态：

- V1.6 暂停 TestFlight 上传。
- 当前不创建 App Store Connect 记录。
- 当前不修改 Bundle ID / Signing / Team / Version / Build。
- 当前不默认启用本地模型。
- 当前不接模型下载、云端 AI、RAG、开放聊天或付费订阅。
- 后续如恢复 TestFlight，需要在 V1.6 新增功能完成后重新执行 readiness 检查。
- V1.6 新增的本地数据能力需要重点测试：
  - onboarding flag 默认行为和重看入口。
  - local birth profiles 的新增、复用、删除。
  - 结果文本复制 / 分享文案安全边界。
  - 知识库收藏和最近阅读的本地保存与清空。
  - 历史记录收藏 / 置顶 / 快速复查是否不重新计算历史详情。
  - 本地数据管理入口是否能删除历史、收藏、最近阅读和 Profile。
  - 所有新增数据均不上传、不同步、不登录。

V1.6 阶段 2 Onboarding 测试项：

- 首次启动时展示使用说明。
- 点击“开始使用”后进入主界面。
- 完成后再次启动不再自动展示。
- `hasCompletedOnboarding` 只保存完成状态，不保存出生信息。
- 设置页“使用说明”入口可再次打开。
- 关于页“使用说明”入口可再次打开。
- 再次查看不会重置完成状态。
- 小屏可读。
- 深色模式可读。
- VoiceOver 基础可用，下一步、上一步、开始使用按钮有 label / hint。
- Onboarding 文案不包含高风险营销表达。

V1.6 阶段 3 常用出生资料测试项：

- 首页可保存当前出生日期和时辰为常用资料。
- displayName 为空时使用默认本地显示名。
- 首页可选择常用资料并填入出生日期和时辰。
- 选择常用资料后不会自动查询、不会自动保存历史。
- 设置页可打开“常用出生资料”。
- 常用资料列表可展示 displayName、出生日期、时辰和更新时间。
- 删除单条资料有确认提示。
- 清空全部资料有确认提示。
- 常用资料为空时显示友好空状态。
- 隐私政策说明常用资料仅本地保存、不上传、不同步、可删除。
- Release 构建通过。

V1.6 阶段 4 结果复制与分享测试项：

- 结果页展示“复制与分享”卡片。
- 点击“复制摘要”后显示已复制提示。
- 剪贴板文本包含命格标题、总重量、称骨诗文、行动建议和安全提示。
- 点击“分享摘要”后打开系统分享面板。
- 分享文本包含“仅供娱乐、自我探索和传统文化学习参考”或等价安全提示。
- 默认分享文本不包含完整出生日期、完整农历生日、具体出生时辰、常用出生资料显示名或历史记录信息。
- 分享文本不包含本地模型润色结果。
- 复制 / 分享不会写入历史记录、不会保存分享记录、不会请求网络。
- 不做图片分享或海报分享。

V1.6 阶段 5 知识库收藏与最近阅读测试项：

- 文章详情页可收藏文章。
- 文章详情页可取消收藏。
- 知识库列表行可显示已收藏状态。
- 知识库分类中显示“收藏”，点击后只展示收藏文章。
- 收藏为空时显示友好空状态。
- 打开文章详情后会加入最近阅读。
- 知识库列表“我的知识库”展示收藏数量、最近阅读数量和最近阅读入口。
- 最近阅读最多保留 20 条，重复阅读同一文章应更新到最新位置。
- 收藏最多保留 100 个 article id。
- 清空最近阅读需要确认。
- 清空收藏需要确认。
- 知识库收藏和最近阅读只保存 article id / viewedAt，不保存文章全文或搜索关键词。
- 收藏和最近阅读不上传、不同步、不需要账号。
- 隐私政策说明知识库收藏与最近阅读仅本地保存。
- `knowledge_articles.json` 未修改。

V1.6 阶段 6 历史收藏 / 置顶 / 快速复查测试项：

- 历史详情页可收藏记录。
- 历史详情页可取消收藏。
- 历史详情页可置顶记录。
- 历史详情页可取消置顶。
- 历史列表展示收藏 / 置顶 badge。
- 置顶记录在历史列表中优先展示。
- 置顶记录内部按创建时间倒序排列。
- 非置顶记录按创建时间倒序排列。
- 历史收藏 / 置顶只保存 history record id，不改变 `HistoryRecord` 存储字段。
- 删除单条历史记录后，对应收藏 / 置顶状态被清理。
- 清空全部历史记录后，收藏 / 置顶状态被清空。
- 点击“填入首页重新查询”后只填入首页出生日期和时辰。
- 快速复查不会自动查询、不会自动保存历史、不会重新计算历史记录。
- HomeInputDraft 只保存在内存中，不写入 UserDefaults 或 JSON。
- 隐私政策说明历史收藏 / 置顶 / 快速复查仅本地处理。
- 不调用本地模型，不上传，不同步，不需要账号。

V1.6 阶段 7 首页信息架构测试项：

- 首页顶部展示 DestinyScope 定位说明。
- 首页展示出生信息仅本机计算、不需要账号、不上传的隐私提示。
- 首页常用资料区域可选择资料填入出生日期和时辰。
- 选择常用资料后不会自动查询、不会自动保存历史。
- 从历史详情填入首页后展示草稿提示。
- 历史草稿填入后不会自动查询、不会自动保存历史、不会重新计算。
- 查询按钮在输入卡片中清晰可见。
- 保存当前出生资料入口在输入卡片中，不喧宾夺主。
- 最近历史卡片只展示本地轻量摘要，不重新计算、不自动填入。
- 知识库入口不请求网络，只做轻量说明。
- 小屏和深色模式下首页各卡片可读。

V1.6 阶段 8 本地数据管理测试项：

- 设置页可打开“本地数据管理”。
- 本地数据摘要显示历史记录、常用出生资料、知识库收藏、最近阅读、历史收藏、历史置顶和首次使用说明状态。
- 清空历史记录前有确认，确认后历史记录为空，并同步清理对应历史收藏 / 置顶状态。
- 清空历史收藏 / 置顶前有确认，确认后不删除历史记录。
- 清空常用出生资料前有确认，确认后首页和管理页不再展示常用资料。
- 清空知识库收藏前有确认，确认后不删除内置知识库文章。
- 清空知识库最近阅读前有确认，确认后不删除内置知识库文章。
- 重置首次使用说明前有确认，确认后不删除其他本地数据。
- 清空全部本地用户数据前有确认，确认后仅清理本机用户数据。
- 清理后内置知识库仍可打开，默认主流程仍可查询。
- 清理操作不删除 `.gguf` 模型文件，不删除 `llama.xcframework`。
- 清理操作不请求网络、不上传、不同步、不需要账号。
