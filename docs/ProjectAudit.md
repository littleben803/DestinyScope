# DestinyScope 项目审计报告

审计范围：当前工作区 `/Users/bytedance/repo/lark/DestinyScope`。本报告仅基于现有源码、工程配置、资源文件和 README 静态审计，未做代码修改、未引入第三方库、未执行重构。

## 1. 项目基本情况

### 技术架构

- 当前项目是 SwiftUI 应用，不是 UIKit 项目。
- 未发现 `UIViewController`、Storyboard、XIB 或 UIKit 页面代码。
- 工程中存在 CocoaPods 配置，但 `Podfile` 内第三方依赖均为注释状态，当前实际业务代码没有使用第三方库。
- 架构形态接近简单 SwiftUI + 单例数据管理：
  - `DestinyScopeApp.swift` 负责 App 启动和依赖注入。
  - `MainContentView.swift` 同时承担 UI、输入状态、查询按钮事件和命理计算流程。
  - `DataManager.swift` 负责本地 CSV 加载、解析和农历日期转换。
  - `LifeWeightModel.swift` 定义 CSV 数据模型。

### App 入口

- App 入口位于 `DestinyScope/DestinyScopeApp.swift`。
- `@main struct DestinyScopeApp: App` 是 SwiftUI 生命周期入口。
- 启动时创建并持有 `@StateObject private var dataManager = DataManager.shared`。
- `WindowGroup` 中展示 `MainContentView()`，并通过 `.environmentObject(dataManager)` 注入全局数据对象。

### 主要页面

当前只有一个主要页面：

- `DestinyScope/UI/MainContentView.swift`
  - 出生日期选择。
  - 出生时辰选择。
  - 查询按钮。
  - 查询结果展示区域。

未发现 Tab、设置页、历史记录页、详情页、隐私政策页、免责声明页、关于页或付费相关页面。

### 当前运行流程

1. App 启动进入 `DestinyScopeApp`。
2. 初始化 `DataManager.shared`。
3. `DataManager` 在 `private init()` 中调用 `loadAllData()`。
4. `loadAllData()` 从 App Bundle 中读取：
   - `Year.csv`
   - `Month.csv`
   - `Date.csv`
   - `Hour.csv`
   - `Poem.csv`
5. `MainContentView` 显示日期、时辰输入表单。
6. 用户点击“查询”后调用 `calculateLifeWeight()`。
7. `calculateLifeWeight()` 将公历生日转换为中国农历年月日，按年、月、日、时四项从 CSV 数据中查权重。
8. 四项权重累加为 `lifeWeight`。
9. 使用 `lifeWeight` 在 `poemList` 中匹配对应诗文。
10. 页面展示命格标题、农历生日和诗文内容。

## 2. 当前已有功能

### 出生日期/时辰输入逻辑

位置：`DestinyScope/UI/MainContentView.swift`

- 出生日期：
  - `@State private var birthDate = Date()`
  - 使用 `DatePicker("出生日期", selection: $birthDate, displayedComponents: [.date])`
  - 设置了中文 Locale：`.environment(\.locale, Locale(identifier: "zh_CN"))`

- 出生时辰：
  - `@State private var selectedHour = 0`
  - `let hours = Array(0...23)`
  - 使用 `Picker("出生时辰", selection: $selectedHour)` 显示 0 到 23 点。
  - 展示格式为 `00 时`、`01 时` 等。
  - 时辰映射实际依赖 `Hour.csv`，例如 1、2 都对应丑时，3、4 都对应寅时。

### 查询按钮逻辑

位置：`DestinyScope/UI/MainContentView.swift`

- 查询按钮定义为：
  - `Button(action: calculateLifeWeight) { Text("查询") ... }`
- 点击后直接调用 View 内的 `calculateLifeWeight()`。
- 当前没有 loading、错误提示、空数据提示、重复点击保护或输入边界提示。
- 计算失败时，如果农历年月日转换返回 nil，会直接 `return`，UI 不显示错误原因。

### 当前命理结果生成方式

位置：

