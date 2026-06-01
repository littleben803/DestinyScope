# DestinyScope V1.6 Test Report

检查日期：2026-06-02

本报告覆盖 V1.6 阶段 1 到阶段 9。V1.6 聚焦产品功能打磨：Onboarding、常用出生资料、结果复制 / 分享、知识库收藏 / 最近阅读、历史收藏 / 置顶 / 快速复查、首页信息架构和本地数据管理。本阶段未新增服务端、网络请求、在线 AI、付费订阅、模型下载或默认本地模型路径。

## 1. V1.6 阶段完成情况

| 阶段 | 结论 |
|---|---|
| 阶段 1：产品功能打磨目标与路线冻结 | 已完成 |
| 阶段 2：首次使用说明 / Onboarding | 已完成 |
| 阶段 3：常用出生资料 / 本地 Profile | 已完成 |
| 阶段 4：结果页复制与纯文本分享文案 | 已完成 |
| 阶段 5：知识库收藏与最近阅读 | 已完成 |
| 阶段 6：历史记录收藏 / 置顶 / 快速复查 | 已完成 |
| 阶段 7：首页信息架构优化 | 已完成 |
| 阶段 8：本地数据管理入口 | 已完成 |
| 阶段 9：V1.6 自测与下一步决策 | 本报告完成 |

## 2. 构建检查

执行命令：

```bash
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Debug -destination 'generic/platform=iOS Simulator' build
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Release -destination 'generic/platform=iOS Simulator' build
```

结果：

- Debug build：通过。
- Release build：通过。
- 未发现新增阻断性 error。
- 仍出现既有非阻断提示：
  - `IDERunDestination: Supported platforms for the buildables in the current scheme is empty.`
  - `The domain/default pair of (com.bytedance.jojo, JoJoBuildVersion) does not exist`
  - `Run script build phase 'Embed Debug llama.xcframework' will be run during every build...`

结论：当前 Debug / Release 模拟器构建可通过；上述提示延续自既有环境和脚本配置，本阶段未修改工程配置。

## 3. 默认主流程检查

代码和构建检查结论：

- 首页仍由用户选择出生日期和时辰。
- 查询仍需要用户手动点击，不会因为 Onboarding、Profile、历史草稿或首页摘要自动触发。
- 查询成功后仍生成 `LifeWeightResult`、`FortuneInterpretation` 和 `LifeWeightInsight`。
- 结果页仍展示核心摘要、称骨诗文、权重明细、命格洞察、五类解读、命理问答、复制分享卡片、本地润色预览实验卡片和免责声明。
- 本地润色预览仍是受控实验路径，不会默认替换结果页文本。
- 本地润色结果不写入历史记录，不参与分享摘要默认内容。
- `TextRefinerFactory.makeDefaultRefiner()` 仍返回 `TemplateTextRefiner()`。

待人工验证：

- 真机完整点击：首页输入、查询、结果页滚动、命理问答、复制 / 分享、返回。
- 小屏和深色模式下结果页长文可读性。

## 4. Onboarding 检查

当前状态：

- 首次使用说明已加入。
- `OnboardingStateStore` 使用 `UserDefaults` key `hasCompletedOnboarding` 保存完成状态。
- 首次启动自动展示，完成后不再自动展示。
- 设置页和关于页可再次打开使用说明。
- Onboarding 不保存出生信息、不请求网络、不宣传本地模型能力。

待人工验证：

- 首次启动展示。
- 点击“开始使用”后不再自动展示。
- 设置 / 关于入口可再次打开。
- Dynamic Type 和 VoiceOver 基础可用。

## 5. 常用出生资料检查

当前状态：

- `SavedBirthProfile` 字段包括 `id`、`displayName`、`birthDate`、`hour`、`createdAt`、`updatedAt`。
- `SavedBirthProfileStore` 使用 Application Support 下 `DestinyScope/saved_birth_profiles.json` 保存。
- 最多保留 20 条，按更新时间倒序。
- 首页可保存当前出生日期和时辰，也可选择常用资料填入输入。
- 选择常用资料只填入输入，不自动查询、不保存历史、不重新计算。
- 设置页可管理常用出生资料，支持删除单条和清空全部。
- App 内隐私政策和 GitHub Pages 隐私页已说明常用出生资料仅本地保存、不上传、不同步、可删除。

待人工验证：

- 保存、选择填入、删除、清空全部。
- displayName 为空时默认名是否符合预期。
- 小屏下列表和保存 sheet 不截断。

## 6. 结果复制与分享检查

当前状态：

- 结果页已加入“复制与分享”卡片。
- `ResultShareTextBuilder` 生成纯文本摘要。
- 分享文本包含 App 名称、命格标题、总重量、称骨诗文、简要解读、行动建议和安全提示。
- 默认不包含完整公历出生日期、完整农历生日、具体出生时辰、常用出生资料显示名、历史记录信息或本地模型润色结果。
- 复制仅在用户点击时写入剪贴板，不读取剪贴板。
- 分享使用系统 `ShareLink`，不保存分享记录、不上传、不请求网络。

