# DestinyScope V1 架构方案

## 1. 当前架构问题总结

基于当前项目和 `Docs/ProjectAudit.md`，现有代码是一个非常早期的 SwiftUI Demo。核心问题如下。

### MainContentView 过重

`DestinyScope/UI/MainContentView.swift` 同时负责：

- 页面布局。
- 出生日期状态。
- 出生时辰状态。
- 查询按钮事件。
- 农历日期转换调用。
- 年、月、日、时权重匹配。
- 总重量计算。
- 诗文匹配。
- 结果状态更新。

这会导致后续新增结果页、知识库、模板式解读时 UI 文件继续膨胀。

### 计算逻辑在 UI 层

当前 `calculateLifeWeight()` 在 SwiftUI View 内。命理计算无法独立测试，也不利于复用到结果页、历史记录、分享图片或后续解释器。

### DataManager 职责混合

`DestinyScope/Bizs/DataManager.swift` 当前同时负责：

- 单例生命周期。
- CSV 文件读取。
- CSV 字段解析。
- 数据列表存储。
- 公历转农历。

后续应拆成数据加载、Repository、Calendar Service、Engine 等更清晰的职责。

### CSV 解析和错误处理不足

当前 CSV 解析使用 `line.components(separatedBy: ",")`，适合当前简单数据，但对字段内逗号、引号、复杂换行不稳。加载失败只 `print`，数据缺失时 UI 没有明确错误反馈。

### 缺少测试

当前没有看到单元测试 target。核心风险点包括：

- 农历转换是否符合预期。
- 闰月是否处理。
- `Year.csv` 年序号是否与 Apple 中国历法年序号匹配。
- 权重累加是否稳定。
- 诗文匹配是否完整。
- 模板解读是否避免危险文案。

## 2. V1 目标架构

建议目标目录结构如下。这是目标结构，不要求当前阶段移动文件；后续阶段要小步迁移，保证每一步可编译。

```text
DestinyScope/
  App/
  UI/
    Home/
    Result/
    Knowledge/
    Settings/
    Legal/
    Components/
    Theme/
  Domain/
    Models/
    Engine/
    Interpreter/
    Knowledge/
  Services/
    Calendar/
    DataLoading/
    Storage/
  Resources/
    CSV/
    Knowledge/
  Docs/
```

### 分层职责

- `App/`：App 入口、依赖组装、根导航。
- `UI/`：SwiftUI 页面、组件和主题，不直接做命理计算。
- `Domain/Models/`：核心业务模型，例如出生资料、农历生日、称骨结果、解读结果。
- `Domain/Engine/`：称骨计算、本地规则引擎。
- `Domain/Interpreter/`：模板式命理师解释器，后续可替换为本地 LLM。
- `Domain/Knowledge/`：知识库领域模型。
- `Services/Calendar/`：公历转农历、闰月处理。
- `Services/DataLoading/`：CSV、JSON、本地 Bundle 资源加载。
- `Services/Storage/`：后续 P1 本地历史记录存储。
- `Resources/CSV/`：后续可迁移 CSV 数据。
- `Resources/Knowledge/`：后续新增知识库 JSON。
- `Docs/`：产品、架构、路线图和审计文档。

## 3. 核心模块设计

### LifeWeightEngine

职责：

- 输入出生日期和小时。
- 调用 `ChineseCalendarService` 获取农历信息。
- 调用 `LifeWeightRepository` 查询年、月、日、时、诗文。
- 输出 `LifeWeightResult`。

不应负责：

- SwiftUI 状态。
- 页面文案。
- 文件读取细节。
- 模板式命理师解读。

### ChineseCalendarService

职责：

- 负责公历转农历。
- 返回农历年序号、农历月、农历日。
- 返回闰月信息。
- 为后续样例测试提供稳定接口。

需要重点验证：

- Apple `Calendar(identifier: .chinese)` 的 `.year` 是否与 `Year.csv` 的 1 到 60 干支循环一致。
- 闰月生日在称骨规则中如何处理。

### LifeWeightRepository

职责：

- 从 CSV 数据中查询年、月、日、时、诗文。
- 对外提供按 key 查询的接口。
- 隐藏 CSV 文件名、列号和解析细节。

建议方法：

- `yearInfo(for yearIndex: Int)`
- `monthInfo(for month: Int, isLeapMonth: Bool)`
- `dateInfo(for day: Int)`
- `hourInfo(for hour: Int)`
- `poemInfo(for weight: Double)`

### TemplateFortuneInterpreter

职责：

- 基于 `LifeWeightResult` 生成本地命理师解读。
- 输出总评、性格、事业、财运、关系。
- 使用本地模板和安全文案规则。

不应负责：

- 真实在线 AI。
- 本地 LLM 推理。
- 网络请求。
- 用户身份或付费状态。

### KnowledgeRepository

职责：

- 加载本地 JSON 知识库。
- 提供文章列表和详情查询。
- 支持按分类筛选。

知识库来源应本地化，V1 不做远程更新。

### AppTheme / DesignSystem

职责：

- 统一颜色。
- 统一字号。
- 统一圆角。
- 统一间距。
- 统一卡片样式。
- 支持深色模式。

目标是避免在 SwiftUI View 中继续散落 `Color.red`、RGB 硬编码、固定间距和临时调试样式。

## 4. 数据模型设计

以下是文档级别 Swift 伪代码，不在本阶段写入源码。

### BirthProfile

```swift
struct BirthProfile: Equatable {
    let solarDate: Date
    let hour: Int
}
```

### LunarBirthDate

```swift
struct LunarBirthDate: Equatable {
    let yearIndex: Int
    let yearText: String
    let month: Int
    let monthText: String
    let day: Int
    let dayText: String
    let isLeapMonth: Bool
    let displayText: String
}
```

