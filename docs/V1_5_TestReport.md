# DestinyScope V1.5 Test Report

## 1. V1.5 阶段完成情况

V1.5 已完成以下阶段：

- 阶段 1：产品体验优化目标与路线冻结。
- 阶段 2：source-control 与工程卫生修复。
- 阶段 3：UI / UX 全量审计。
- 阶段 4：结果页阅读体验优化。
- 阶段 5：知识库浏览体验优化。
- 阶段 6：历史记录体验优化。
- 阶段 7：设置 / 关于 / Legal / 开源许可体验优化。
- 阶段 9：可访问性、深色模式、小屏适配及 QA 检查规划。
- 阶段 10：V1.5 自测与下一步决策。

说明：

- V1.5 阶段 8 原计划为可访问性、深色模式、小屏适配代码优化，目前未执行 Swift 实现。
- 阶段 9 已先完成可访问性、深色模式、小屏适配和 QA 检查规划。
- 本阶段未修改 Swift 代码，未新增功能。

## 2. 构建结果

执行命令：

```bash
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Debug -destination 'generic/platform=iOS Simulator' build
```

结果：

- Debug build：通过。
- 既有非阻断提示：
  - `IDERunDestination: Supported platforms for the buildables in the current scheme is empty.`
  - `The domain/default pair of (com.bytedance.jojo, JoJoBuildVersion) does not exist`
  - `Metadata extraction skipped. No AppIntents.framework dependency found.`
  - `Run script build phase 'Embed Debug llama.xcframework' will be run during every build...`

执行命令：

```bash
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Release -destination 'generic/platform=iOS Simulator' build
```

结果：

- Release build：通过。
- Release 日志仍会调度名为 `Embed Debug llama.xcframework` 的脚本阶段，但脚本内容在 `CONFIGURATION != Debug` 时立即退出。
- llama framework search path 仅配置在 Debug build settings。
- 当前未发现 Release 默认路径调用本地模型。

## 3. 默认主流程检查

基于当前代码结构与构建结果，默认主流程状态如下：

- 首页仍负责出生日期和时辰输入。
- 查询成功后生成 `LifeWeightResult`、`FortuneInterpretation` 和 `LifeWeightInsight`。
- 结果页展示核心摘要、称骨诗文、权重明细、命格洞察、五类解读、命理问答和免责声明。
- 本地润色预览不默认替换结果页内容。
- 本地润色结果不写入历史记录。
- `makeDefaultRefiner()` 仍返回 `TemplateTextRefiner()`。

验证命令：

```bash
rg -n "makeDefaultRefiner|TemplateTextRefiner" DestinyScope/Domain/TextRefining/TextRefinerFactory.swift
```

结果：

- `makeDefaultRefiner()` 返回 `TemplateTextRefiner()`。
- 实验 refiner 仍只通过独立实验入口调用。

待人工验证：

- 首页实际点击查询。
- 结果页长滚动体感。
- 命理问答按钮点击。
- 本地润色预览在实验条件不满足时不展示。

## 4. 结果页检查

V1.5 阶段 4 已完成结果页阅读体验优化：

- 顶部核心摘要已独立展示。
- 称骨诗文独立展示。
- 权重明细已改为更紧凑卡片。
- 命格洞察和 tags 已优化展示。
- 五类解读使用独立卡片和折叠结构。
- 命理问答逻辑未改变。
- 本地润色预览仍靠后展示，且仍受实验条件控制。
- 底部安全提示仍保留。

未发现：

- 称骨计算规则变更。
- 默认输出路径变更。
- 本地模型自动替换结果页文本。

待人工验证：

- iPhone SE / mini 小屏下权重卡、tags、折叠区是否拥挤。
- Dynamic Type 下长标题和按钮是否截断。
- 深色模式下朱砂红和暗金对比度。

## 5. 知识库检查

执行检查：

```bash
python3 - <<'PY'
import json, pathlib
p=pathlib.Path('DestinyScope/Resources/Knowledge/knowledge_articles.json')
data=json.loads(p.read_text())
print(len(data))
PY
```

结果：

- `knowledge_articles.json` 文章数量：29。
- 必填字段检查未发现缺失字段。
- 分类包括：称骨算命、使用边界、农历时辰、天干地支、生肖、五行、八卦周易、梅花易数。

V1.5 阶段 5 已完成：

