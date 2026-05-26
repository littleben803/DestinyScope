# DestinyScope V1 路线图

## 1. 执行原则

- 本路线图用于后续实现阶段。
- 每个阶段都应小步修改，保证每一步可编译。
- 不加服务端。
- 不接在线 AI。
- 不写真实本地 LLM 推理。
- 不新增第三方依赖。
- 不做与阶段目标无关的大规模重构。
- 涉及删除文件、移动大量文件、提交代码、推送代码时必须等待用户明确授权。

## 2. 阶段 3：抽离 LifeWeightEngine，保持现有 UI 不变

### 阶段目标

把 `MainContentView.calculateLifeWeight()` 中的核心称骨计算逻辑抽离到 `LifeWeightEngine`，但保持当前页面视觉和交互基本不变。

### 允许修改的文件范围

- `DestinyScope/UI/MainContentView.swift`
- `DestinyScope/Model/LifeWeightModel.swift`
- 可新增 `DestinyScope/Domain/Engine/LifeWeightEngine.swift`
- 可新增 `DestinyScope/Domain/Models/BirthProfile.swift`

### 不允许做的事

- 不重做 UI。
- 不移动现有 CSV。
- 不改工程配置。
- 不新增依赖。
- 不新增服务端或 AI 接口。

### Codex 执行 Prompt 草案

```text
请只完成阶段 3：抽离 LifeWeightEngine，保持现有 UI 不变。
将 MainContentView.calculateLifeWeight() 中的权重累加和诗文匹配逻辑迁移到新的 LifeWeightEngine。
MainContentView 只负责读取输入、调用 Engine、展示结果。
不要重做 UI，不要移动文件，不要新增依赖，不要接 AI 或服务端。
完成后运行本地可用的编译或静态检查命令。
```

### 验收标准

- 当前输入和查询流程仍可使用。
- `MainContentView` 不再直接负责权重累加和诗文匹配。
- `LifeWeightEngine` 不依赖 SwiftUI。
- 没有新增第三方库。

### 建议 commit message

```text
refactor: extract life weight engine
```

## 3. 阶段 4：拆分 CSV 加载和 Repository

### 阶段目标

把 CSV 加载、解析、查询从 `DataManager` 中拆出，建立 `LifeWeightRepository` 和数据加载服务。

### 允许修改的文件范围

- `DestinyScope/Bizs/DataManager.swift`
- `DestinyScope/Domain/Engine/LifeWeightEngine.swift`
- 可新增 `DestinyScope/Services/DataLoading/CSVLoader.swift`
- 可新增 `DestinyScope/Services/DataLoading/BundleResourceLoader.swift`
- 可新增 `DestinyScope/Domain/Engine/LifeWeightRepository.swift`

### 不允许做的事

- 不迁移 CSV 文件位置。
- 不改 CSV 内容。
- 不改 UI 视觉。
- 不新增依赖。
- 不引入数据库。

### Codex 执行 Prompt 草案

```text
请只完成阶段 4：拆分 CSV 加载和 Repository。
保留现有 CSV 文件位置和内容。
从 DataManager 中抽出 CSVLoader、BundleResourceLoader 和 LifeWeightRepository。
LifeWeightEngine 通过 Repository 查询年、月、日、时和诗文数据。
不要重做 UI，不要新增依赖，不要移动 CSV。
```

### 验收标准

- CSV 文件仍从 Bundle 本地读取。
- Repository 负责业务查询。
- DataManager 职责减少或仅作为兼容入口。
- 查询结果与阶段 3 保持一致。

### 建议 commit message

```text
refactor: split csv loading and repository
```

## 4. 阶段 5：新增 LifeWeightResult 和错误处理

### 阶段目标

新增结构化 `LifeWeightResult`，并建立明确错误处理，避免数据缺失时静默生成错误结果。

### 允许修改的文件范围

- `DestinyScope/Domain/Models/*`
- `DestinyScope/Domain/Engine/LifeWeightEngine.swift`
- `DestinyScope/Domain/Engine/LifeWeightRepository.swift`
- `DestinyScope/UI/MainContentView.swift`

### 不允许做的事

- 不新增结果页。
- 不重做导航。
- 不改知识库。
- 不接 AI。
- 不引入第三方错误处理库。

### Codex 执行 Prompt 草案

```text
请只完成阶段 5：新增 LifeWeightResult 和错误处理。
定义 LifeWeightResult、LifeWeightBreakdown、LunarBirthDate 等结构化模型。
当 CSV 缺失、日期转换失败、权重匹配失败或诗文匹配失败时返回明确错误。
MainContentView 显示简短错误文案。
不要重做页面结构，不要新增依赖。
```

### 验收标准

- 成功结果包含农历生日、时辰、权重明细、总重量、标题、诗文。
- 缺失数据不会继续展示部分错误结果。
- UI 能显示可理解的失败提示。
- 现有成功查询结果不变或只在展示结构上更清晰。

### 建议 commit message

```text
feat: add structured life weight result
```

## 5. 阶段 6：新增 TemplateFortuneInterpreter

### 阶段目标

