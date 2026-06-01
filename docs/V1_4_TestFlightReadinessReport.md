# DestinyScope V1.4 TestFlight Readiness Report

检查日期：2026-06-01

## 1. 检查范围

本报告覆盖 V1.4 阶段 8：TestFlight 自测与是否提交内测决策。检查重点是默认主流程、本地模型实验路径、隐私合规、构建状态、静态扫描、模型文件和 TestFlight 前置风险。

本阶段未新增产品功能，未修改称骨计算规则，未修改默认输出路径，未接服务端，未请求网络，未做模型下载，未上传 TestFlight。

## 2. 构建检查

执行命令：

```bash
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Debug -destination 'generic/platform=iOS Simulator' build
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Release -destination 'generic/platform=iOS Simulator' build
```

检查结果：

- Debug 构建：通过。
- Release 构建：通过。
- 新增阻断性 error：未发现。
- 新增阻断性 warning：未发现。
- 仍存在既有非阻断提示：
  - `IDERunDestination: Supported platforms for the buildables in the current scheme is empty.`
  - `The domain/default pair of (com.bytedance.jojo, JoJoBuildVersion) does not exist`
  - `Run script build phase 'Embed Debug llama.xcframework' will be run during every build because the option to run the script phase "Based on dependency analysis" is unchecked.`
  - `Metadata extraction skipped. No AppIntents.framework dependency found.`

Release 入口检查：

- `SettingsView` 中本地模型实验入口仍位于 `#if DEBUG` 下。
- Release 正式构建不应展示“本地模型润色实验”或“本地模型 PoC”入口。
- 默认 `TextRefinerFactory.makeDefaultRefiner()` 仍返回 `TemplateTextRefiner()`。

注意：

- 当前工程仍有 Debug llama framework 嵌入脚本提示；本阶段未修改 Xcode 工程配置。
- Release 构建日志中脚本提示仍出现，但默认用户路径没有调用本地模型实验。

## 3. 默认主流程检查

代码检查范围：

- `DestinyScope/UI/MainContentView.swift`
- `DestinyScope/UI/Home/HomeView.swift`
- `DestinyScope/UI/Result/DestinyResultView.swift`
- `DestinyScope/Domain/TextRefining/TextRefinerFactory.swift`

检查结果：

- 根视图仍为 `TabView`，包含首页、知识库、历史、关于。
- 首页负责出生日期和时辰输入。
- 查询成功后生成 `LifeWeightResult`、`FortuneInterpretation`、`LifeWeightInsight`。
- 结果页展示称骨结果、农历生日、总重量、称骨诗文和权重明细。
- 结果页展示五类 `FortuneInterpretation`：总评、性格、事业、财运、关系。
- 结果页展示 `LifeWeightInsight`：tags、focusTitle、focusDescription、strengths、cautions、actionSuggestion。
- 结果页展示命理问答入口。
- 本地知识库 JSON 当前 29 篇，`rag_chunks.json` 当前 29 条，文章 id 无重复。
- 历史记录功能仍使用本地存储，支持保存、删除单条和清空。
- 默认主流程不依赖本地模型。
- `makeDefaultRefiner()` 仍返回 `TemplateTextRefiner()`。

结论：

- 默认主流程保持不变。
- 本地模型润色实验没有替代默认结果页输出。

## 4. 本地模型实验路径检查

已实现能力：

- 实验开关默认关闭。
- 用户必须先接受实验说明，才能开启实验。
- 开关状态保存在 `UserDefaults`。
- 设备 tier 检测已存在。
- `iPhone13,1` / iPhone 12 mini 被归入 Tier C，默认禁用。
- unknown 设备默认禁用。
- Simulator 仅允许 Debug 测试，不代表真机性能。
- 模型文件状态可检测。
- 模型路径优先级为：
  1. App Documents：`Documents/LocalModels/DestinyScope/qwen2.5-0.5b-instruct-q4_k_m.gguf`
  2. App Documents alias：`Documents/LocalModels/DestinyScope/qwen2_5_0_5b_instruct_q4.gguf`
  3. Developer LocalModels：`~/LocalModels/DestinyScope/qwen2.5-0.5b-instruct-q4_k_m.gguf`
  4. Developer LocalModels alias：`~/LocalModels/DestinyScope/qwen2_5_0_5b_instruct_q4.gguf`
- `.gguf` 导入只复制到 App Documents，不上传、不下载、不写入 Bundle。
- 结果页本地润色预览卡片只在实验条件满足时展示。
- 用户手动点击后才调用本地实验 refiner。
- 原始文本始终保留。
- 润色结果不覆盖原文。
- 润色结果不写入历史记录。
- 低电量模式会回退。
- thermal serious / critical 会回退。
- Tier A 超时策略为 3 秒。
- Tier B 超时策略为 5 秒。
- Tier C 不启用。
- 连续失败后会临时回退。
- 安全检查失败会回退。

当前边界：