- 知识库列表增加动态分类筛选。
- 第一个分类为“全部”。
- 分类文章数量可显示。
- 本地搜索覆盖 title / summary / category / tags / body。
- 搜索无结果有友好空状态。
- 详情页长文按段落展示。
- source / version 放到底部弱化展示。

未发现：

- `knowledge_articles.json` 内容变更。
- 网络请求。
- RAG 或服务端接入。

待人工验证：

- 29 篇文章在真机上可加载。
- 分类数量显示是否符合当前筛选。
- 小屏和 Dynamic Type 下 chips / 搜索框是否拥挤。

## 6. 历史记录检查

V1.5 阶段 6 已完成：

- 历史列表顶部显示“历史记录仅本地保存”说明。
- 历史列表卡片展示标题、创建时间、出生日期和时辰、农历生日、总重量和 tags。
- 新增历史详情页。
- 详情页只展示 `HistoryRecord` 已保存字段。
- 删除单条需要确认。
- 清空全部需要确认。
- 空状态说明历史记录仅本地保存，不上传或同步。

边界确认：

- 不重新调用 `LifeWeightEngine`。
- 不重新调用 `TemplateFortuneInterpreter`。
- 不重新生成 `LifeWeightInsight`。
- 不调用本地模型。
- 不把本地模型润色结果写入历史记录。
- 不做 iCloud 同步、账号登录或网络上传。

待人工验证：

- 成功查询后历史记录新增。
- 删除 / 清空确认弹窗行为。
- 小屏、深色模式、VoiceOver 下删除入口和确认文案。

## 7. 设置 / 关于 / Legal 检查

V1.5 阶段 7 已完成：

- 设置页按应用信息、隐私与安全、实验功能分区。
- 关于页拆分为 App 定位、当前能力、使用边界和法律与隐私入口。
- 隐私政策增加摘要，并按账号、出生信息、本地历史记录、本地模型实验、网络、权限、广告分析、本地资源、未来变更和联系方式分区。
- 免责声明增加摘要，并按传统文化、自我探索、非专业建议、健康、财务、婚恋、本地润色和重大决策分区。
- 开源许可页面包含 llama.cpp、ggml/GGUF、Qwen2.5 条目。

合规边界：

- 隐私政策区分当前正式功能和本地模型实验功能。
- 隐私政策说明历史记录仅本地保存。
- 隐私政策说明本地模型实验默认关闭、设备端运行、不上传模型输入输出。
- 开源许可页面保留人工复核提示。

待人工验证：

- App 内隐私政策与 GitHub Pages 隐私页是否需要进一步同步。
- Legal 长文在深色模式、Dynamic Type、VoiceOver 下可读性。

## 8. 本地模型实验路径检查

当前策略：

- 实验开关默认关闭。
- 未接受说明不能开启。
- 开启状态保存到 UserDefaults。
- 设备 tier 检测已实现。
- iPhone 12 mini / `iPhone13,1` 归入 Tier C 或默认禁用。
- unknown 默认禁用。
- Simulator 仅 Debug 测试。
- 模型文件状态可检测。
- App Documents 路径优先。
- Developer LocalModels fallback 可用于 Debug / Simulator。
- `.gguf` 导入只复制到 App Documents。
- 结果页本地润色预览卡片只在条件满足时展示。
- 用户手动点击后才调用模型。
- 原始文本始终保留。
- 润色结果不覆盖原文。
- 润色结果不写入历史记录。
- 低电量模式回退。
- thermal serious / critical 回退。
- Tier A 3 秒超时。
- Tier B 5 秒超时。
- Tier C 不启用。
- 连续失败后临时回退。
- 安全检查失败回退。

静态检查：

- `SettingsView` 中实验入口仍在 `#if DEBUG` 下。
- `LocalLlamaTextRefiner` / `LlamaCppSession` 仍在 DEBUG 路径中。
- `TextRefinerFactory.makeDefaultRefiner()` 未改变。

注意：

- Release build 日志仍会出现 `Embed Debug llama.xcframework` 脚本阶段，但脚本在非 Debug 配置下立即退出。
- 建议未来工程卫生阶段将该脚本的 dependency analysis / naming 进一步清理，降低 Release 日志混淆。

## 9. Accessibility / Dark Mode / Small Screen 状态

已完成规划文档：

