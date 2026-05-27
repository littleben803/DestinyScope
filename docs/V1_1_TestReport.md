# DestinyScope V1.1 自测报告

检查日期：2026-05-27

本报告覆盖 DestinyScope V1.1 阶段 7：V1.1 自测与文档更新。本阶段未新增功能，未修改 Swift 代码，未修改业务逻辑、CSV、知识库 JSON、RAG JSON、App Icon、Launch Screen、工程配置或依赖。

## 1. 构建检查

执行命令：

```bash
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Debug -destination 'generic/platform=iOS Simulator' build
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Release -destination 'generic/platform=iOS Simulator' build
```

检查结果：

- Debug 构建：通过。
- Release 构建：通过。
- 新增 error：未发现。
- 当前阶段 7 构建日志中未发现新增 warning。
- 既有 `DestinyScope/Lib search path not found` warning 未复现。

结论：当前 V1.1 模拟器 Debug / Release 构建通过，可进入真机自测和 TestFlight 前人工验证。

## 2. V1.1 功能检查

代码检查范围：

- `DestinyScope/UI/Result/DestinyResultView.swift`
- `DestinyScope/UI/Result/FortuneQuestionView.swift`
- `DestinyScope/UI/Home/HomeView.swift`
- `DestinyScope/UI/MainContentView.swift`
- `DestinyScope/UI/History/HistoryListView.swift`
- `DestinyScope/Services/Storage/HistoryRecordStore.swift`
- `DestinyScope/Domain/Interpreter/*`
- `DestinyScope/Domain/TextRefining/*`

检查结果：

- 结果页已展示 `LifeWeightInsight` 区域，标题为“命格洞察”。
- `LifeWeightInsight` 展示内容包括 `tags`、`focusTitle`、`focusDescription`、`strengths`、`cautions`、`actionSuggestion`。
- 结果页已展示“命理问答”入口。
- 五个预设问题均存在：我适合什么职业？我的财运特点是什么？我的性格倾向是什么？关系中需要注意什么？今天给我一句建议。
- 问答实现使用 `TemplateFortuneQuestionAnswerer`，不请求网络，不接在线 AI。
- `MainContentView` 已包含“历史”Tab，Tab 顺序为：首页、知识库、历史、关于。
- `HomeView` 在成功查询后会生成 `HistoryRecord` 并调用 `HistoryRecordStore.add` 保存。
- 查询失败时不会保存历史记录。
- `HistoryListView` 支持加载历史、删除单条记录、清空全部记录、空状态和错误提示。
- `HistoryRecordStore` 使用 Application Support 下的本地 JSON 文件保存记录。
- 历史记录最多保留 50 条，保存时按 `createdAt` 倒序截断。
- `knowledge_articles.json` 已扩充到 29 篇。
- `rag_chunks.json` 已存在，作为未来本地 RAG / 本地模型检索预留数据。
- `TextRefining` 接口已存在。
- 当前默认 `TextRefinerFactory.makeDefaultRefiner()` 返回 `TemplateTextRefiner`。
- `LocalLLMTextRefiner` 当前只是占位实现，调用会抛出 `localModelNotAvailable`，不加载模型。

待人工确认：

- 在模拟器或真机上完整点击一次首页查询、结果页问答、历史记录删除和清空流程。
- 历史记录首次加载、无记录空状态和多条记录布局需要 UI 实机确认。

## 3. 离线与隐私检查

执行命令：

```bash
rg -n "URLSession|http://|https://|NWConnection|Network|Alamofire" DestinyScope --glob '*.swift'
rg -n "OpenAI|LLM|CoreML|Core ML|MLX|llama|GGUF|Metal|LocalLLM|TextRefiner|TextRefining" DestinyScope --glob '*.swift'
rg -n "iCloud|CloudKit|CKContainer|StoreKit|SKPayment|AppTrackingTransparency|ATTrackingManager|NSUserTracking|NSCameraUsageDescription|NSPhotoLibraryUsageDescription|NSLocation|NSMicrophoneUsageDescription|CLLocation|AVCapture|PHPhotoLibrary|CNContact|requestWhenInUseAuthorization" DestinyScope --glob '*.swift' DestinyScope.xcodeproj/project.pbxproj
```

检查结果：

- Swift 代码中未发现 `URLSession`、HTTP URL、网络连接库或服务端请求代码。
- 未发现 OpenAI SDK、在线 AI SDK、Core ML、MLX、llama.cpp、GGUF 或真实模型加载代码。
- `LocalLLMTextRefiner` 只作为占位存在，并抛出 `localModelNotAvailable`。
- 未发现 iCloud、CloudKit、StoreKit、广告追踪或敏感权限申请引用。
- 历史记录只保存到本地 Application Support 目录，不上传、不联网、不接账号、不接 iCloud。

隐私文案风险：

- V1.1 新增本地历史记录后，App 内隐私政策当前主要覆盖“出生信息本地处理、不上传、无账号、无服务端、无在线 AI”等 V1 边界。
- 建议后续在进入上架前，补充“历史记录仅保存在本地设备，可由用户删除，不上传、不同步”的说明。
- 本阶段按要求只更新文档，不修改 App 内隐私政策页面。