- 本地模型实验仍是受控实验路径。
- 本地模型输出不进入默认结果页主流程。
- 本地模型输出不参与命理问答结论生成。
- 本地模型输出不保存到历史记录。

## 5. 隐私和合规检查

App 内页面：

- 隐私政策页可从设置页和关于页进入。
- 免责声明页可从设置页和关于页进入。
- 开源许可页可从设置页和关于页进入。

隐私政策已覆盖：

- 当前正式功能无账号、无登录、无服务端、无在线 AI。
- 出生日期和出生时辰仅用于设备端本地计算。
- 不上传出生信息。
- 不上传命理结果。
- 本地历史记录仅保存在设备端。
- 不上传历史记录。
- 本地模型实验默认关闭、用户手动开启。
- 本地模型实验不上传模型输入或输出。
- 本地模型只做文本润色，不生成新的命理结论。
- 本地模型失败、超时、低电量、过热或安全检查失败时回退模板文本。

GitHub Pages 隐私页：

- `docs/privacy/index.html` 已更新。
- `docs/privacy/privacy.md` 已更新。
- 页面仍为纯静态 HTML，未引用外部 JS、CSS、CDN 或远程字体。

开源许可页已包含：

- `llama.cpp`
- `ggml / GGUF`
- `Qwen2.5-0.5B-Instruct / GGUF`

文案安全：

- App 内 Legal / Settings 页面未发现“AI 算命”“精准预测”“改命”“化解”“避灾”“保证转运”“必然发财”“大师在线”等高风险宣传词。
- 开源许可页中的 URL 仅作为文本展示，不打开外链、不请求网络。

## 6. 静态扫描

执行扫描：

```bash
rg -n "URLSession|http://|https://|OpenAI|StoreKit|CloudKit|iCloud|AppTrackingTransparency|CLLocation|Camera|Photo|Microphone|Contacts|NSCameraUsageDescription|NSPhotoLibraryUsageDescription|NSMicrophoneUsageDescription|NSContactsUsageDescription|NSLocation" DestinyScope docs/privacy docs/*.md
find . \( -iname "*.gguf" -o -iname "*.bin" -o -iname "*.safetensors" -o -iname "*.mlmodel" -o -iname "*.mlmodelc" -o -iname "*.xcframework" \) -print
```

扫描结论：

- 未发现 Swift 业务代码中的 `URLSession` 网络请求。
- `https://` 命中来自开源许可页面、隐私页、知识库 source 字段和 docs 文档中的引用 URL。
- 未发现 OpenAI SDK 或在线 AI 请求代码。
- 未发现 StoreKit、CloudKit、iCloud、AppTrackingTransparency 引用。
- 未发现定位、相机、相册、通讯录、麦克风权限申请代码。
- 仓库内未发现 `.gguf`、`.bin`、`.safetensors`、`.mlmodel`、`.mlmodelc`、`.xcframework` 文件。

## 7. 模型和 framework 检查

检查结果：

- 仓库内没有 `.gguf` 模型文件。
- 仓库内没有 `llama.xcframework`。
- 仓库内没有 llama.cpp 源码。
- 当前模型仍由本地文件导入或开发者准备。
- 当前不做模型下载。

注意：

- `DestinyScope/Domain/Models/OpenSourceLicenseItem.swift` 当前被 `.gitignore` 中的 `Models/` 规则忽略。当前本地构建通过，但在提交或交付前需要处理该 source-control 问题，否则该 Swift 文件可能不会进入版本库。

## 8. 已知真机测试结果

已知 benchmark：

- iPhone 17 Pro Max / iOS 26.2：正常样例约 1 秒级，体验可接受。
- iPhone 12 mini / iOS 26.5：正常短文本约 4 到 5 秒，可运行但不适合默认开启。
- 高风险输入在已测设备上可触发 fallback。

仍缺：

- Xcode Instruments Memory / CPU / Energy / Thermal 数据。
- 更多机型覆盖。
- 连续长时间运行稳定性测试。
- 低电量和过热状态的真机验证。

## 9. 风险与阻塞项

TestFlight 前必须处理：

- Apple Developer Program 账号状态确认。
- Bundle ID / Signing / Team / Version / Build 确认。
- 真机完整流程测试。
- GitHub Pages 隐私页公网可访问确认。
- license / notice 人工留档。
- 开源许可页面人工审核。
- App Icon 授权确认。
- Release Archive 检查。
- TestFlight 审核备注准备。
- 测试人员说明准备。
- 修正或确认 `OpenSourceLicenseItem.swift` 被 `.gitignore` 忽略的问题。

## 10. 本阶段结论

- 技术准备：Conditional Go for internal TestFlight preparation。
- App Store 正式发布：No-Go。
- 默认开启本地模型：No-Go。
- 替换默认结果页输出：No-Go。

V1.4 已具备进入受限 TestFlight 内测准备的基础，但不建议直接上传或对外发布。下一阶段应先处理账号、签名、license、Review Notes、测试说明和 source-control 小问题。