新增本地模板式命理师解释器，基于 `LifeWeightResult` 生成总评、性格、事业、财运、关系五类解读。

### 允许修改的文件范围

- `DestinyScope/Domain/Interpreter/*`
- `DestinyScope/Domain/Models/*`
- `DestinyScope/UI/MainContentView.swift`
- 可新增 `DestinyScope/Resources/Templates/*`

### 不允许做的事

- 不接在线 AI。
- 不写真实本地 LLM 推理。
- 不请求网络。
- 不生成健康、寿命、疾病预测。
- 不生成投资确定性建议。
- 不生成婚姻绝对判断。
- 不输出恐吓式大凶化解内容。

### Codex 执行 Prompt 草案

```text
请只完成阶段 6：新增 TemplateFortuneInterpreter。
定义 FortuneInterpreting 协议和 TemplateFortuneInterpreter 默认实现。
基于 LifeWeightResult 生成总评、性格、事业、财运、关系五类本地模板解读。
文案必须使用“倾向、参考、建议、自我探索”等表达，并包含娱乐和传统文化参考提示。
不要接在线 AI，不要写本地 LLM，不要请求网络。
```

### 验收标准

- 查询成功后可以看到五类解读。
- 解读由本地模板生成。
- 输出包含免责声明短提示。
- 输出不包含恐吓式、绝对化或高风险建议。

### 建议 commit message

```text
feat: add template fortune interpreter
```

## 6. 阶段 7：新增本地 Knowledge JSON 和 KnowledgeRepository

### 阶段目标

新增本地知识库 JSON 和 `KnowledgeRepository`，为知识库列表和详情页提供数据。

### 允许修改的文件范围

- `DestinyScope/Domain/Knowledge/*`
- `DestinyScope/Services/DataLoading/JSONResourceLoader.swift`
- `DestinyScope/Resources/Knowledge/*`
- 可新增 `DestinyScope/Domain/Models/KnowledgeArticle.swift`

### 不允许做的事

- 不做远程知识库。
- 不接 CMS。
- 不改主 UI 导航。
- 不引入第三方 JSON 库。
- 不复制来源不明的大段网络内容。

### Codex 执行 Prompt 草案

```text
请只完成阶段 7：新增本地 Knowledge JSON 和 KnowledgeRepository。
创建 KnowledgeArticle 模型、JSONResourceLoader 和 KnowledgeRepository。
新增少量本地 JSON 示例文章，覆盖称骨算命、农历时辰、生肖、五行、免责声明。
不要接远程服务，不要引入第三方库，不要重做 UI 导航。
```

### 验收标准

- 本地 JSON 能成功加载。
- Repository 能返回文章列表。
- Repository 能按 id 返回详情。
- 知识库加载失败有错误。

### 建议 commit message

```text
feat: add local knowledge repository
```

## 7. 阶段 8：重做 SwiftUI 页面结构和导航

### 阶段目标

把当前单页 Demo 改造成 V1 页面结构：输入页、结果页、知识库列表页、知识库详情页、设置/关于入口。

### 允许修改的文件范围

- `DestinyScope/UI/*`
- `DestinyScope/Domain/Models/*`
- `DestinyScope/Domain/Interpreter/*`
- `DestinyScope/Domain/Knowledge/*`
- `DestinyScope/DestinyScopeApp.swift`

### 不允许做的事

- 不改核心计算规则。
- 不改 CSV 数据。
- 不新增依赖。
- 不做分享图片。
- 不做历史记录。
- 不做付费订阅。

### Codex 执行 Prompt 草案

```text
请只完成阶段 8：重做 SwiftUI 页面结构和导航。
建立首页/输入页、结果页、知识库列表页、知识库详情页、设置/关于入口。
接入已有 LifeWeightEngine、TemplateFortuneInterpreter 和 KnowledgeRepository。
不要改核心计算规则，不要改 CSV 数据，不要新增依赖。
```

### 验收标准

- App 有清晰主导航。
- 输入页能进入结果页。
- 结果页展示称骨结果和命理师解读。
- 知识库列表能进入详情。
- 设置或关于入口可访问。

### 建议 commit message

```text
feat: add v1 navigation and screens
```

## 8. 阶段 9：新增 Theme / DesignSystem

### 阶段目标

新增基础传统命理风格 DesignSystem，统一颜色、字号、圆角、间距和卡片样式，支持深色模式。

### 允许修改的文件范围

- `DestinyScope/UI/Theme/*`
- `DestinyScope/UI/Components/*`
- `DestinyScope/UI/Home/*`
- `DestinyScope/UI/Result/*`
- `DestinyScope/UI/Knowledge/*`
- `DestinyScope/UI/Settings/*`
- `DestinyScope/UI/Legal/*`
- `DestinyScope/Assets.xcassets/AccentColor.colorset`

### 不允许做的事

- 不生成图片。
- 不改 App Icon。
- 不改计算逻辑。
- 不新增第三方 UI 库。
- 不做营销落地页。

### Codex 执行 Prompt 草案

