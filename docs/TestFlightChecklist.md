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