## 4. JSON 检查

执行命令：

```bash
python3 -m json.tool DestinyScope/Resources/Knowledge/knowledge_articles.json
python3 -m json.tool DestinyScope/Resources/Knowledge/rag_chunks.json
```

检查结果：

- `knowledge_articles.json`：JSON 合法。
- `rag_chunks.json`：JSON 合法。
- 知识库文章数量：29 篇。
- RAG chunk 数量：29 条。
- article id：未发现重复。
- chunk id：未发现重复。
- 文章必填字段 `id/category/title/summary/body/tags/source/version`：齐全。
- chunk 必填字段 `id/articleId/category/title/text/tags/source/version`：齐全。
- 空正文 / 空 chunk：未发现。
- 指定禁止词扫描：未命中。

结论：知识库数据和 RAG 预留数据结构满足 V1.1 当前要求。

## 5. 文案安全检查

检查范围：

- `DestinyScope/Domain/Interpreter/TemplateFortuneInterpreter.swift`
- `DestinyScope/Domain/Interpreter/LifeWeightInsightGenerator.swift`
- `DestinyScope/Domain/Interpreter/TemplateFortuneQuestionAnswerer.swift`
- `DestinyScope/Resources/Knowledge/knowledge_articles.json`
- `DestinyScope/UI/Legal/PrivacyPolicyView.swift`
- `DestinyScope/UI/Legal/DisclaimerView.swift`
- `DestinyScope/UI/Result/DestinyResultView.swift`

检查结果：

- 模板解读使用“参考、倾向、建议、可以关注、自我观察”等表达。
- 问答回答基于 `LifeWeightResult`、`FortuneInterpretation`、`LifeWeightInsight` 和本地模板生成。
- 未发现绝对预测、恐吓式营销、医疗预测、投资收益承诺或婚姻确定性判断。
- 高风险词扫描只在 `DisclaimerView` 命中限制性说明：“不提供健康、寿命、疾病预测，不提供投资收益或财务结果的确定性判断，也不提供婚姻关系的确定性判断。”该命中属于免责声明边界，不是功能承诺。
- 结果页保留短免责声明：“结果仅供娱乐、自我探索和传统文化学习参考。”

结论：当前 V1.1 文案符合“传统文化、自我探索、本地隐私保护、非现实决策建议”的产品边界。

## 6. 真机前人工测试清单

建议进入 TestFlight 或真机安装前完成：

- 首页选择出生日期和时辰，点击查询。
- 结果页可滚动，命格标题、农历生日、总重量、诗文、权重明细可见。
- 结果页“命格洞察”内容完整展示。
- 命理问答五个预设问题均可点击并展示回答。
- 知识库列表可打开，至少 29 篇文章可见。
- 知识库详情页正文、标签、source/version 展示正常。
- 历史 Tab 可打开。
- 成功查询后新增历史记录。
- 历史记录支持删除单条。
- 历史记录支持清空全部。
- 关于页、隐私政策页、免责声明页可打开。
- 飞行模式下首页查询、结果页、知识库、历史记录仍可用。
- 浅色 / 深色模式下主要页面可读。
- 小屏 iPhone 上首页输入、结果页长文、历史记录卡片无明显截断。
- iPad 上 Launch Screen 和主要页面布局正常。
- App Icon 在真机主屏小尺寸下可识别。
- Launch Screen 居中、无广告页、无复杂动画、无高风险文案。

## 7. App Store 风险检查

当前缓解项：

- Fortune telling 类低质量风险：V1.1 已具备本地计算、结构化报告、本地问答、知识库、历史记录、Legal 页面和隐私说明，不是单一随机结果页。
- 隐私风险：核心数据处理仍在本地，无账号、无服务端、无在线 AI、无敏感权限。
- AI 命名风险：当前不接真实在线 AI，也不接真实本地 LLM；本地小模型仅预留接口，默认仍为模板实现。
- 版权风险：知识库为原创整理并保留 source；App Icon 仍需人工确认原创或授权。
- 文案风险：未发现高风险承诺文案，免责声明仍可见。

剩余人工确认项：

- 启用并确认 GitHub Pages 隐私政策公网 URL 可访问。
- 将隐私政策 URL 填入 App Store Connect。
- App Icon 原创或授权确认。
- App Store Connect 创建 App。
- 上传实际截图。
- Bundle ID、签名 Team、版本号、构建号最终确认。
- 真机断网完整主流程测试。
- 上架前补充或确认隐私政策中对“本地历史记录”的说明。

## 8. 本阶段结论

- Debug 构建通过。
- Release 构建通过。
- 未发现需要修复的阻断性小 bug。
- 本阶段未修改 Swift 文件。
- V1.1 P0 功能从代码和数据层面已具备：结果页洞察、命理问答、29 篇知识库、RAG chunks 预留、本地历史记录、TextRefining 接口预留。
- 建议进入下一步：先完成真机断网和 UI 人工验收；之后可以启动第二阶段本地 0.5B 到 1.5B 小模型预研，但不要直接接入生产路径。
