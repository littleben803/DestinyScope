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

## V1.8 阶段 3B：生产候选自测与上线风险决策

状态：

- 已完成生产候选自测与上线风险收口。
- 已新增 `docs/V1_8_ProductionCandidateTestReport.md`。
- 已新增 `docs/V1_8_ReleaseRiskDecision.md`。
- 本阶段只修改 docs。
- 未修改 Swift 代码、Xcode 工程配置、资源文件、模型文件、CSV、JSON、签名配置、Bundle ID、Version 或 Build。
- Debug build：通过。
- Release build：通过。
- 决策结论：Production Candidate: Conditional Go。
- 当前仍不得上传 App Store。
- 当前仍不建议上传 TestFlight，除非用户下一步明确要求并重新执行 TestFlight readiness。

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

- Debug / Release build 通过：已通过。
- App size 风险记录：已记录 Release Simulator `.app` 约 `502M`，仍需真实 Archive / IPA / App Store 分发体积。
- license / notice 状态记录：已记录仍需人工最终复核。
- iPhone 17 Pro Max 和 iPhone 12 mini 行为符合设备评分预期：代码策略符合预期，但真机生产包待复测。
- 模拟器默认启用符合预期：设备评分策略符合预期，Release 产物包含模型和 framework；模拟器 UI 运行待复测。
- 低电量 / 过热 / 超时 / 安全失败回退符合预期：代码路径符合预期，真机状态待复测。
- 首页第一屏验收通过：代码结构符合目标，仍需小屏 / 高端真机人工复测。
- 下一步 Go / No-Go 清晰：Conditional Go，进入真机生产包复测。

建议 commit message：

- `docs: add v1.8 production candidate decision`

## V1.8 阶段 4：真机生产包复测与上线前材料修复

目标：

- 在真机生产构建中复测内置模型、framework、设备评分和 fallback。
- 记录高端设备与低端设备的实际行为。
- 复核 license / notice、App size、隐私 URL、Review Notes、截图和 App Store 元数据。
- 决定是否进入 TestFlight readiness 或继续修复。

允许修改范围：

- 真机复测记录。
- release readiness 报告。
- checklist。
- 隐私、开源许可、Review Notes、元数据文档。
- 明确阻断 bug 的最小修复。

不允许做的事：

- 不上传 TestFlight，除非用户明确要求。
- 不上传 App Store。
- 不创建 App Store Connect 记录。
- 不修改签名、Bundle ID、Version / Build，除非用户明确要求。
- 不接服务端、在线 AI、模型下载、RAG、开放聊天、流式 UI 或付费订阅。

验收标准：

- iPhone 17 Pro Max 生产内置模型加载、润色和 fallback 记录完整。
- iPhone 12 mini 生产内置模型默认禁用 / 回退记录完整。
- 低电量、过热、模型缺失、framework 不可用、超时和安全失败路径有记录。
- Archive / IPA / 安装体积有记录。
- license / notice 人工确认状态清晰。
- 是否进入 TestFlight readiness 的决策清晰。

建议 commit message：

- `docs: add v1.8 device production qa records`

## V1.8 阶段 5：上线前材料修复

状态：

- 已完成上线前材料修复。
- 已新增 `DestinyScope/Resources/PrivacyInfo.xcprivacy`。
- 已新增 `docs/V1_8_AppStoreConnectDraft.md`。
- 已新增 `docs/V1_8_PrivacyNutritionLabelDraft.md`。
- 已新增 `docs/V1_8_AppReviewNotesFinalDraft.md`。
- 已新增 `docs/V1_8_ScreenshotAndCopyPlan.md`。
- 已新增 `docs/V1_8_LicenseNoticeFinalChecklist.md`。
- 已新增 `docs/V1_8_PreLaunchMaterialsReport.md`。
- 已更新 App 内隐私政策、免责声明、开源许可页面。
- 已更新 GitHub Pages 隐私 Markdown / HTML。
- 已更新 App Store metadata、Review Notes、Screenshot Plan、App Store / TestFlight checklist。

目标：

- 修复 V1.8 App Store Connect 文案、Review Notes、Privacy Nutrition Label、PrivacyInfo、Legal 文案、开源许可、隐私页、截图计划和上线清单。
- 保持业务逻辑、签名、Bundle ID、Version / Build、模型接入和默认路径不变。

验收标准：

- `PrivacyInfo.xcprivacy` 声明 UserDefaults 和 FileTimestamp required reason API。
- App Store 文案不含确定性预测、改命、化解、避灾或专业建议承诺。
- Review Notes 正确描述本地模型生产候选能力和 fallback。
- 隐私页与 App 内隐私政策同步。
- 开源许可页面记录 llama.cpp、GGUF、Qwen base、GGUF 仓库和精确 GGUF 文件。
- Debug / Release build 通过。
- 静态扫描无新增网络、支付、追踪、敏感权限风险。

建议 commit message：

- `docs: prepare v1.8 prelaunch materials`

## V1.8 阶段 6：Archive / App Store Connect 准备前最终检查

目标：

- 生成并验证 Archive。
- 确认 `PrivacyInfo.xcprivacy` 进入最终 Archive / IPA。
- 记录 Archive / IPA / App Store 分发体积。
- 真机复测高端设备默认本地润色和低端设备 fallback。
- 完成 license / notice 人工最终留档。
- 决定是否进入 TestFlight readiness 或 App Store Connect 手工填写。

## V1.8 阶段 8：上线前用户可见文案清理

状态：

- 已完成 App 内用户可见文案清理。
- 已新增 `docs/V1_8_UserFacingCopyCleanupReport.md`。
- 已更新 About / Settings / Open Source Licenses / Privacy Policy 相关文案。
- 已将 Open Source Licenses 展示从内部状态字段改为正式 license 信息字段。
- 已同步 GitHub Pages 隐私 Markdown / HTML、App Store metadata、Review Notes、Screenshot Plan 和 App Store Connect 填写草稿。

边界：

- 未修改业务逻辑、本地模型运行逻辑、设备评分、结果页、历史记录或首页主结构。
- 未修改 Xcode 工程配置、签名、Bundle ID、Version、Build、模型文件或 framework。
- 未接入网络、服务端、在线 AI、模型下载、付费订阅、追踪或敏感权限。

验收标准：

- Release 用户可见 Swift 页面不展示内部状态词。
- Debug-only 页面仍仅保留在 `#if DEBUG` 内。
- `git diff --check` 通过。
- Debug / Release build 通过。
