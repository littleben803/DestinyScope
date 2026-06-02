# DestinyScope V1.8 Roadmap

## V1.8 阶段 1：生产本地 AI 与首页主路径方案冻结

状态：

- 已完成方案冻结。
- 本阶段只修改 docs。
- 不修改 Swift 代码、工程配置、资源、CSV、JSON、依赖或模型文件。

目标：

- 明确 V1.8 产品方向变更。
- 将本地模型从 Debug 实验路径升级为生产候选能力。
- 冻结模型内置、设备评分、默认启用、失败回退和首页第一屏策略。

允许修改范围：

- `docs/V1_8_ProductionLocalAIPlan.md`。
- `docs/V1_8_DeviceScoringPlan.md`。
- `docs/V1_8_BundledModelPlan.md`。
- `docs/V1_8_HomeFirstScreenPlan.md`。
- `docs/V1_8_Roadmap.md`。
- checklist 和项目状态文档。

不允许做的事：

- 不修改 Swift 代码。
- 不修改 UI 页面。
- 不修改 Xcode 工程配置。
- 不提交模型文件。
- 不提交 `llama.xcframework`。
- 不接服务端、在线 AI、模型下载、RAG、付费订阅、开放聊天或流式 UI。

验收标准：

- V1.8 方向变更清晰。
- 旧边界覆盖范围清晰。
- 仍保留的安全边界清晰。
- 阶段 2 / 3 / 4 拆分清晰。

建议 commit message：

- `docs: freeze v1.8 production local ai plan`

## V1.8 阶段 2：模型内置、llama framework 生产化、设备评分默认启用

状态：

- 已完成。
- 根据用户“加快进度，缩短阶段”的明确要求，本阶段同时完成首页第一屏重构和结果页本地润色默认接入。
- 已新增 `docs/V1_8_ProductionLocalAIImplementationReport.md`。
- Debug build：通过。
- Release build：通过。
- 旧的手工 `Embed llama.xcframework` 脚本阶段已移除，改由 Xcode 标准 `ProcessXCFramework` 处理。
- `makeDefaultRefiner()` 已在 V1.8 范围内调整为 `AutoLocalTextRefiner()`：设备评分达标时走本地模型，不达标或失败时回退模板。
- 模板结果始终保留，本地模型只做表达润色，不生成新的命理结论。

目标：

- 将 `qwen2.5-0.5b-instruct-q4_k_m.gguf` 作为生产候选内置模型。
- 使用 Git LFS 管理指定 GGUF。
- 将 llama framework 从 Debug-only 接入调整为生产候选可用路径。
- 实现设备评分。
- 设备评分达标时默认启用本地 AI 润色。
- 模拟器默认启用。
- 不达标、低电量、过热、模型缺失、framework 缺失、超时或安全检查失败时回退模板。

允许修改范围：

- 模型文件路径和 Git LFS 配置。
- `.gitattributes`。
- `.gitignore` 的指定模型例外。
- Xcode Copy Bundle Resources。
- 本地模型 resolver。
- 设备评分服务。
- 本地 AI 可用性判断。
- 本地文本润色 fallback 逻辑。
- docs / checklist。

不允许做的事：

- 不接服务端。
- 不请求网络。
- 不做模型下载。
- 不接在线 AI。
- 不做 RAG。
- 不做开放聊天。
- 不做流式 UI。
- 不让模型生成命理结论。
- 不上传用户数据。
- 不做付费订阅。

验收标准：

- Debug build 通过。
- Release build 通过。
- 指定 GGUF 由 Git LFS 跟踪。
- 非指定模型临时文件仍被忽略。
- App Bundle 可以解析内置模型。
- 模拟器默认启用本地 AI 润色。
- 高分设备默认启用。
- iPhone 12 mini / `iPhone13,1` 默认使用模板。
- `makeDefaultRefiner()` 的默认语义如需调整，必须只在 V1.8 生产本地 AI 范围内调整，并记录新默认策略。
- 模型失败、超时或安全检查失败回退模板。

建议 commit message：

- `feat: enable bundled local ai refiner candidate`

## V1.8 阶段 3：首页第一屏重构、结果页本地润色默认接入

状态：

- 核心实现已并入 V1.8 阶段 2。
- 后续如继续执行本阶段，只做人工回归、细节修正或文案微调，不再重复接入默认路径。

目标：

- 首页第一屏聚焦生辰查询。
- 查询按钮尽量首屏可见。
- Hero、隐私长文、最近历史和知识库入口后置或压缩。
- 结果页展示本地润色版。
- 模板结果始终保留。
- 本地润色不生成命理结论，不写入历史记录。

允许修改范围：

- `HomeView` 和首页轻量组件。
- `DestinyResultView` 和本地润色展示组件。
- 本地润色状态展示。
- 文案和可访问性 label / hint。
- docs / checklist。

不允许做的事：

- 不改称骨计算。
- 不改诗文匹配。
- 不改 `LifeWeightInsight` 规则。
- 不改命理问答结论。
- 不自动查询。
- 不上传用户数据。
- 不接服务端、在线 AI、模型下载、RAG、开放聊天、流式 UI 或付费订阅。

验收标准：

- 首页第一屏以查询为中心。
- 小屏查询按钮尽量首屏可见。
- 模板结果始终保留。
- 本地润色版标注“表达润色，不改变命理结论”。
- 失败回退模板。
- 本地润色结果不写入历史。
- Debug / Release build 通过。

建议 commit message：

- `feat: surface local refined result and focus home query`

## V1.8 阶段 4：生产候选自测与上线风险决策

目标：

- 完成 V1.8 自测。
- 记录包体、性能、设备评分、fallback、安全检查、首页首屏和结果页展示。
- 判断是否进入 TestFlight / App Store 准备，或继续产品修复。

允许修改范围：

- 测试报告。
- 决策文档。
- checklist。
- 明确阻断 bug 的最小修复。

不允许做的事：

- 不上传 TestFlight。
- 不创建 App Store Connect 记录。
- 不修改签名、Bundle ID、Version / Build，除非用户明确要求。
- 不接服务端、在线 AI、模型下载、RAG、开放聊天、流式 UI 或付费订阅。

验收标准：

- Debug / Release build 通过。
- App size 风险记录。
- license / notice 状态记录。
- iPhone 17 Pro Max 和 iPhone 12 mini 行为符合设备评分预期。
- 模拟器默认启用符合预期。
- 低电量 / 过热 / 超时 / 安全失败回退符合预期。
- 首页第一屏验收通过。
- 下一步 Go / No-Go 清晰。

建议 commit message：

- `docs: add v1.8 production candidate decision`
