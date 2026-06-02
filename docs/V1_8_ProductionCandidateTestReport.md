# DestinyScope V1.8 Production Candidate Test Report

检查日期：2026-06-02

## 1. 阶段结论

V1.8 阶段 3 生产候选自测已完成。

本阶段只执行自测、静态扫描、构建检查和风险收口。本阶段未修改 Swift 代码、Xcode 工程配置、资源文件、模型文件、CSV、JSON、签名配置、Bundle ID、Version 或 Build。

当前结论：

- Debug build：通过。
- Release build：通过。
- 指定 GGUF 已进入 Git LFS。
- 指定 GGUF 已进入 Release `.app` 产物。
- `llama.framework` 已进入 Release `.app/Frameworks`。
- `TextRefinerFactory.makeDefaultRefiner()` 当前返回 `AutoLocalTextRefiner()`。
- 模板结果始终保留，本地润色失败时回退模板。
- 未发现 Swift 源码新增网络、在线 AI、StoreKit、CloudKit、追踪或敏感权限。
- 当前仍不得上传 App Store。
- 当前仍不得上传 TestFlight，除非下一步用户明确要求。
- 仍需真机生产包复测；license / notice 已完成用户人工确认和证据留档。

## 2. 阶段 2 完成摘要

阶段 2 已完成：

- 本地模型从 Debug 实验路径升级为生产候选能力。
- `qwen2.5-0.5b-instruct-q4_k_m.gguf` 放入 `DestinyScope/Resources/Models/`。
- `llama.xcframework` 放入 `DestinyScope/Frameworks/`。
- GGUF 和 `llama.xcframework` 通过 `.gitattributes` 指定走 Git LFS。
- `makeDefaultRefiner()` 调整为 `AutoLocalTextRefiner()`。
- 设备评分达标时默认启用本地润色，模拟器默认启用。
- iPhone 12 mini / `iPhone13,1` 等低分设备默认使用模板。
- 首页第一屏强化为生辰查询主路径。
- 结果页新增“本地润色版”展示，模板结果始终保留。
- App 内隐私政策、开源许可页面和 GitHub Pages 隐私页已补充生产候选本地模型说明。

## 3. Git LFS 与模型状态

执行命令：

```bash
git lfs ls-files
git status --short --ignored
git check-ignore -v DestinyScope/Resources/Models/qwen2.5-0.5b-instruct-q4_k_m.gguf
find . \( -iname "*.gguf" -o -iname "*.bin" -o -iname "*.safetensors" -o -iname "*.mlmodel" -o -iname "*.mlmodelc" -o -iname "*.xcframework" \)
shasum -a 256 DestinyScope/Resources/Models/qwen2.5-0.5b-instruct-q4_k_m.gguf
stat -f "%z bytes" DestinyScope/Resources/Models/qwen2.5-0.5b-instruct-q4_k_m.gguf
```

检查结果：

- GGUF 存在于仓库路径：`DestinyScope/Resources/Models/qwen2.5-0.5b-instruct-q4_k_m.gguf`。
- `git lfs ls-files` 已列出该 GGUF。
- `git check-ignore -v` 对指定 GGUF 无输出，说明该路径当前未被 ignore 规则挡住。
- GGUF 文件大小：`491400032 bytes`，约 `469 MiB`。
- GGUF sha256：`74a4da8c9fdbcd15bd1f6d01d621410d31c6fc00986f5eb687824e7b93d7a9db`。
- 仓库内模型 / framework 扫描仅发现：
  - `./DestinyScope/Resources/Models/qwen2.5-0.5b-instruct-q4_k_m.gguf`
  - `./DestinyScope/Frameworks/llama.xcframework`
- 未发现其他 `.bin`、`.safetensors`、`.mlmodel` 或 `.mlmodelc` 误入仓库。
- `llama.xcframework` 目录大小约 `612M`，内容已由 Git LFS 跟踪；仍需记录大文件和仓库体积风险。

## 4. Xcode 工程与 Bundle 资源状态

检查范围：

- `DestinyScope.xcodeproj/project.pbxproj`
- Release 构建产物
- `llama.xcframework/Info.plist`

检查结果：

- 工程使用 `PBXFileSystemSynchronizedRootGroup` 指向 `DestinyScope` 目录。
- `PBXResourcesBuildPhase` 传统 files 列表为空，但 Xcode 文件系统同步组会纳入资源；已通过实际 Release 产物确认 GGUF 被复制进 `.app`。
- Release 产物包含 GGUF：
  - `DestinyScope.app/qwen2.5-0.5b-instruct-q4_k_m.gguf`