```text
请只完成阶段 9：新增 Theme / DesignSystem。
创建 AppTheme 或 DesignSystem，统一颜色、字号、圆角、间距和卡片样式。
替换明显的硬编码调试颜色和临时 UI 样式，支持深色模式。
不要生成图片，不要改 App Icon，不要改计算逻辑，不要新增 UI 库。
```

### 验收标准

- 不再使用调试红色整屏背景。
- 核心页面颜色和间距来自 Theme。
- 深色模式文字可读。
- 小屏和常规 iPhone 页面不明显截断。

### 建议 commit message

```text
style: add v1 design system
```

## 9. 阶段 10：新增 Legal 页面，隐私政策和免责声明

### 阶段目标

新增隐私政策页和免责声明页，并在关于页或设置页提供入口。

### 允许修改的文件范围

- `DestinyScope/UI/Legal/*`
- `DestinyScope/UI/Settings/*`
- `DestinyScope/UI/Components/*`
- `DestinyScope/Domain/Models/AppDisclaimer.swift`

### 不允许做的事

- 不引入法律文档生成服务。
- 不接远程配置。
- 不上传用户数据。
- 不新增权限申请。
- 不修改计算逻辑。

### Codex 执行 Prompt 草案

```text
请只完成阶段 10：新增 Legal 页面。
创建隐私政策页和免责声明页，并从关于页或设置页进入。
隐私政策说明 V1 无服务端、无登录、出生信息不上传、本地处理。
免责声明说明结果仅供娱乐和传统文化参考，不构成医疗、法律、财务、婚恋或职业建议。
不要新增权限，不要接远程配置，不要修改计算逻辑。
```

### 验收标准

- App 内能打开隐私政策页。
- App 内能打开免责声明页。
- 文案明确说明本地处理和使用边界。
- 核心结果页有短免责声明提示。

### 建议 commit message

```text
feat: add privacy policy and disclaimer screens
```

## 10. 阶段 11：App Icon、Launch、上架 Checklist

### 阶段目标

补齐上架基础检查项，包括 App Icon、Launch 表现、元数据风险和版权风险清单。

### 允许修改的文件范围

- `DestinyScope/Assets.xcassets/AppIcon.appiconset`
- `DestinyScope/Assets.xcassets/AccentColor.colorset`
- `DestinyScope/UI/Legal/*`
- `README.md`
- `Docs/*`
- 必要的 Xcode Target Info 配置

### 不允许做的事

- 不生成图片。
- 不使用未授权素材。
- 不新增服务端。
- 不新增在线 AI 宣传。
- 不申请无关权限。
- 不创建或提交 App Store Connect 记录，除非用户另行明确要求。

### Codex 执行 Prompt 草案

```text
请只完成阶段 11：App Icon、Launch、上架 Checklist。
检查 App Icon、AccentColor、Launch Screen、隐私政策、免责声明、README 和 App Store 元数据风险。
不要生成图片，不要使用未授权素材，不要宣传精准预测未来或真实 AI。
如需要用户提供图标素材，请列出规格要求，不要自行生成图片。
```

### 验收标准

- App Icon 不再是空占位配置，或已明确列出待用户提供的素材规格。
- Launch 表现可接受。
- 上架 Checklist 已更新。
- 文案不宣传精准预测未来。
- 文案说明无服务端、无登录、数据本地处理。

### 建议 commit message

```text
chore: prepare app store checklist
```

## 11. 阶段 12：TestFlight 前自测和修 Bug

### 阶段目标

在 TestFlight 前进行完整自测，修复主流程、UI、数据加载和合规页面问题。

### 允许修改的文件范围

- 与 Bug 直接相关的 Swift 文件。
- 与 Bug 直接相关的本地资源。
- `Docs/*` 测试记录和 Checklist。

### 不允许做的事

- 不新增大功能。
- 不临时接服务端。
- 不临时接在线 AI。
- 不新增付费订阅。
- 不做大规模重构。

### Codex 执行 Prompt 草案

```text
请只完成阶段 12：TestFlight 前自测和修 Bug。
运行可用的本地构建或测试命令，检查主流程、深色模式、小屏、知识库、隐私政策和免责声明。
只修复发现的 Bug，不新增大功能，不接服务端，不接 AI，不做大规模重构。
请输出自测结果和仍需人工确认的事项。
```

### 验收标准

- App 可启动。
- 首页到结果页主流程可用。
- 知识库列表和详情可用。
- 隐私政策和免责声明可打开。
- 断网状态核心功能可用。
- 深色模式文字可读。
- 没有明显崩溃和阻断问题。

### 建议 commit message

```text
fix: resolve testflight readiness issues
```

## 12. 总体验收

V1 完成时应满足：

- 出生日期和时辰输入可用。
- 本地称骨算命可用。
- 命格诗文展示可用。
- 本地模板式命理师解读可用。
- 知识库列表和详情可用。
- 关于、隐私政策、免责声明页面可用。
- 基础传统命理风格 UI 完成。
- 无服务端。
- 无登录。
- 无在线 AI。
- 无真实本地 LLM 推理。
- 无新增第三方依赖。
- 出生信息不上传。