- 主流程：`DestinyScope/UI/MainContentView.swift` 的 `calculateLifeWeight()`
- 数据来源：`DestinyScope/Bizs/DataManager.swift`
- 模型定义：`DestinyScope/Model/LifeWeightModel.swift`
- 本地数据：`DestinyScope/Resources/*.csv`

当前算法是本地“称骨算命”权重累加：

1. 使用 `Calendar(identifier: .chinese)` 将公历生日转换为中国农历年月日。
2. 用农历年序号匹配 `yearList.year`，累加年权重。
3. 用农历月匹配 `monthList.month`，累加月权重。
4. 用农历日匹配 `dateList.date`，累加日权重。
5. 用选择的 0 到 23 点匹配 `hourList.hour`，累加时辰权重。
6. 以总权重匹配 `poemList.weight`。
7. 命中后展示 `PoemInfo.title` 和 `PoemInfo.content`。

需要注意的问题：

- 权重使用 `Double`，匹配时用了 `epsilon = 0.0001`，避免部分浮点误差。
- 如果某一项没有匹配，当前不会报错，而是少加该项权重，可能得到错误结果。
- 农历闰月未见明确处理逻辑。`Calendar(identifier: .chinese)` 可以取出 month/day，但代码没有读取或处理 `.isLeapMonth`。
- 农历年取的是中国历法组件 `.year`，当前 `Year.csv` 的 year 范围看起来是 1 到 60 的干支循环序号，是否与 Apple Calendar 返回值完全对应需要专项验证。

### 本地 CSV、JSON、plist 或硬编码数据

本地 CSV：

- `DestinyScope/Resources/Year.csv`：60 行，含干支年、权重、生肖、生肖图片名等字段。
- `DestinyScope/Resources/Month.csv`：12 行，含农历月份权重。
- `DestinyScope/Resources/Date.csv`：30 行，含农历日期权重。
- `DestinyScope/Resources/Hour.csv`：24 行，含小时到时辰权重的映射。
- `DestinyScope/Resources/Poem.csv`：52 行，含总重量、标题和诗文内容。

本地 JSON：

- Asset Catalog 的 `Contents.json`。
- 未发现业务 JSON 数据。

plist：

- 工程使用 `GENERATE_INFOPLIST_FILE = YES` 自动生成 Info.plist。
- 未发现手写业务 plist 数据。

硬编码：

- UI 文案硬编码在 `MainContentView.swift`，例如“出生日期”“出生时辰”“查询”“测试程序”。
- UI 颜色、透明度、字号、间距、圆角、按钮 padding 均硬编码在 `MainContentView.swift`。
- CSV 文件名硬编码在 `DataManager.loadAllData()`。
- CSV 解析列号硬编码在各 `parse*Row` 方法中。

### 农历、生肖、天干地支、五行相关逻辑

已有：

- 农历日期转换：
  - `DataManager.getChineseCalendarComponents(from:)`
  - 使用 `Calendar(identifier: .chinese)` 获取 `.year`、`.month`、`.day`。

- 天干地支数据：
  - `Year.csv` 中有 `甲子`、`乙丑`、`丙寅` 等年柱文本。
  - 当前只是作为 CSV 字段读取和展示拼接，不存在独立天干地支推算引擎。

- 生肖数据：
  - `Year.csv` 中有 `zodiacString` 和 `zodiacImageName` 字段。
  - `YearInfo` 模型包含 `zodiacString`、`zodiacImageName`。
  - 当前 UI 没有展示生肖，也没有实际图片资源文件。

未发现：

- 五行计算逻辑。
- 八字四柱完整推算逻辑。
- 十神、纳音、藏干、大运、流年等逻辑。
- 独立农历引擎或历法校验数据。
- 生肖图片资源。

## 3. 当前代码结构

### 主要目录说明

- `DestinyScope/`
  - App 主代码和资源根目录。
- `DestinyScope/UI/`
  - SwiftUI 页面，目前只有 `MainContentView.swift`。
- `DestinyScope/Bizs/`
  - 业务/数据管理逻辑，目前只有 `DataManager.swift`。
  - 目录名 `Bizs` 不太符合常见 Swift 项目命名，可考虑后续改为 `Services`、`Managers` 或 `Domain`，但当前阶段不必立即调整。
