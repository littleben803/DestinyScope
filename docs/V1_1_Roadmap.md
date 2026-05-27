# DestinyScope V1.1 Roadmap

更新日期：2026-05-27

V1.1 以小步可编译迁移为原则。每个阶段只解决一个明确目标，避免同时修改业务、UI、数据和架构边界。

## 当前完成状态

更新日期：2026-05-27

- 阶段 2：已完成。已新增 `LifeWeightInsight` 并在结果页展示命格洞察。
- 阶段 3：已完成。已新增命理问答入口，使用本地模板回答五个预设问题。
- 阶段 4：已完成。已整理知识来源，知识库扩充到 29 篇，并新增 `rag_chunks.json` 作为未来 RAG 预留。
- 阶段 5：已完成。已新增本地历史记录，数据仅保存在设备端 Application Support 目录。
- 阶段 6：已完成。已新增 `TextRefining` 接口、`TemplateTextRefiner` 默认实现和 `LocalLLMTextRefiner` 占位实现，不接真实模型。
- 阶段 7：已完成。已新增 `docs/V1_1_TestReport.md`，Debug / Release 构建通过，未发现阻断性小 bug。

## V1.1 阶段 2：增强结果页报告结构，新增 LifeWeightInsight

阶段目标：

- 新增 `LifeWeightInsight` 模型。
- 基于 `LifeWeightResult` 和现有 `FortuneInterpretation` 生成命格标签、优势倾向、关注点、行动建议。
- 调整结果页结构，让报告层级更清楚。

允许修改的文件范围：

- `DestinyScope/Domain/Models/*`
- `DestinyScope/Domain/Interpreter/*`
- `DestinyScope/UI/Result/*`
- 如确实必要，可轻微修改 `DestinyScope/UI/Home/HomeView.swift`

不允许做的事：

- 不改称骨算法。
- 不改 CSV。
- 不改知识库 JSON。
- 不接服务端。
- 不接在线 AI。
- 不接真实本地 LLM。
- 不做付费订阅。

Codex 执行 Prompt 草案：

```text
请只完成 DestinyScope V1.1 阶段 2：增强结果页报告结构，新增 LifeWeightInsight。保持现有称骨计算不变，基于 LifeWeightResult 生成命格标签、优势倾向、关注点、行动建议，并在结果页展示。不要接 AI、不要改 CSV、不要重做 UI。
```

验收标准：

- 项目可编译。
- `LifeWeightInsight` 不依赖 SwiftUI。
- 结果页展示命格标签、优势倾向、关注点、行动建议。
- 文案不包含绝对预测、恐吓式表达、健康寿命疾病预测、投资确定性建议或婚姻绝对判断。

建议 commit message：

```text
Add V1.1 life weight insight report sections
```

## V1.1 阶段 3：新增命理问答入口，使用本地模板回答

阶段目标：

- 新增命理问答入口。
- 支持预设问题：事业、财运、性格、关系、今日建议。
- 使用本地模板回答，不请求网络，不接 AI。

允许修改的文件范围：

- `DestinyScope/Domain/Models/*`
- `DestinyScope/Domain/Interpreter/*`
- `DestinyScope/UI/Result/*`
- 可新增 `DestinyScope/UI/Question/*`

不允许做的事：

- 不接在线 AI。
- 不接真实本地 LLM。
- 不允许自由文本联网问答。
- 不改命理计算规则。
- 不新增服务端。
- 不新增依赖。

Codex 执行 Prompt 草案：

```text
请只完成 DestinyScope V1.1 阶段 3：新增命理问答入口，使用本地模板回答。问题范围限定为事业、财运、性格、关系、今日建议。答案必须基于 LifeWeightResult、LifeWeightInsight 和本地模板，不请求网络，不接 AI SDK。
```

验收标准：

- 用户可以从结果页进入问答入口。
- 每个预设问题都有本地模板答案。
- 问答答案包含安全提示。
- 查询失败或无结果时不能展示旧问答内容。

建议 commit message：

```text
Add local template fortune question answers
```

## V1.1 阶段 4：扩充知识库内容与来源整理

阶段目标：

- 将知识库从 5 篇扩充到至少 20 篇。
- 建立知识来源整理文档。
- 文章内容保持原创改写、通俗、合规。

允许修改的文件范围：

- `DestinyScope/Resources/Knowledge/knowledge_articles.json`
- `docs/knowledge_sources/sources.md`
- `docs/knowledge_sources/raw_notes.md`
- 如需要，可更新知识库相关 Docs。