- 注意：GGUF 在 `.app` 产物中被扁平化到 bundle 根目录，不是 `Resources/Models/` 子目录。
- 当前 `LocalModelFileResolver.bundledModelFileURL()` 会优先查找 bundle 根目录，因此运行时仍可找到该模型。
- Release 产物中 GGUF sha256 与仓库文件一致。
- Release 产物中 GGUF 文件头为 `GGUF`。
- Release 产物包含 `DestinyScope.app/Frameworks/llama.framework/llama`。
- `otool -L` 确认主 binary 依赖 `@rpath/llama.framework/llama`。
- Debug / Release 均配置了 iOS 真机和模拟器 slice 的 `FRAMEWORK_SEARCH_PATHS`。
- Release 链接日志包含 `-framework llama`。
- `LD_RUNPATH_SEARCH_PATHS` 包含 `@executable_path/Frameworks`。
- 未发现旧的 Debug-only `Embed llama.xcframework` run script phase 残留。

非阻断提示：

- 既有 `Metadata extraction skipped. No AppIntents.framework dependency found.` warning 仍存在。
- 既有 `IDERunDestination: Supported platforms for the buildables in the current scheme is empty.` 日志仍存在。
- 既有 `JoJoBuildVersion does not exist` 环境日志仍存在。

## 5. 构建检查

执行命令：

```bash
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Debug -destination 'generic/platform=iOS Simulator' build
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Release -destination 'generic/platform=iOS Simulator' build
```

构建结果：

- Debug build：通过。
- Release build：通过。
- 未发现 llama / model / bundle 相关阻断错误。
- 未发现签名或资源复制阻断错误。
- Release `.app` 体积约 `502M`。

## 6. 本地模型生产路径检查

代码检查结果：

- `TextRefinerFactory.makeDefaultRefiner()` 当前返回 `AutoLocalTextRefiner()`。
- `AutoLocalTextRefiner` 在不可用、未加载、超时或异常时回退 `TemplateTextRefiner`。
- `LocalLlamaTextRefiner` 使用 `LocalModelLoadingManager.shared.generate(...)` 走已加载 session。
- `LlamaCppSession` 使用 `#if canImport(llama)`，未被 `#if DEBUG` 阻止 Release 使用。
- `DestinyScopeApp` 启动后通过 `StartupTaskScheduler` 延迟约 2 秒后台调用 `LocalModelLoadingManager.shared.loadIfNeeded()`。
- 如果用户进入结果页早于后台加载完成，结果页本地润色会回退模板。该行为不阻断主流程，但属于体验风险。
- 强制模板 fallback 方法仍保留：`TextRefinerFactory.makeTemplateRefiner()`。

fallback 覆盖：

- 设备不达标：回退模板。
- 模型不存在：回退模板。
- 低电量模式：直接禁用本地润色。
- thermal serious / critical：直接禁用本地润色。
- framework 不可用：直接禁用本地润色。
- 生成超时：回退模板。
- 安全检查失败：返回模板 fallback。
- 生成异常：回退模板。

## 7. 设备评分检查

代码检查范围：

- `LocalModelDeviceScoringService`
- `DeviceTierService`
- `DeviceModelIdentifier`
- `ProductionLocalAIAvailability`

检查结果：

- 阈值：`score >= 75` 默认启用本地润色。
- Simulator：base score `100`，默认 eligible。
- iPhone 17 Pro Max / future high-end：按 `iPhone17...` 规则 base score `95`，默认 eligible。
- A17 Pro / A18 / A19 级别高端设备：可达到默认启用候选。
- iPhone 12 mini / `iPhone13,1`：base score `35`，默认模板。
- unknown 真机：保守禁用。
- lowPowerMode：直接禁用。
- thermal serious / critical：直接禁用。
- model missing：直接禁用。
- framework missing：直接禁用。
- 超时策略：
  - score >= 90 或 Tier A：3 秒。
  - 其他 eligible 设备：5 秒。
  - 不 eligible 设备：不运行本地润色。

真机说明：

- 本阶段没有运行真机生产包。
- iPhone 17 Pro Max 生产内置模型待复测。
- iPhone 12 mini 生产内置模型待复测。

## 8. 首页首屏检查

代码检查范围：

- `HomeView`
- `HomeHeroCard`
- `HomeInputCard`

检查结果：

- 首页顺序为 `HomeHeroCard` 后直接展示 `HomeInputCard`。
- `HomeInputCard` 包含出生日期、出生时辰、查询按钮和短隐私提示。
- Hero 已压缩为 `DestinyScope` 与 `东方命理 · 自我探索`。
- 长隐私说明压缩到输入卡片内短提示。
- 常用资料、最近历史和知识库入口后置。
- 不自动查询。
- 不请求网络。
- 常用资料和历史草稿只填入首页输入，不触发计算。

注意：

- 本阶段未启动模拟器做像素级首屏可见性验证。
- iPhone 12 mini 和 iPhone 17 Pro Max 首屏仍需人工 UI 复测。

## 9. 结果页本地润色检查

代码检查范围：

- `DestinyResultView`
- `ProductionLocalRefiningCard`
- `HomeView`
- `HistoryRecordStore`

检查结果：