- `DestinyScope/Model/`
  - 数据模型，目前只有 `LifeWeightModel.swift`。
- `DestinyScope/Resources/`
  - 本地 CSV 数据。
- `DestinyScope/Assets.xcassets/`
  - AppIcon、AccentColor 配置。
- `DestinyScope/Preview Content/`
  - SwiftUI Preview 资源目录。
- `Pods/`
  - CocoaPods 目录，目前没有实际业务依赖。
- `Docs/`
  - 本次审计报告目录。

### 主要 View / Model / Service 说明

- `DestinyScopeApp`
  - SwiftUI 生命周期入口。
  - 初始化并注入 `DataManager.shared`。

- `MainContentView`
  - 当前唯一页面。
  - 管理用户输入状态：生日、时辰。
  - 管理结果状态：命格标题、农历生日、诗文结果。
  - 构建表单、按钮、结果卡片。
  - 包含核心查询和权重计算逻辑。

- `DataManager`
  - `ObservableObject` 单例。
  - 持有所有 CSV 数据列表。
  - 启动时读取 CSV。
  - 用简单逗号切分解析 CSV。
  - 提供公历转中国农历年月日的方法。

- `LifeWeightModel.swift`
  - 定义 `YearInfo`、`MonthInfo`、`DateInfo`、`HourInfo`、`PoemInfo`。
  - 各模型 conform `Identifiable`，`id` 通过 `UUID()` 生成。

### 结构问题

- UI 层承载过多业务逻辑：
  - `calculateLifeWeight()` 位于 `MainContentView`，包含历法转换、数据匹配、权重累加、诗文匹配和结果赋值。
  - 后续扩展到八字、五行、模板式解读时，View 会迅速膨胀。

- `DataManager` 职责混合：
  - 同时负责文件读取、CSV 解析、数据存储、农历转换。
  - 后续可拆分为 `CSVLoader`、`LifeWeightRepository`、`CalendarService`、`LifeWeightEngine`。

- CSV 解析较脆弱：
  - 使用 `line.components(separatedBy: ",")`，无法正确处理字段内逗号、引号转义、复杂换行。
  - 当前数据简单，暂时可用；如果扩展知识库文本，建议改为更稳健的 CSV 解析方式或改用 JSON/plist。

- 错误处理不足：
  - CSV 加载失败只 `print`。
  - 数据缺失或匹配失败不反馈给 UI。
  - 计算结果可能在部分数据缺失时仍继续生成。

- 硬编码较明显：
  - 文件名、字段列号、页面文案、颜色、间距都散落在代码中。
  - 当前小项目可接受，但进入 V1 前建议集中整理。

- 可测试性不足：
  - 没有单元测试 target。
  - 核心命理计算在 View 内，不利于做输入输出测试。
  - 历法转换和权重匹配没有样例校验。

## 4. 当前 UI 问题

### 布局方式

位置：`DestinyScope/UI/MainContentView.swift`

当前页面结构：

- `NavigationView`
- `ZStack`
- `Color.red.ignoresSafeArea()`
- `VStack(spacing: 12)`
- `Form`
- `DatePicker`
- `Picker`
- `Button`
- 条件展示的结果 `VStack`
- `Spacer`

主要特点：

- 背景使用整屏红色，并带有注释“便于调试”，明显不是最终视觉。
- 输入区使用 `Form`，但通过 `.frame(maxHeight: 140)` 和 `.scrollDisabled(true)` 人为限制高度。
- 结果区域使用白色半透明背景、16 圆角、横向 padding，类似卡片。
- 导航标题为“测试程序”，不符合正式产品命名。

### 不同屏幕尺寸适配

当前基本依赖 SwiftUI 自适应，但存在风险：

- `Form` 高度固定为 `maxHeight: 140`，在动态字体、不同系统语言、较小屏幕或横屏下可能截断。
- `Button` 使用固定水平 padding 40、垂直 padding 10，短期问题不大，但不具备完整组件规范。
- 结果文本没有滚动容器，诗文或后续长解读内容变长后，可能在小屏幕显示不完整。
- iPhone 支持横竖屏，iPad 支持四方向，但当前布局没有针对横屏和 iPad 做分栏或宽度约束优化。
- `NavigationView` 在较新 SwiftUI 中可考虑后续迁移到 `NavigationStack`，但当前不是必须问题。