不允许做的事：

- 不复制来源不明的大段网络内容。
- 不加入恐吓式、营销式、化解类内容。
- 不接远程 CMS。
- 不接向量数据库。
- 不接本地 LLM。

Codex 执行 Prompt 草案：

```text
请只完成 DestinyScope V1.1 阶段 4：扩充知识库内容与来源整理。将本地 knowledge_articles.json 扩充到至少 20 篇，保持原创改写、短文、通俗、合规，并新增 docs/knowledge_sources/sources.md 和 raw_notes.md。不要接远程知识库，不接 RAG，不接 LLM。
```

验收标准：

- 知识库 JSON 可解析。
- 至少 20 篇文章。
- 每篇文章包含 `id`、`category`、`title`、`summary`、`body`、`tags`、`source`、`version`。
- 文案不包含高风险现实决策承诺。
- 来源整理文档存在。

建议 commit message：

```text
Expand local knowledge articles for V1.1
```

## V1.1 阶段 5：新增本地历史记录

阶段目标：

- 新增本地历史记录模型和存储服务。
- 保存用户生成过的结果摘要。
- 提供历史记录列表入口。

允许修改的文件范围：

- `DestinyScope/Domain/Models/*`
- `DestinyScope/Services/Storage/*`
- `DestinyScope/UI/Home/*`
- `DestinyScope/UI/Result/*`
- 可新增 `DestinyScope/UI/History/*`

不允许做的事：

- 不上传历史记录。
- 不使用账号或云同步。
- 不新增数据库依赖。
- 不做付费订阅。
- 不保存超出必要范围的敏感数据。

Codex 执行 Prompt 草案：

```text
请只完成 DestinyScope V1.1 阶段 5：新增本地历史记录。使用系统本地持久化能力保存结果摘要，支持列表查看和进入结果详情。不要上传数据，不接账号，不新增数据库依赖。
```

验收标准：

- 用户完成一次查询后，本地可查看历史记录。
- 断网状态下历史记录可用。
- 历史记录只保存在设备端。
- 隐私文案仍准确。

建议 commit message：

```text
Add local history records
```

## V1.1 阶段 6：预留本地小模型润色接口

阶段目标：

- 定义本地小模型润色协议。
- 提供 Mock/Template 实现。
- 不接真实模型，不下载模型。

允许修改的文件范围：

- `DestinyScope/Domain/Interpreter/*`
- `DestinyScope/Domain/Models/*`
- 可新增 `DestinyScope/Services/LocalModel/*`
- Docs 中可补充接口说明。

不允许做的事：

- 不接真实本地 LLM。
- 不接在线 AI。
- 不下载模型。
- 不新增推理框架依赖。
- 不让模型负责命理计算或结论生成。

Codex 执行 Prompt 草案：

```text
请只完成 DestinyScope V1.1 阶段 6：预留本地小模型润色接口。新增协议和 Mock/Template 实现，仅用于未来文本润色，不接真实模型，不新增依赖，不改变命理计算结论。
```

验收标准：

- 有明确协议，例如 `FortuneTextPolishing`。
- 默认实现不请求网络、不调用模型。
- 输入为结构化结论，输出为安全润色文本。
- 文档明确模型不得负责结论生成。

建议 commit message：

```text
Add local model polishing protocol placeholder
```

## V1.1 阶段 7：V1.1 自测与文档更新

阶段目标：

- 对 V1.1 做构建、自测、合规和发布风险检查。
- 更新 V1.1 文档和 App Store 检查清单。

允许修改的文件范围：

- `docs/*`
- 若发现阻断性小 bug，可修改对应 Swift 文件并说明原因。

不允许做的事：

- 不新增功能。
- 不重做 UI。
- 不改算法。
- 不接服务端、在线 AI 或真实本地 LLM。
- 不做付费订阅。

Codex 执行 Prompt 草案：

```text
请只完成 DestinyScope V1.1 阶段 7：V1.1 自测与文档更新。运行 Debug/Release 构建，检查主流程、问答、知识库、历史记录、隐私和离线能力，输出 docs/V1_1_TestFlightChecklist.md，并更新相关清单。除阻断性小 bug 外不要改源码。
```

验收标准：

- Debug 构建通过。
- Release 构建通过。
- 离线能力检查通过。
- 文案合规检查通过。
- V1.1 测试清单存在。
- 未解决问题被明确记录。

建议 commit message：

```text
Document V1.1 preflight checks
```