- 模板结果始终保留。
- 本地润色版以“本地润色版”独立卡片展示。
- 文案包含：“设备端生成，只做表达润色，不改变命理结论。模板结果始终保留。”
- 未在结果页写“AI 算命”。
- 本地润色不覆盖原始模板文本。
- 本地润色不写入历史记录。
- 命理问答仍使用模板结果、模板解读和 `LifeWeightInsight`，不使用本地润色输出。
- 本地润色不改变 `LifeWeightResult`。
- 失败或未加载时回退模板。
- 不达标设备不会阻塞主流程。
- 模拟器在设备评分层面默认 eligible。

## 10. 隐私、开源许可和合规检查

检查范围：

- `DestinyScope/UI/Legal/PrivacyPolicyView.swift`
- `DestinyScope/UI/Legal/OpenSourceLicensesView.swift`
- `docs/privacy/index.html`
- `docs/privacy/privacy.md`

检查结果：

- App 内隐私政策说明内置本地模型作为生产候选能力。
- `docs/privacy/index.html` 已同步本地模型说明。
- `docs/privacy/privacy.md` 已同步本地模型说明。
- 隐私文案说明本地模型不上传模型输入、模型输出、出生信息、命理结果或历史记录。
- 隐私文案说明本地模型只做表达润色，不生成新的命理结论。
- 隐私文案说明当前不提供模型下载，不使用在线 AI。
- 开源许可页面包含：
  - `llama.cpp`
  - `ggml / GGUF`
  - `Qwen2.5-0.5B-Instruct / GGUF`
- 开源许可页面已记录 license / notice、具体文件来源、商业使用、再分发和 App 内分发状态；相关 license / notice 已由用户人工确认通过。

## 11. 静态扫描

执行命令：

```bash
rg -n "URLSession|OpenAI|StoreKit|CloudKit|ATTrackingManager|CLLocation|NSCameraUsageDescription|NSPhotoLibraryUsageDescription|NSMicrophoneUsageDescription|NSContactsUsageDescription" DestinyScope docs || true
rg -n "AI 算命|精准预测|改命|化解|避灾|必然发财|保证转运|疾病预测|寿命预测|投资收益确定|婚姻确定性|大师在线|付费改运" DestinyScope docs || true
rg -n "URLSession|OpenAI|StoreKit|CloudKit|ATTrackingManager|CLLocation|NSCameraUsageDescription|NSPhotoLibraryUsageDescription|NSMicrophoneUsageDescription|NSContactsUsageDescription" DestinyScope || true
rg -n "AI 算命|精准预测|改命|化解|避灾|必然发财|保证转运|疾病预测|寿命预测|投资收益确定|婚姻确定性|大师在线|付费改运" DestinyScope || true
```

扫描结果：

- `DestinyScope` Swift 源码未命中 `URLSession`、OpenAI、StoreKit、CloudKit、ATTrackingManager、CLLocation 或敏感权限 key。
- `DestinyScope docs` 的网络 / 支付 / 权限命中集中在历史报告和检查项说明，不是新增代码。
- 高风险词在 Swift 源码中集中于：
  - `TextRefiningSafetyRules`
  - `TextRefiningSafetyChecker`
  - `TextRefiningInput` prompt 约束
  - `LocalModelBenchmarkSuite`
  - `TextRefiningTestSuite`
- 上述高风险词命中属于安全规则、测试样例或禁止事项，不是用户可见营销文案。
- docs 中高风险词命中集中在禁止事项、风险清单、历史报告和扫描规则。
- 未发现需要本阶段修复的用户可见高风险营销文案。

## 12. 未解决问题

- Qwen2.5 GGUF 的具体文件来源、license、notice、商业使用、再分发和 App 内分发条件已由用户人工确认通过。
- 需要真实 Archive 后记录最终 IPA / App Store 分发体积和安装体积。
- 需要 iPhone 17 Pro Max 生产内置模型真机复测。
- 需要 iPhone 12 mini 生产内置模型真机复测。
- 需要确认真实真机环境下后台 preload 时机、耗时、内存、发热和低电量行为。
- 需要确认 App Store 元数据、截图和 Review Notes 是否同步 V1.8 生产候选边界。
- 需要确认 Git LFS hook / push 流程在提交和推送前可用。

## 13. 真机 / 模拟器记录

本阶段完成：

- Debug Simulator generic build：通过。
- Release Simulator generic build：通过。
- Release Simulator `.app` 产物检查：GGUF 和 `llama.framework` 均存在。

本阶段未完成：

- 未启动模拟器运行 App UI。
- 未在模拟器中验证结果页实际生成本地润色版。
- 未在真机中验证 Bundle 模型加载。
- 未在真机中验证结果页本地润色耗时和 fallback。

待复测：

- iPhone 17 Pro Max 生产内置模型。
- iPhone 12 mini 生产内置模型。
- 低电量模式。
- thermal serious / critical。
- 模型加载失败和超时路径。

## 14. Git 状态

阶段 1 检查结束时：

- `git status --short`：无输出，工作区无未提交变更。
- `git status --short --ignored` 仅显示已忽略项，包括 `.DS_Store`、Xcode workspace / userdata、`Pods/` 等。