### 深色模式适配

当前深色模式适配不足：

- 背景硬编码 `Color.red`。
- 表单背景硬编码 `Color.white.opacity(0.9)`。
- 结果背景硬编码 `Color.white.opacity(0.9)`。
- 按钮背景硬编码 RGB 深红。
- `Text(result)` 使用 `.foregroundColor(.primary)`，但放在白色半透明背景上，深色模式下整体层次和对比不可控。
- Asset Catalog 的 `AccentColor` 没有实际颜色值。
- AppIcon 配置包含 dark/tinted 外观条目，但没有实际图片文件。

### 硬编码颜色、字号、间距

存在较多硬编码：

- 颜色：
  - `Color.red`
  - `Color.white.opacity(0.9)`
  - `Color(red: 140/255, green: 32/255, blue: 32/255)`
- 字号/字体：
  - `.font(.headline)`
  - `.font(.subheadline)`
  - `.font(.body)`
- 间距：
  - `VStack(spacing: 12)`
  - `.padding(.horizontal, 40)`
  - `.padding(.vertical, 10)`
  - `.padding(.horizontal)`
  - `.padding(.top)`
- 圆角：
  - `.cornerRadius(16)`
  - `.clipShape(Capsule())`

建议 V1 前形成简单设计 Token 或 Theme，例如品牌色、背景色、卡片色、正文色、常用间距、圆角、标题层级。

## 5. 上架风险

### 隐私政策入口

当前未发现：

- App 内隐私政策入口。
- README 中隐私政策链接。
- Privacy Manifest 文件。
- 设置页或关于页。

即使当前不采集个人信息，用户输入生日和时辰也属于较敏感的个人信息场景。上架前建议提供隐私政策入口，说明数据是否本地处理、是否上传、是否存储。

### 免责声明

当前未发现免责声明。

命理、运势、人生建议类内容容易被用户理解为确定性判断。上架前建议加入明确免责声明：

- 内容仅供娱乐、传统文化参考和自我探索。
- 不构成医疗、法律、财务、婚恋或职业决策建议。
- 不应替代专业人士意见。

### App Icon / Launch Screen / 权限说明

- App Icon：
  - `AppIcon.appiconset/Contents.json` 存在。
  - 未发现实际 icon 图片文件。
  - 当前大概率无法作为正式上架图标。

- Launch Screen：
  - 工程配置 `INFOPLIST_KEY_UILaunchScreen_Generation = YES`，使用 Xcode 自动生成 Launch Screen。
  - 未发现自定义 Launch Screen。
  - 技术上可能可运行，但正式产品体验较弱。

- 权限说明：
  - 当前未发现相机、相册、定位、通知等权限调用。
  - 未发现 `NS*UsageDescription`。
  - 如果后续不申请系统权限，可以暂不添加权限说明。

### 版权风险资源

当前资源主要为传统命理 CSV 文本：

- `Poem.csv` 中包含称骨算命诗文。
- 这些内容来源未在代码或 README 中注明。
- 虽然可能属于传统文本，但整理版本、标题、注释、繁体文本来源仍可能存在版权或授权不清风险。

建议：

- 明确数据来源。
- 使用公版或自有改写文本。
- 对模板解读内容尽量自研，避免直接复制网络文章。
- 如果使用图标、生肖图、背景图，必须确认授权。

### 功能过薄风险

当前 App 功能很薄：

- 单页输入。
- 单次查询。
- 一个权重结果和诗文展示。
- 没有历史记录、解释过程、知识库说明、个性化解读、收藏、分享、设置、隐私政策、免责声明等基础产品能力。

以当前状态直接上架，可能存在被认为功能过于简单、低质量、重复应用或未完成产品的风险。

此外，README 写着“结合 AI 解读”，但当前没有真实 AI，也没有模板式 AI 命理师体验。如果 App Store 元数据宣称 AI，实际 App 内没有对应能力，会带来审核和用户预期风险。

## 6. V1 Native 改造建议

总体方向：