待人工验证：

- 剪贴板内容和系统分享面板实际展示。
- 分享摘要包含安全提示。
- 分享摘要不包含完整出生信息。

## 7. 知识库检查

执行检查：

```bash
python3 - <<'PY'
import json
from pathlib import Path
for p in ['DestinyScope/Resources/Knowledge/knowledge_articles.json','DestinyScope/Resources/Knowledge/rag_chunks.json']:
    data=json.loads(Path(p).read_text())
    print(f'{p}: {len(data)}')
PY
```

结果：

- `knowledge_articles.json`：29 篇。
- `rag_chunks.json`：29 条。

当前状态：

- 知识库列表使用本地文章数组做分类筛选和搜索。
- 分类来自文章 `category` 去重生成，包含“全部”和“收藏”。
- 搜索覆盖 title、summary、category、tags 和 body。
- 收藏只保存 article id，最多 100 个。
- 最近阅读只保存 article id 和 viewedAt，最多 20 条。
- 收藏 / 最近阅读保存在 Application Support 下 `DestinyScope/knowledge_library_state.json`。
- 详情页展示 title、category、summary、body、tags、source/version。
- 未修改 `knowledge_articles.json` 内容，未修改 `KnowledgeRepository` 读取逻辑。
- 无网络请求、无服务端、无 RAG。

待人工验证：

- 分类数量、搜索结果、空状态。
- 收藏 / 取消收藏、最近阅读排序、清空收藏、清空最近阅读。
- 长文、小屏、深色模式、长 source URL。

## 8. 历史记录检查

当前状态：

- 查询成功后保存轻量历史记录。
- 历史记录仍由 `HistoryRecordStore` 本地 JSON 保存，最多 50 条。
- 历史列表顶部说明历史记录仅保存在本设备，不上传、不同步。
- 历史详情页只展示 `HistoryRecord` 已保存字段，不重新计算、不调用模板解读、不调用本地模型。
- 删除单条和清空全部均有确认。
- 历史收藏 / 置顶状态只保存 `HistoryRecord.id` 集合和 `updatedAt`。
- 快速复查使用内存态 `HomeInputDraft`，只把出生日期和时辰填回首页，不自动查询、不保存历史、不重新计算。
- 删除历史时会清理对应收藏 / 置顶状态。
- 本地模型润色结果不写入历史记录。

待人工验证：

- 新增历史、详情页、收藏、置顶、取消、删除、清空。
- 快速复查填回首页后不自动查询。
- 空状态和错误状态。

## 9. 首页信息架构检查

当前状态：

- 首页已拆分为定位说明、本地隐私提示、历史草稿提示、常用资料、查询输入卡片、最近历史摘要和知识库入口提示。
- HomeHeroCard 说明 App 定位，不含高风险营销词。
- HomePrivacyNoticeCard 说明出生日期和时辰仅用于本机计算，不需要账号、不上传。
- HomeInputDraftBanner 只在历史详情填入首页后提示，不自动查询。
- HomeInputCard 集中展示出生日期、时辰、查询按钮、保存当前资料和错误提示。
- HomeRecentHistoryCard 只读取最近 1 条本地轻量历史摘要，不重新计算、不自动填入。
- HomeKnowledgeEntryCard 只做知识库学习提示，不请求网络。

待人工验证：

- 首页小屏滚动和输入控件可操作。
- 常用资料和历史草稿填入后必须手动点击查询。
- 最近历史和知识库提示不喧宾夺主。

## 10. 本地数据管理检查

当前状态：

- 设置页已有“本地数据管理”入口。
- `LocalDataManagementService` 汇总历史记录、常用出生资料、知识库收藏、最近阅读、历史收藏、历史置顶和首次使用说明状态。
- 支持清空历史记录、历史收藏 / 置顶、常用出生资料、知识库收藏、知识库最近阅读、首次使用说明状态，以及清空全部本地用户数据。
- 每个清理操作均需要确认。
- 清空全部本地用户数据不删除内置知识库、称骨数据、App 内置资源、`.gguf` 模型文件或 `llama.xcframework`。
- 不上传、不同步、不请求网络、不接账号。

待人工验证：

- 各类清理操作的确认弹窗、清理结果和 UI 刷新。
- 清空全部后默认主流程仍可查询。

## 11. 设置 / Legal 检查

当前状态：

- 设置页分为应用信息、隐私与安全、实验功能、本地数据等层级。
- 关于页展示 App 定位、当前能力、使用边界和 Legal 入口。
- 隐私政策可打开，并区分当前正式功能和本地模型实验功能。
- 隐私政策说明本地历史记录、常用出生资料、知识库收藏、最近阅读和本地数据管理均仅本地保存。
- 免责声明可打开，说明内容仅供娱乐、自我探索和传统文化学习参考，不构成现实决策建议。
- 开源许可页面可打开，包含 llama.cpp、ggml/GGUF、Qwen2.5-0.5B-Instruct / GGUF。
- GitHub Pages 隐私页文件已同步更新到本地 `docs/privacy/index.html` 和 `docs/privacy/privacy.md`。