### LifeWeightBreakdown

```swift
struct LifeWeightBreakdown: Equatable {
    let year: WeightItem
    let month: WeightItem
    let day: WeightItem
    let hour: WeightItem
}

struct WeightItem: Equatable {
    let label: String
    let valueText: String
    let weightText: String
    let weight: Double
}
```

### LifeWeightResult

```swift
struct LifeWeightResult: Equatable {
    let birthProfile: BirthProfile
    let lunarBirthDate: LunarBirthDate
    let hourText: String
    let breakdown: LifeWeightBreakdown
    let totalWeight: Double
    let totalWeightText: String
    let title: String
    let poem: String
}
```

### FortuneInterpretation

```swift
struct FortuneInterpretation: Equatable {
    let summary: String
    let personality: String
    let career: String
    let wealth: String
    let relationship: String
    let safetyNotice: String
}
```

### KnowledgeArticle

```swift
struct KnowledgeArticle: Identifiable, Equatable {
    let id: String
    let category: String
    let title: String
    let summary: String
    let body: String
    let tags: [String]
    let source: String?
    let version: String
}
```

### AppDisclaimer

```swift
struct AppDisclaimer: Equatable {
    let title: String
    let body: String
    let shortNotice: String
}
```

## 5. 协议设计

以下是文档级别 Swift 伪代码，不在本阶段写入源码。

### LifeWeightCalculating

```swift
protocol LifeWeightCalculating {
    func calculate(profile: BirthProfile) throws -> LifeWeightResult
}
```

### CalendarConverting

```swift
protocol CalendarConverting {
    func lunarBirthDate(from solarDate: Date) throws -> LunarBirthDate
}
```

### FortuneInterpreting

```swift
protocol FortuneInterpreting {
    func interpret(result: LifeWeightResult) throws -> FortuneInterpretation
}
```

### KnowledgeProviding

```swift
protocol KnowledgeProviding {
    func articles() throws -> [KnowledgeArticle]
    func article(id: String) throws -> KnowledgeArticle
    func articles(category: String) throws -> [KnowledgeArticle]
}
```

## 6. 错误处理策略

建议建立统一错误模型，再由 ViewModel 映射为用户可读文案。

### CSV 缺失

场景：

- Bundle 中找不到 `Year.csv`、`Month.csv`、`Date.csv`、`Hour.csv` 或 `Poem.csv`。

策略：

- Repository 抛出资源缺失错误。
- UI 显示“本地数据加载失败，请稍后重试或重新安装 App”。
- 不继续生成部分结果。

### 日期转换失败

场景：

- `Calendar(identifier: .chinese)` 未返回年、月、日。

策略：

- `ChineseCalendarService` 抛出日期转换错误。
- UI 显示“暂时无法转换该日期，请检查输入后重试”。

### 权重匹配失败

场景：

- 年、月、日、时任一项在 CSV 中未找到。

策略：

- `LifeWeightRepository` 或 `LifeWeightEngine` 抛出具体缺失项错误。
- UI 不展示不完整结果。
- 开发日志中记录缺失 key。

### 诗文匹配失败

场景：

- 总重量无法在 `Poem.csv` 中匹配。

策略：

- 使用 epsilon 比较 Double。
- 匹配失败时抛出诗文缺失错误。
- UI 显示“结果数据暂未收录”，不编造内容。

### 知识库加载失败

场景：

- JSON 文件缺失。
- JSON 格式错误。
- 文章 id 不存在。

策略：

- 知识库列表显示空状态和错误文案。
- 不影响称骨计算主流程。

## 7. 测试策略

### LifeWeightEngine 单元测试

覆盖：

- 固定生日和小时得到固定总重量。
- 年、月、日、时权重明细正确。
- 总重量匹配到正确诗文。
- 缺失数据时抛出错误。

### CalendarService 日期样例测试

覆盖：

- 常规公历日期转农历。
- 农历新年前后日期。
- 闰月日期。
- 验证 `yearIndex` 与 `Year.csv` 的干支循环关系。

### TemplateFortuneInterpreter 输出安全性测试

覆盖：

- 输出包含总评、性格、事业、财运、关系五类内容。
- 输出不包含“必死”“必病”“必破产”“必离婚”等绝对或恐吓表达。
- 输出包含“仅供娱乐和传统文化参考”或等价提示。
- 不生成健康、寿命、疾病、投资确定性建议。

### KnowledgeRepository 加载测试

覆盖：

- 本地 JSON 能正常解码。
- 文章列表非空。
- 通过 id 能获取详情。
- 分类筛选正常。
- 缺失文件和格式错误可被捕获。

## 8. 本地 LLM 预留策略

V1 不实现真实模型，不接本地 LLM，也不接在线 AI。

预留方式：

- 只保留 `FortuneInterpreting` 协议。
- `TemplateFortuneInterpreter` 作为默认实现。
- UI 和 ViewModel 只依赖 `FortuneInterpreting`。
- 后续如果要接本地模型，可新增 `LocalLLMFortuneInterpreter`。

后续 `LocalLLMFortuneInterpreter` 应仍遵守：

- 出生信息默认本地处理。
- 不输出医疗、寿命、疾病、投资确定性建议。
- 不输出婚姻绝对判断。
- 保留免责声明。

## 9. 迁移原则

- 当前阶段只写文档，不改源码。
- 后续每个阶段只做一个明确目标。
- 每一步都保持项目可编译。
- 不一次性移动大量文件。
- 不引入第三方库。
- 不把 UI 改造和计算引擎抽离混在同一个阶段。
- 先建立可测试的 Domain，再扩展页面和视觉。