- 不加服务端。
- 不接真实在线 AI。
- 先做本地命理引擎。
- 先做模板式 AI 命理师。
- 先做本地知识库。
- 后续预留本地 LLM 接口。

### 建议目标架构

建议把当前单页逻辑拆成几层：

- UI 层：
  - 输入页、结果页、知识库页、设置/关于页。
- ViewModel 层：
  - 管理输入状态、校验状态、查询状态和展示模型。
- Domain/Engine 层：
  - 本地称骨计算。
  - 农历转换封装。
  - 干支、生肖、五行等基础推算。
- Repository 层：
  - 加载本地 CSV/JSON/plist 知识库。
  - 对外提供结构化查询。
- Template Interpreter 层：
  - 把命理结果转成更像“AI 命理师”的本地模板解读。
- LLM Adapter 层：
  - 只定义协议，不接真实模型。
  - 后续可替换为本地 LLM、系统模型或在线 AI。

### 本地命理引擎

优先完成稳定、可测试的本地引擎：

- `LifeWeightEngine`
  - 输入生日、时辰。
  - 输出农历日期、四项权重、总权重、命格诗文。
  - 对缺失数据给出错误。

- `ChineseCalendarService`
  - 封装 `Calendar(identifier: .chinese)`。
  - 明确处理闰月。
  - 增加固定日期样例校验。

- `StemBranchService`
  - 后续扩展天干地支。
  - 避免把所有计算写在 UI。

- `FiveElementsService`
  - 后续扩展五行属性、强弱、喜忌等模板基础。

### 模板式 AI 命理师

不接真实 AI 的情况下，可以先做本地模板解释：

- 使用结构化模板：
  - 总评。
  - 性格倾向。
  - 事业建议。
  - 财运建议。
  - 关系建议。
  - 年度提醒。
  - 行动建议。

- 模板来源：
  - 本地 JSON 或 plist。
  - 每个模板包含适用条件、标题、正文、免责声明等级。

- 输出风格：
  - 避免绝对化、恐吓式、歧视性判断。
  - 使用“倾向”“建议”“参考”措辞。
  - 明确娱乐和文化参考属性。

### 本地知识库

建议建立本地知识库而不是继续把长文本都塞入 CSV：

- 适合 JSON/plist 的内容：
  - 干支介绍。
  - 生肖介绍。
  - 五行介绍。
  - 称骨算法说明。
  - 结果解释模板。
  - 术语词典。

- 知识库应结构化：
  - `id`
  - `category`
  - `title`
  - `summary`
  - `body`
  - `tags`
  - `source`
  - `version`

### 后续预留本地 LLM 接口

先定义协议，不实现真实模型：

- `FortuneInterpreterProtocol`
  - 输入：结构化命理结果、用户问题、上下文。
  - 输出：解释文本、引用知识点、免责声明。

- 初始实现：
  - `TemplateFortuneInterpreter`

- 后续可替换：
  - `LocalLLMFortuneInterpreter`
  - `OnlineAIInterpreter`

这样可以保证 V1 完全离线，同时为未来 AI 能力留接口。

## 7. 建议的阶段拆分

### 阶段 1：稳定当前称骨计算

目标：

- 把 `calculateLifeWeight()` 从 UI 中移出。
- 建立可测试的本地称骨计算引擎。
- 明确错误处理和空结果处理。

主要文件：

- `DestinyScope/UI/MainContentView.swift`
- `DestinyScope/Bizs/DataManager.swift`
- `DestinyScope/Model/LifeWeightModel.swift`
- 新增 `DestinyScope/Services/LifeWeightEngine.swift`
- 新增 `DestinyScope/Model/LifeWeightResult.swift`

### 阶段 2：整理数据加载和本地资源

目标：

- 将 CSV 加载、解析、业务查询拆开。
- 校验 CSV 数据完整性。
- 为长文本知识库选择 JSON 或 plist。

主要文件：

- `DestinyScope/Bizs/DataManager.swift`
- `DestinyScope/Resources/Year.csv`
- `DestinyScope/Resources/Month.csv`
- `DestinyScope/Resources/Date.csv`
- `DestinyScope/Resources/Hour.csv`
- `DestinyScope/Resources/Poem.csv`
- 新增 `DestinyScope/Services/CSVLoader.swift`
- 新增 `DestinyScope/Repositories/LifeWeightRepository.swift`