待人工验证：

- 公网隐私页 `https://littleben803.github.io/DestinyScope/privacy/` 是否已发布且无 404。
- App 内隐私页和公网隐私页最终人工一致性复核。
- Legal 长文在 Dynamic Type 和 VoiceOver 下阅读顺序。

## 12. 本地模型实验路径检查

当前状态：

- 实验开关默认关闭。
- 未接受实验说明不能开启。
- 设备 tier 检测存在，`iPhone13,1` / iPhone 12 mini 属于 Tier C 或默认禁用，unknown 默认禁用。
- Simulator 仅作为 Debug 测试，不代表真机性能。
- 模型文件状态可检测，App Documents 路径优先，Simulator / Debug 可 fallback 到 Developer LocalModels。
- `.gguf` 导入只复制到 App Documents，不下载、不上传、不写入 Bundle。
- 结果页本地润色预览卡片只在条件满足时展示。
- 用户手动点击后才调用模型。
- 原始文本始终保留，润色结果不覆盖原文、不写历史记录。
- 低电量、thermal serious / critical、超时、连续失败和安全检查失败均有回退设计。
- Release 不应展示本地模型实验入口。
- `makeDefaultRefiner()` 仍返回 `TemplateTextRefiner()`。

待人工验证：

- 真机 Tier A / Tier C 行为。
- 低电量、过热、超时、连续失败和安全失败实际 UI。
- Release 安装包中实验入口隐藏。

## 13. Accessibility / Dark Mode / Small Screen

本阶段未做完整人工验收。以下项目标记为待人工验证：

- VoiceOver 焦点顺序。
- 关键按钮 label / hint。
- Dynamic Type：默认、Large、Extra Large、Accessibility Large。
- 深色模式下背景、卡片、文字、tag、按钮、错误提示可读性。
- iPhone SE / mini 小屏适配。
- iPhone 17 Pro Max 宽屏阅读体验。
- iPad 留白和长文宽度。
- Legal 长文可读性。
- 开源许可长 URL 不撑破布局。

## 14. 静态扫描结果

执行命令：

```bash
git status --short --ignored
git check-ignore -v DestinyScope/Domain/Models/OpenSourceLicenseItem.swift || true
find DestinyScope/Domain/Models -name "*.swift" -print0 | xargs -0 -I{} sh -c 'git check-ignore -v "{}" || true'
find . -iname "*.gguf" -o -iname "*.bin" -o -iname "*.safetensors" -o -iname "*.mlmodel" -o -iname "*.mlmodelc" -o -iname "*.xcframework"
rg -n "URLSession|OpenAI|StoreKit|CloudKit|ATTrackingManager|CLLocation|NSCameraUsageDescription|NSPhotoLibraryUsageDescription|NSMicrophoneUsageDescription|NSContactsUsageDescription" DestinyScope docs || true
rg -n "精准预测|改命|化解|避灾|必然发财|保证转运|疾病预测|寿命预测|投资收益确定|婚姻确定性|AI 算命|大师在线|付费改运" DestinyScope docs || true
```

结果：

- `git status --short --ignored` 仅显示 `.DS_Store`、Xcode workspace/userdata、Pods 等忽略项。
- `OpenSourceLicenseItem.swift` 未被 `.gitignore` 命中。
- `DestinyScope/Domain/Models/*.swift` 未被 `.gitignore` 命中。
- 仓库内未发现 `.gguf`、`.bin`、`.safetensors`、`.mlmodel`、`.mlmodelc` 或 `.xcframework`。
- Swift 源码未命中 `URLSession`、OpenAI、StoreKit、CloudKit、ATTrackingManager、CLLocation 或敏感权限 key。
- Swift 源码中的 `https://` 命中仅为开源许可页面展示的文本 URL，不是网络请求。
- 高风险词命中出现在安全规则、SafetyChecker、Debug benchmark / test suite 的高风险测试样例，以及文档中的禁止事项说明；未发现作为产品宣传或默认用户承诺使用。

## 15. 未解决问题

- Accessibility、Dynamic Type、深色模式、小屏、iPad 和 VoiceOver 仍需要人工验收。
- GitHub Pages 隐私页公网 URL 仍需人工访问确认。
- App Icon 授权、license / notice、Bundle ID / Signing / Version / Build、Release Archive 仍属于上架前人工项。
- 当前仍不准备上传 TestFlight，也不准备 App Store 上架。

## 16. 本阶段结论

- Debug build：通过。
- Release build：通过。
- V1.6 产品功能打磨已完成本地实现和文档闭环。
- 默认主流程仍不依赖本地模型。
- 本地模型实验仍受控、默认关闭、失败回退。
- 新增本地数据均保持设备端保存，不上传、不同步、不登录。
- 未发现模型文件、framework、网络请求、支付、追踪或敏感权限进入仓库。