- `docs/V1_5_AccessibilityDarkModeSmallScreenPlan.md`
- `docs/V1_5_QAChecklist.md`
- `docs/V1_5_DeviceTestMatrix.md`

当前状态：

- VoiceOver 焦点顺序：待人工验证。
- 关键按钮 label / hint：待人工验证。
- Dynamic Type 默认 / Large / Extra Large / Accessibility Large：待人工验证。
- 深色模式背景、卡片、文字、tag、按钮、错误提示：待人工验证。
- iPhone SE / mini 小屏：待人工验证。
- iPhone 17 Pro Max：待人工验证。
- iPad：待人工验证。
- Legal 长文可读性：待人工验证。
- 开源许可长 URL 换行：待人工验证。

本报告不伪造人工通过结果。上述项目应在 V1.6 或下一轮 QA 中执行。

## 10. 静态扫描结果

执行：

```bash
git status --short --ignored
```

结果：

- 只显示常规 ignored 项，例如 `.DS_Store`、`Pods/`、workspace 用户数据。
- 本阶段后新增 / 修改项为 docs 文档。

执行：

```bash
git check-ignore -v DestinyScope/Domain/Models/OpenSourceLicenseItem.swift || true
find DestinyScope/Domain/Models -name "*.swift" -print0 | xargs -0 -I{} sh -c 'git check-ignore -v "{}" || true'
```

结果：

- `OpenSourceLicenseItem.swift` 未被忽略。
- `DestinyScope/Domain/Models/*.swift` 未被忽略。

执行：

```bash
find . -iname "*.gguf" -o -iname "*.bin" -o -iname "*.safetensors" -o -iname "*.mlmodel" -o -iname "*.mlmodelc" -o -iname "*.xcframework"
```

结果：

- 仓库内未发现模型文件或 `xcframework`。

执行：

```bash
rg -n "URLSession|OpenAI|StoreKit|CloudKit|ATTrackingManager|CLLocation|NSCameraUsageDescription|NSPhotoLibraryUsageDescription|NSMicrophoneUsageDescription|NSContactsUsageDescription" DestinyScope docs || true
```

结果：

- `DestinyScope` Swift 源码未命中新增网络、在线 AI、StoreKit、CloudKit、追踪或敏感权限申请。
- docs 命中均为既有 checklist / report 中的扫描命令或风险说明。

执行：

```bash
rg -n "精准预测|改命|化解|避灾|必然发财|保证转运|疾病预测|寿命预测|投资收益确定|婚姻确定性|AI 算命|大师在线|付费改运" DestinyScope docs || true
```

结果：

- `DestinyScope` 命中集中在：
  - `TextRefiningSafetyRules` / `TextRefiningSafetyChecker` 的禁止词规则。
  - `TextRefiningTestSuite` / `LocalModelBenchmarkSuite` 的高风险测试样例。
  - `TextRefiningInput` 的默认安全规则。
- docs 命中集中在禁止事项、风险说明、审核文案限制和历史 PoC 结果。
- 未发现这些词作为 App 营销承诺或默认结果页宣传使用。

## 11. 未解决问题

P0 / P1 待办：

- Accessibility / Dynamic Type / Dark Mode / 小屏 / iPad 仍待人工验证。
- Release 构建日志仍会显示 Debug llama embed 脚本被调度，虽然脚本在 Release 下 no-op。建议未来清理脚本名称或构建阶段条件，降低误解。
- GitHub Pages 隐私页与 App 内隐私页上架前仍需人工复核一致性。
- License / notice 仍需人工最终确认，尤其是模型或 framework 进入 TestFlight / App Store 分发前。
- App Icon 原创 / 授权仍需人工确认。
- Apple Developer Program、Bundle ID、Signing、Version、Build、Archive 均未进入上传准备。

## 12. 人工验证待办

建议下一轮人工 QA 覆盖：

- 首页查询完整流程。
- 结果页长滚动、折叠、命理问答。
- 知识库分类、搜索、详情。
- 历史记录新增、详情、删除、清空。
- 设置 / 关于 / 隐私政策 / 免责声明 / 开源许可。
- Release 构建不展示本地模型实验入口。
- iPhone SE / iPhone 12 mini / iPhone 17 Pro Max / iPad。
- 深色模式。
- VoiceOver。
- Dynamic Type Accessibility Large。
- 飞行模式。