### 阶段 3：重做 V1 基础 UI

目标：

- 从测试页面升级为正式单机 App 体验。
- 完善输入页、结果页、关于页、免责声明和隐私政策入口。
- 适配深色模式、动态字体、小屏和横屏基础场景。

主要文件：

- `DestinyScope/UI/MainContentView.swift`
- 新增 `DestinyScope/UI/Input/BirthInputView.swift`
- 新增 `DestinyScope/UI/Result/FortuneResultView.swift`
- 新增 `DestinyScope/UI/Settings/AboutView.swift`
- 新增 `DestinyScope/UI/Components/*`
- 新增 `DestinyScope/UI/Theme/AppTheme.swift`

### 阶段 4：本地模板式 AI 命理师

目标：

- 不接真实在线 AI。
- 基于本地命理结果和知识库生成更完整的解释。
- 让用户感知为“命理师解读”，但实现上是本地模板。

主要文件：

- 新增 `DestinyScope/Interpreter/FortuneInterpreterProtocol.swift`
- 新增 `DestinyScope/Interpreter/TemplateFortuneInterpreter.swift`
- 新增 `DestinyScope/Model/FortuneInterpretation.swift`
- 新增 `DestinyScope/Resources/Knowledge/*.json`
- `DestinyScope/UI/Result/FortuneResultView.swift`

### 阶段 5：本地知识库与内容合规

目标：

- 建立术语、算法说明、传统文化说明和结果解释知识库。
- 补充来源说明、免责声明、隐私说明。
- 减少直接复制网络内容的版权风险。

主要文件：

- 新增 `DestinyScope/Resources/Knowledge/*`
- 新增 `DestinyScope/Repositories/KnowledgeRepository.swift`
- 新增 `DestinyScope/UI/Knowledge/KnowledgeListView.swift`
- 新增 `DestinyScope/UI/Knowledge/KnowledgeDetailView.swift`
- 新增 `DestinyScope/UI/Legal/PrivacyPolicyView.swift`
- 新增 `DestinyScope/UI/Legal/DisclaimerView.swift`

### 阶段 6：预留本地 LLM 接口

目标：

- 只设计接口和数据结构。
- 不接服务端。
- 不接真实在线 AI。
- 保持当前模板解释器可作为默认实现。

主要文件：

- `DestinyScope/Interpreter/FortuneInterpreterProtocol.swift`
- 新增 `DestinyScope/Interpreter/LocalLLMInterpreterPlaceholder.swift`
- 新增 `DestinyScope/Model/InterpreterRequest.swift`
- 新增 `DestinyScope/Model/InterpreterResponse.swift`

### 阶段 7：上架准备

目标：

- 补齐 App Icon、Launch Screen、隐私政策、免责声明。
- 检查 App Store 元数据与实际功能一致。
- 做基础真机适配和稳定性验证。

主要文件：

- `DestinyScope/Assets.xcassets/AppIcon.appiconset`
- `DestinyScope/Assets.xcassets/AccentColor.colorset`
- `DestinyScope/UI/Legal/PrivacyPolicyView.swift`
- `DestinyScope/UI/Legal/DisclaimerView.swift`
- `README.md`
- Xcode Target Signing & Capabilities / Info 配置

## 总结

当前 DestinyScope 是一个非常早期的 SwiftUI 本地 Demo：具备出生日期、时辰输入，以及基于本地 CSV 的称骨权重计算和诗文展示。核心功能链路已经跑通雏形，但业务逻辑集中在 UI 层，数据解析和错误处理较弱，UI 仍带有测试痕迹，上架所需的隐私、免责声明、图标、内容合规和产品厚度都明显不足。

V1 建议不要急于接服务端或真实 AI。优先把本地命理引擎、模板式解读、本地知识库和基础合规页面做扎实，再预留本地 LLM 接口。这样可以在保持离线、低复杂度的前提下，把当前 Demo 演进成一个可维护、可测试、可上架的 Native App。
