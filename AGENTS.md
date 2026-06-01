# DestinyScope 项目协作规则

## 项目概况

DestinyScope 是一个完全 Native 的 iOS App，定位为中国传统命理文化与自我探索工具。

当前产品方向：

- Native iOS / SwiftUI
- 本地优先
- 无账号
- 无登录
- 无服务端
- 无在线 AI
- 无广告追踪
- 当前不做付费订阅
- 出生信息、历史记录、模型实验输入输出都应保持设备端处理

当前 App 已包含：

- 本地称骨计算引擎
- 模板式命理解读
- LifeWeightInsight 命格洞察
- 本地模板命理问答
- 本地知识库
- 本地历史记录
- TextRefining 接口
- Debug/TestFlight 风格的本地模型实验路径
- 隐私政策、免责声明、开源许可页面

## 与用户协作方式

用户是资深 iOS 程序员。

每次开发任务必须遵守：

1. 先明确产品目标
2. 再明确技术方案
3. 再明确允许修改范围
4. 再明确禁止修改范围
5. 再明确验收标准
6. 然后小步执行
7. 每完成一个阶段后汇报，并等待用户确认

不要跳过规划直接大规模写代码。

## 当前开发策略

当前项目处于产品功能打磨阶段。

不要默认假设：

- 现在要上传 TestFlight
- 现在要上架 App Store
- 现在要默认启用本地模型
- 现在要把本地模型接入默认结果页
- 现在要新增付费订阅
- 现在要新增服务端或在线 AI

除非用户明确要求，必须保持：

- `TextRefinerFactory.makeDefaultRefiner()` 继续返回 `TemplateTextRefiner`
- 本地模型实验默认关闭
- 本地模型输出不进入默认结果页
- 本地模型输出不写入历史记录
- 本地模型不能生成新的命理结论

## 严格禁止修改的内容，除非用户明确允许

不要修改：

- `LifeWeightEngine`
- `LifeWeightRepository`
- `DataManager`
- CSV 称骨计算数据
- `knowledge_articles.json`
- `rag_chunks.json`
- App Icon
- Launch Screen
- Bundle ID
- Signing Team
- Version / Build
- App Store Connect 元数据

不要新增：

- 服务端
- 登录
- 在线 AI
- 模型下载
- 分析 SDK
- 广告追踪
- StoreKit
- CloudKit / iCloud 同步
- 敏感权限申请
- 付费功能
- RAG 正式路径
- 开放聊天
- 流式 UI

## 本地模型实验规则

本地模型只属于受控实验路径。

必须遵守：

- 默认关闭
- 仅 Debug / TestFlight 风格实验路径使用
- 只能润色已有模板文本
- 不能生成新的命理结论
- 不能改变称骨计算结果
- 不能改写历史记录
- 不能宣传为“AI 算命”
- 失败、超时、低电量、过热、设备不支持、模型不存在、安全检查失败时，必须回退模板文本

绝不能提交：

- `.gguf`
- `.bin`
- `.safetensors`
- `.mlmodel`
- `.mlmodelc`
- `.xcframework`
- llama.cpp 源码
- 签名资产
- token / key / credentials

## 隐私、审核和文案规则

推荐使用这些表达：

- 传统文化
- 自我探索
- 本地处理
- 参考性解读
- 文本润色
- 不生成新的命理结论
- 失败回退模板

避免使用这些表达：

- AI 算命
- 精准预测
- 改命
- 化解
- 避灾
- 保证转运
- 必然发财
- 寿命预测
- 疾病预测
- 投资收益确定
- 婚姻确定性
- 大师在线
- 付费改运

如果这些词出现在文档中，只能出现在“禁止事项 / 安全规则 / 风险词扫描”语境中，不能作为营销文案。

## V1.x 工作流

每个版本都必须按阶段推进：

1. 产品目标
2. 技术方案
3. 阶段拆解
4. 小范围实现
5. 构建验证
6. 静态扫描
7. 文档更新
8. 用户确认后再进入下一阶段

不要跳阶段。
不要把后续阶段内容提前实现。

## 当前项目状态文件

每次开始新的 DestinyScope 任务前，必须先阅读：

- `docs/CODEX_PROJECT_STATE.md`

该文件记录当前版本进度、已完成阶段、当前开发方向和暂不允许做的事项。

如果用户要求进入某个 V1.x 阶段，还必须阅读对应版本的 Roadmap，例如：

- `docs/V1_6_Roadmap.md`

- `docs/V1_5_Roadmap.md`

不要只依赖聊天记忆判断当前项目状态。

## 标准验证命令

涉及 Swift 或工程修改时，优先运行：

```bash
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Debug -destination 'generic/platform=iOS Simulator' build

xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Release -destination 'generic/platform=iOS Simulator' build