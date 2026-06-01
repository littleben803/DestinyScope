# DestinyScope App Store 上架检查清单

更新日期：2026-05-27

## 1. App Icon

当前状态：

- `ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon` 已配置。
- `AppIcon.appiconset/Contents.json` 已引用 `AppIcon-1024.png`。
- `DestinyScope/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png` 已存在。
- 当前工程内 App Icon 尺寸为 1024x1024。
- 当前工程内 App Icon 无 alpha 通道。

上架前待办：

- 人工确认 App Icon 为原创或已授权素材。
- 真机检查小尺寸下主体是否清晰可识别。
- 如需单独适配 dark/tinted 图标，可后续提供专门资源；当前先复用同一 1024 图标。

## 2. Launch Screen

当前状态：

- 工程使用 `INFOPLIST_KEY_UILaunchStoryboardName = LaunchScreen` 指向自定义启动页。
- 已新增 `DestinyScope/LaunchScreen.storyboard`。
- 启动页为静态布局：宣纸米白背景、居中 `DestinyScope`、副标题 `东方命理 · 自我探索`。
- 启动页不包含广告、复杂动画、网络图片或高风险营销文案。

上架前待办：

- 在 iPhone 和 iPad 真机或模拟器上检查启动页居中、文字可读、与首页视觉一致。
- 如后续增加 Logo，只使用原创或已授权素材。

## 3. 隐私政策

当前状态：

- App 内已有隐私政策页入口。
- 文案已覆盖无账号、无登录、出生信息本地处理、不上传、无服务端、无在线 AI、无广告追踪、无敏感权限等 V1 特性。
- 已准备 GitHub Pages 静态隐私政策网页文件：`docs/privacy/index.html`。
- 已准备隐私政策 Markdown 源文件：`docs/privacy/privacy.md`。
- 目标公开 URL 已规划为 `https://littleben803.github.io/DestinyScope/privacy/`。

上架前待办：

- 在 GitHub 仓库中启用 GitHub Pages，并确认公网 URL 可访问。
- 将 `https://littleben803.github.io/DestinyScope/privacy/` 填入 App Store Connect 的 Privacy Policy URL。
- 确认隐私政策 URL 内容与 App 内文案一致。
- 如未来加入联网、账号、AI、订阅、数据同步，需要同步更新。

## 4. 免责声明

当前状态：

- App 内已有免责声明页入口。
- 结果页已有短免责声明提示。
- 文案说明结果仅供娱乐、自我探索和传统文化学习参考。
- 文案明确不构成医疗、法律、财务、投资、婚恋、职业等现实决策建议。

上架前待办：

- 确认 App Store 元数据不宣传精准预测未来。
- 确认截图和描述不包含恐吓式、绝对化、医疗、投资、婚姻确定性承诺。

## 5. 无服务端说明

当前状态：

- V1 产品规划和隐私政策都说明无服务端。
- 静态扫描未发现 `URLSession`、HTTP URL、网络连接库或服务端请求代码。

上架前待办：

- 在 App Store 审核备注中可说明：出生信息仅在设备端处理，V1 无账号、无服务端、无数据上传。
- 真机断网测试核心功能是否可用。

## 6. 无在线 AI 说明

当前状态：

- V1 使用本地模板式命理师解读。
- 隐私政策说明不接在线 AI，不使用真实本地 LLM 推理。
- 静态扫描未发现 OpenAI SDK、在线 AI SDK 或本地 LLM 推理接入。

上架前待办：

- App Store 元数据避免暗示真实 AI 在线推理。
- 如果使用“AI 命理师”措辞，应明确是本地模板式解读或改为“命理师解读”。

## 7. 数据本地处理说明

当前状态：

- 称骨算命数据来自 App Bundle 内置 CSV。
- 知识库来自 App Bundle 内置 JSON。
- 出生日期和时辰仅用于本地计算。
- V1.1 本地历史记录仅保存在设备端 Application Support 目录，不上传、不联网、不接账号或 iCloud 同步。

上架前待办：

- 在隐私政策 URL、App 内隐私页、审核备注中保持一致描述。
- 真机断网测试核心功能是否可用。

## 8. 版权素材检查

当前状态：

- 本地知识库文案为项目内原创整理。
- App Icon 已接入工程，但素材授权状态需要用户人工确认。
- Launch Screen 当前只使用静态背景色和系统文本，不包含外部图片。

上架前待办：

- 确认 App Icon、截图背景、任何图形纹样均为原创、已授权或系统资源。
- 不使用来源不明的网络图、未经授权字体、第三方图标或含版权争议的传统纹样素材。
- 本地知识库文案保持原创、简短、通俗，不复制来源不明的大段网络内容。

## 9. 构建 Warning 检查

当前状态：

- 已确认 `DestinyScope/Lib` 目录不存在。
- 已从 Debug 和 Release 的 `LIBRARY_SEARCH_PATHS` 中移除 `$(PROJECT_DIR)/DestinyScope/Lib`。
- `LIBRARY_SEARCH_PATHS` 仍保留 `$(inherited)` 和 `$(PROJECT_DIR)/DestinyScope`。
- 2026-05-26 阶段 12A 检查中，Debug 和 Release 模拟器构建均已通过。
- 2026-05-27 V1.1 阶段 7 检查中，Debug 和 Release 模拟器构建均已通过。
- `DestinyScope/Lib search path not found` warning 未复现。
- 当前 V1.1 阶段 7 构建日志未发现新增 warning 或 error。

上架前待办：

- 上架前继续关注新增 warning，确保 Release Archive 无阻断性 warning 或 error。

## 10. TestFlight 前真机检查

待办：

- 真机安装后检查 App Icon 是否清晰。
- 检查 Launch Screen 是否与首页视觉一致，且在 iPhone/iPad 上居中显示。
- 检查浅色/深色模式可读性。
- 检查首页输入、结果页、知识库、关于页、隐私政策、免责声明完整链路。
- 断网启动并完成一次计算，确认无网络依赖。
- 检查 App 不请求定位、相机、相册、通讯录、麦克风等权限。
- 检查 App Store 截图和描述不包含绝对预测、恐吓式内容、医疗/投资/婚姻确定性承诺。
- 检查版本号、构建号、Bundle ID、签名 Team 是否正确。

## 11. App Store 元数据与审核材料

当前状态：

- 已准备 `Docs/AppStoreMetadata.md`，包含 App 名称、副标题、宣传文本、描述、关键词、分类建议和高风险词避让清单。
- 已准备 `Docs/AppReviewNotes.md`，包含中英文审核备注、无需测试账号说明、数据处理说明、网络说明、权限说明、免责声明和审核员测试步骤。
- 已准备 `Docs/ScreenshotPlan.md`，包含 5 到 6 张截图的页面、标题、副文案和注意事项。
- `Docs/AppStoreMetadata.md` 中的隐私政策 URL 已更新为 `https://littleben803.github.io/DestinyScope/privacy/`。

上架前待办：

- 在 App Store Connect 中创建 App 记录。
- 将元数据按 App Store Connect 字段长度限制做最终裁剪。
- 上传实际截图。
- 确认截图、描述、关键词、审核备注都不包含高风险承诺文案。

## 12. 当前缺失资源和人工确认项

- 启用 GitHub Pages 并确认隐私政策公网 URL 可访问。
- 将隐私政策 URL 填入 App Store Connect。
- App Icon 素材原创或授权确认。
- Launch Screen 真机截图确认。
- App Store Connect 创建 App。
- App Store 上架截图上传。
- 真机断网完整主流程测试。
- Bundle ID、签名 Team、版本号、构建号最终确认。

## 13. V1.1 规划状态

当前状态：

- 已准备 `docs/V1_1_ProductPlan.md`，明确 V1.1 是离线体验增强版，不接服务端、在线 AI 或真实本地 LLM。
- 已准备 `docs/V1_1_Roadmap.md`，将 V1.1 拆分为结果页增强、命理问答、知识库扩充、本地历史记录、小模型润色接口预留和自测阶段。
- 已准备 `docs/V1_1_KnowledgePlan.md`，规划知识库从 5 篇扩充到至少 20 篇，并为未来 RAG 保留资料结构。
- V1.1 阶段 4B 已将本地知识库扩充到 29 篇，并新增 `DestinyScope/Resources/Knowledge/rag_chunks.json` 作为未来本地 RAG 预留数据。
- V1.1 阶段 5 已新增本地历史记录能力，记录仅保存到设备本地 Application Support 目录，不上传、不联网、不接账号或 iCloud 同步。
- V1.1 阶段 6 已新增本地小模型文本润色接口预留，当前默认仍使用 `TemplateTextRefiner`，不接真实模型、不接 Core ML、MLX、llama.cpp、不下载模型、不请求网络。
- V1.1 阶段 7 已完成自测报告：`docs/V1_1_TestReport.md`。
- V1.1 阶段 7 检查确认：Debug / Release 构建通过，知识库 29 篇，RAG chunks 29 条，未发现网络请求、真实模型接入、权限申请、支付或广告追踪引用。

V1.1 上架风险提醒：

- 即使后续出现“命理问答”入口，也必须保持本地模板回答，不声称真实在线 AI。
- 即使后续预留本地小模型接口，也不能在元数据中宣传真实 AI 推理，除非对应功能已经真实实现并完成隐私更新。
- 本地历史记录上线前需要确认隐私政策是否需要补充“历史记录仅保存在设备端”。
- 建议上架前补充 App 内隐私政策和 GitHub Pages 隐私政策，明确“历史记录仅保存在本地设备，可由用户删除，不上传、不同步”。
- 如果后续新增历史记录同步、账号或云备份，需要同步更新隐私政策和 App Store 隐私说明。
- 如果后续接入真实本地小模型，需要重新评估包体、耗电、设备兼容、隐私政策和审核备注，且模型只能负责文本润色，不能生成命理计算结论。

## 14. V1.2 本地小模型 PoC 状态

当前状态：

- V1.2 已进入本地 0.5B 到 1.5B 小模型 PoC 规划阶段。
- 已准备 `docs/V1_2_LocalLLMResearch.md`，对比 llama.cpp + GGUF、Core ML、MLX Swift 三条路线。
- 已准备 `docs/V1_2_PoCPlan.md`，明确 PoC 只验证本地润色能力，不影响当前主流程。
- 已准备 `docs/V1_2_Roadmap.md`，将 V1.2 拆分为调研、模型 license 检查、Debug-only 集成、TextRefining 接入、安全过滤、设备测试和生产决策。
- 已准备 `docs/V1_2_ModelCandidates.md`，记录候选模型、GGUF / 4-bit 可用性、中文能力、license 和再分发风险。
- 已准备 `docs/V1_2_LlamaCppPoCGuide.md`，记录 llama.cpp Debug-only PoC 骨架、后续 3B 指标和安全边界。
- 推荐 PoC 路线为 llama.cpp + GGUF；MLX Swift 作为备选；Core ML 作为长期评估方向。
- V1.2 阶段 2 初步推荐 P0 模型为 `Qwen2.5-0.5B-Instruct`，备选为 `Qwen2.5-1.5B-Instruct-GGUF`。
- V1.2 阶段 3A 已新增 Debug-only 本地模型 PoC 入口和 `LocalLlamaTextRefiner` 骨架。
- V1.2 阶段 3A 未接入 llama.cpp Swift Package，未加载 GGUF，未执行真实推理，未提交任何模型文件。
- Release 下不应展示本地模型 PoC 入口；默认 TextRefiner 仍为 `TemplateTextRefiner`。
- `.gitignore` 已增加 GGUF、bin、safetensors、Core ML 模型和本地模型目录忽略规则。
- 2026-05-27 V1.2 阶段 3A 检查中，Debug 和 Release 模拟器构建均已通过。
- V1.2 阶段 3B 已新增 `docs/V1_2_ModelFileSetup.md` 和 `docs/V1_2_LlamaCppIntegrationPlan.md`，确认模型文件准备、license 检查清单和 llama.cpp 接入路线。
- V1.2 阶段 3B 仍未下载模型、未接入 llama.cpp 依赖、未加载真实模型、未修改生产路径。
- V1.2 阶段 3D 已修复 Codex shell 的 CMake PATH 问题，并在仓库外构建 `~/LocalModels/DestinyScope/llama.xcframework`。
- V1.2 阶段 3D 已以 Debug-only 方式接入仓库外 `llama.xcframework`，默认 `TextRefiner` 仍为 `TemplateTextRefiner`。
- V1.2 阶段 3D 已通过仓库外 macOS smoke test 和 iOS Simulator Debug UI 验证同一个 GGUF 文件可以真实加载并生成短文本。
- 2026-05-27 V1.2 阶段 3D 检查中，Debug 和 Release 模拟器构建均已通过；未新增模型文件、llama.cpp 源码或 `llama.xcframework` 到仓库。
- V1.2 阶段 4 已将本地 llama.cpp PoC 接入 `TextRefining` 抽象，只在 Debug-only 实验入口中测试，不影响默认输出。
- V1.2 阶段 4 已新增 PromptBuilder、SafetyRules 和 SafetyChecker；Debug UI 可触发 `LocalLlamaTextRefiner.refine` 并显示引擎、耗时、安全提示和回退状态。
- V1.2 阶段 5 已优化提示词和安全过滤，新增 Debug-only 固定安全测试样例，安全检查失败时回退到本地模板文本。
- V1.2 阶段 5 已新增 `docs/V1_2_SafetyEvaluation.md`，记录 Prompt 约束、安全检查、回退策略和生产前要求。
- V1.2 阶段 6 已新增 Debug-only 设备性能测试准备，包括固定 benchmark 样例、单条 / 批量运行和结果摘要复制能力。
- V1.2 阶段 6 已新增 `docs/V1_2_DeviceBenchmark.md`，用于人工记录真机加载、生成、内存、耗电和发热结果。
- V1.2 阶段 6A 已新增 Debug-only GGUF 文件导入能力，真机可从 Files App 选择模型并复制到 App Documents 沙盒；Release 不展示该入口。
- V1.2 阶段 6B 已完成一台 iPhone 的 Debug-only 真机 benchmark：0.5B Q4 模型正常样例平均 total 约 `1.09` 秒，高风险样例可触发 fallback。
- V1.2 阶段 7 已完成生产路径决策文档：`docs/V1_2_ProductionDecision.md`。
- V1.2 最终结论为 Conditional Go：PoC 成功，但不直接进入生产路径；下一步建议进入 V1.3 生产化方案设计。
- V1.2 阶段 7B 已补充双设备 benchmark：iPhone 17 Pro Max 约 1 秒级，iPhone 12 mini 可运行但正常短文本可能达到 4 到 5 秒。
- V1.2 PoC 已完成，最终决策为 Conditional Go，不直接进入生产路径。
- V1.3 已进入本地模型生产化方案设计阶段，当前只新增规划文档，不修改生产代码。
- 真实本地模型尚未接入生产路径。
- 当前 App 默认仍使用本地规则和模板输出，不接在线 AI，不接真实本地 LLM，不下载模型。

V1.2 上架风险提醒：

- V1.2 PoC 不应进入 App Store 生产版本，除非完成性能、license、隐私、文案安全和人工验收。
- 当前本地模型只完成 Debug-only 真机 PoC，隐私政策和 App Store 元数据仍不应宣传本地 AI 功能。
- 当前本地模型仍不是 Release 功能，不应在当前 App Store 元数据、截图、关键词或审核备注中宣传 AI、本地模型或本地 LLM。
- iPhone 12 mini / A14 级别设备性能较慢，未来生产化必须做设备分级，不宜默认全量开启。
- 如果未来接入真实本地模型，需要更新 App 内隐私政策、GitHub Pages 隐私政策、App Store 元数据和审核备注。
- 如果未来进入生产路径，需要补充本地模型处理说明、模型 license / notice、商业使用、再分发、App 内分发条件和安全回退说明。
- 如果模型文件随 App 分发，需要人工确认模型 license 允许 App 分发和商业使用。
- 如果未来进入生产路径，需要补充本地模型处理说明、模型 license / notice、商业使用、再分发和 App 内分发确认。
- Gemma 3 1B、Llama 3.2 1B 等非 Apache 或 gated/license 复杂模型，必须人工确认使用、商用、再分发、署名和 acceptable use 条款后才能进入 PoC 或生产。
- V1.2 阶段 3 如使用模型文件，只允许开发者手动下载到本地 Debug 测试环境，不提交仓库，不进入 Release 默认路径。
- 进入生产路径前必须人工确认目标 GGUF 的 license、notice、商业使用、再分发和 App 内分发条件。
- App Store 元数据不得提前宣传真实 AI 推理，不得宣称精准预测、改命、化解或确定性现实建议。
- 本地模型只能润色已生成文本，不能负责命理计算、农历转换、称骨权重、诗文匹配或最终命理结论。

## 15. V1.3 本地模型生产化方案状态

当前状态：

- 已准备 `docs/V1_3_LocalModelProductionPlan.md`，建议本地模型只作为默认关闭的可选实验功能，不进入默认主流程。
- 已准备 `docs/V1_3_ModelDistributionPlan.md`，记录内置模型、手动导入和按需下载三种分发路线。
- 已准备 `docs/V1_3_PrivacyAndReviewPlan.md`，记录未来需要补充的隐私政策、审核备注、元数据限制和 license / notice 要求。
- 已准备 `docs/V1_3_Roadmap.md`，将 V1.3 拆分为生产化方案、设备分级、TestFlight 开关、润色入口、隐私审核草案、license 审计和 TestFlight 决策。
- 已准备 `docs/V1_3_DeviceTierPlan.md`，记录本地模型生产化必须按设备分级。
- 已准备 `docs/V1_3_TestFlightExperimentPlan.md`，记录 TestFlight 本地模型润色实验开关设计。
- 已准备 `docs/V1_3_LocalRefiningEntryPlan.md`，推荐结果页底部“本地润色预览”卡片作为 TestFlight 可选入口。
- 已准备 `docs/V1_3_PrivacyPolicyDraft.md`，记录当前 Release、本地模型实验和未来模型下载的隐私政策草案。
- 已准备 `docs/V1_3_AppReviewNotesDraft.md`，记录 TestFlight 和 App Store 审核备注草案。
- 已准备 `docs/V1_3_MetadataGuidelines.md`，记录 App Store 元数据和截图文案限制。
- 已准备 `docs/V1_3_LicenseNoticeAudit.md`，记录 Qwen2.5、GGUF、llama.cpp 和 ggml / gguf 的 license / notice 审计。
- 已准备 `docs/V1_3_TestFlightDecision.md`，结论为允许进入受限 TestFlight 内测实现准备，但 App Store 正式发布仍为 No-Go。
- iPhone 12 mini / A14 级别设备暂不建议默认开启本地模型，未来生产化应默认关闭或禁用。
- 真实本地模型仍不是当前 Release 功能。
- 当前 App Store 元数据仍不应宣传 AI、本地模型或本地 LLM。
- 当前 App Store Release 不应展示或宣传本地模型实验功能。
- TestFlight 内测若开放，需要在审核备注中说明本地处理、默认关闭、只做文本润色和失败回退机制。
- TestFlight 内测若开放，需要同步使用隐私草案说明：不上传出生信息、命理结果、模型输入输出或历史记录。
- 如果未来 TestFlight 开启本地润色入口，仍不得在 App Store 正式元数据中宣传为 AI 算命。
- 本地润色不生成命理结论，不替代称骨计算、农历转换、诗文匹配或命理问答结论。
- 如果未来开放生产功能，需要正式更新 App 内隐私政策、GitHub Pages 隐私页、App Store 元数据和 Review Notes。
- 进入 TestFlight 或 App Store 前必须完成 license / notice 人工确认。
- 当前 Release 不含模型和 `llama.xcframework`，因此当前正式版不应宣传本地模型。
- 如果未来包含模型或 framework，需要 App 内“开源许可”入口或等价 notice 展示。
- TestFlight 内测前需要完成 license / notice、隐私说明、设备分级、回退机制和测试说明。
- App Store 正式发布仍为 No-Go，正式元数据不得宣传 AI / 本地模型。
- V1.4 已进入 TestFlight 本地模型内测实现准备阶段，仅新增实现拆解和风险文档。
- V1.4 阶段 2 已新增本地模型润色实验开关配置；当前只是开关状态和说明页，不调用模型，不接结果页。
- V1.4 阶段 3 已新增设备 tier 检测最小实现；实验设置页会展示设备 identifier、tier、是否允许和推荐超时。
- `unknown` 和 Tier C 设备默认不允许本地模型实验。
- `iPhone13,1` / iPhone 12 mini 按当前策略归入 Tier C，默认禁用。
- Simulator 仅允许 Debug 测试，不代表真机性能。
- V1.4 阶段 4 已新增模型文件可用性检测；当前只检测 App Documents 和开发者本地路径，不下载模型，不接结果页。
- 模型导入仅复制用户选择的 `.gguf` 到 App Documents，不上传、不联网、不写入 Bundle。
- V1.4 阶段 5 已新增结果页底部“本地润色预览”实验卡片；该卡片只在实验条件满足时展示。
- 本地润色预览不覆盖原始结果、不写入历史记录、不进入默认输出路径。
- 本地润色预览由用户手动触发，不自动生成，也不上传模型输入输出。
- V1.4 阶段 6 已为本地润色预览增加低电量、过热、超时和连续失败回退保护。
- 运行时保护只影响实验卡片，不进入默认输出路径；失败时继续保留原始模板文本。
- V1.4 阶段 7 已新增 App 内“开源许可”页面，覆盖 llama.cpp、ggml / GGUF、Qwen2.5-0.5B-Instruct / GGUF 的许可草案。
- V1.4 阶段 7 已更新 App 内隐私政策，补充本地历史记录和本地模型润色实验说明。
- V1.4 阶段 7 已更新 GitHub Pages 隐私页文件：`docs/privacy/index.html` 和 `docs/privacy/privacy.md`。
- 本地模型进入 TestFlight 或 App Store 分发前，仍必须人工确认 license / notice、实际 GGUF 来源、商业使用、再分发和 App 内分发条件。
- 当前正式 Release 仍不包含本地模型正式功能。
- 当前 App Store 元数据仍不宣传 AI / 本地模型。
- Release 默认不展示本地模型润色实验入口。
- 默认输出路径不变，`makeDefaultRefiner()` 仍应返回 `TemplateTextRefiner`。
- V1.4 阶段 8 已新增 `docs/V1_4_TestFlightReadinessReport.md` 和 `docs/V1_4_TestFlightDecision.md`。
- V1.4 TestFlight 决策为 Conditional Go for internal TestFlight preparation。
- 公开 App Store 发布仍为 No-Go。
- 默认启用本地模型仍为 No-Go。
- 替换默认结果页输出仍为 No-Go。
- TestFlight 上传前仍需确认 Apple Developer Program、Bundle ID、Signing、Team、Version、Build、Release Archive、GitHub Pages 公网隐私 URL、license / notice、App Icon 授权和测试人员说明。

V1.3 后续必须完成：

- V1.4 / TestFlight 本地模型内测实现准备。

## 16. V1.4 TestFlight 本地模型内测实现准备

当前状态：

- 已准备 `docs/V1_4_TestFlightImplementationPlan.md`，拆解实验开关、设备 tier、模型检测、润色卡片、回退、开源许可和隐私说明。
- 已准备 `docs/V1_4_Roadmap.md`，将 V1.4 拆为 8 个小阶段。
- 已准备 `docs/V1_4_RiskChecklist.md`，覆盖技术、设备、隐私、审核、license、用户误解、输出安全、包体和回退风险。
- 当前阶段未修改 Swift 代码、工程配置、资源、依赖或模型文件。

V1.4 进入实现前仍必须确认：

- license / notice。
- 隐私说明。
- 设备分级。
- 失败回退。
- TestFlight 测试说明。
- 模型不会误提交仓库。

## 17. V1.5 产品体验优化状态

当前状态：

- V1.5 进入产品体验优化与上架前产品打磨阶段。
- 当前不准备上传 TestFlight。
- 当前不准备 App Store 上架。
- 本地模型仍不是正式发布功能。
- 默认输出路径仍应保持本地规则引擎和模板系统。
- `makeDefaultRefiner()` 仍不得改为默认返回本地模型实现。
- 已准备 `docs/V1_5_ProductExperiencePlan.md`，冻结 V1.5 目标、P0 / P1 和明确不做事项。
- 已准备 `docs/V1_5_Roadmap.md`，将 V1.5 拆分为 source-control、UX 审计、结果页、知识库、历史、Legal、适配、截图文案和自测决策阶段。
- 已准备 `docs/V1_5_UXAuditPlan.md`，定义页面审计范围、维度和输出格式。
- 已准备 `docs/V1_5_QualityGate.md`，定义构建、静态扫描、source-control 和人工测试质量门槛。

V1.5 P0 风险：

- `.gitignore` 中 `Models/` 规则误伤 Swift 源码目录的问题已在 V1.5 阶段 2 修复。
- `DestinyScope/Domain/Models/OpenSourceLicenseItem.swift` 已不再被忽略，并已加入 git 索引。
- 未来新增 `DestinyScope/Domain/Models/*.swift` 不应再被 `Models/` 规则误忽略。
- `LocalModels/`、`/Models/`、`DestinyScope/LocalModels/`、模型扩展名和 `*.xcframework` 规则仍继续保护本地模型 / framework 文件不进入仓库。
- 当前仓库扫描未发现 `.gguf`、`.bin`、`.safetensors`、`.mlmodel`、`.mlmodelc` 或 `.xcframework`。
- 已新增 `docs/V1_5_SourceControlAudit.md` 记录 source-control 审计结果。

V1.5 上架风险提醒：

- 当前 App Store 元数据仍不应宣传 AI / 本地模型。
- 当前正式 Release 仍不应展示本地模型实验入口。
- V1.5 只优化普通用户路径和产品体验，不扩大本地模型生产化范围。
- 如后续恢复 TestFlight 或 App Store 上架准备，必须重新执行 V1.4 readiness 检查。

V1.5 UI / UX 审计状态：

- V1.5 阶段 3 已完成 UI / UX 全量审计。
- 已新增 `docs/V1_5_PageInventory.md`。
- 已新增 `docs/V1_5_UXAuditReport.md`。
- 已新增 `docs/V1_5_UXIssueBacklog.md`。
- 下一步会优先优化结果页阅读体验、知识库浏览、历史记录和 Legal 体验。
- 本地模型仍不是默认功能，后续优化只能改善受控实验说明和预览体验，不能把本地模型变成默认输出路径。

V1.5 结果页体验状态：

- V1.5 阶段 4 已完成结果页阅读体验优化。
- 结果页已拆分为顶部核心摘要、称骨诗文、权重明细、命格洞察、五类解读、命理问答、本地润色预览和底部提示。
- 权重明细已改为更紧凑的两列展示。
- 命格标签已改为 adaptive grid，以改善小屏换行。
- 五类解读已放入 `InterpretationCard`，使用轻量折叠降低长文压迫感。
- 本地模型默认路径未改变，`makeDefaultRefiner()` 仍应返回 `TemplateTextRefiner`。
- 本地润色预览仍是受控实验路径，不覆盖原始结果、不写入历史记录。

V1.5 知识库体验状态：

- V1.5 阶段 5 已完成知识库浏览体验优化。
- 知识库列表已增加本地分类筛选，分类来自内置文章 `category` 去重生成，第一个分类为“全部”。
- 知识库列表已增加本地搜索，搜索范围覆盖标题、摘要、分类、标签和正文。
- 搜索和筛选均只在本地已加载文章数组中完成，不请求网络、不接服务端、不接 RAG。
- 知识库详情页已优化为标题摘要、正文和元信息分区，正文按段落展示，tags 以 chip 换行展示。
- `knowledge_articles.json` 内容未修改，`KnowledgeRepository` 读取逻辑未修改。
- 仍需人工检查小屏、深色模式和长 source URL 换行。

V1.5 历史记录体验状态：

- V1.5 阶段 6 已完成历史记录体验优化。
- 历史记录列表顶部已显示本地保存说明：当前版本仅保存在本设备，不上传、不同步，也不会用于在线服务。
- 历史记录空状态已说明完成一次查询后会以轻量记录保存在本机。
- 历史记录列表卡片已优化信息层级，展示标题、创建时间、出生日期和时辰、农历生日、总重量和最多 3 个 tags，不展示长诗文正文。
- 已新增历史详情页，只展示 `HistoryRecord` 已保存字段，不重新计算、不调用模板解读、不调用本地模型。
- 删除单条和清空全部均需要确认，删除后只影响本机记录且无法恢复。
- 历史记录存储结构、保存时机和最多 50 条策略未改变。
- 本地模型润色结果仍不会写入历史记录。

V1.5 设置 / Legal 体验状态：

- V1.5 阶段 7 已完成设置、关于、隐私政策、免责声明和开源许可阅读体验优化。
- 设置页已按应用信息、隐私与安全、实验功能分区；Release 下本地模型实验入口仍按现有策略隐藏。
- 关于页已拆分为 App 定位、当前能力、使用边界和法律与隐私入口。
- 隐私政策已增加摘要卡，并按账号、出生信息、历史记录、本地模型实验、网络、权限、广告分析、本地资源、未来变更和联系方式分区。
- 免责声明已增加摘要卡，并按传统文化、自我探索、非专业建议、健康、财务、婚恋、本地润色和重大决策分区。
- 开源许可页面已卡片化展示 llama.cpp、ggml/GGUF、Qwen2.5 相关 license / source / 说明，并保留人工复核提示。
- 本地模型仍不是默认功能，`makeDefaultRefiner()` 仍应返回 `TemplateTextRefiner`。
- 本阶段未修改 GitHub Pages 隐私页；上架前仍需人工复核 App 内隐私页和公网隐私页一致性。
- 隐私和免责声明文案仍需上架前人工复核。

V1.5 可访问性与适配规划状态：

- V1.5 阶段 9 已完成 Accessibility、Dark Mode、小屏适配、Dynamic Type、VoiceOver 和 QA 检查规划。
- 已新增 `docs/V1_5_AccessibilityDarkModeSmallScreenPlan.md`，覆盖首页、结果页、知识库、历史、设置、Legal 和本地模型实验路径。
- 已新增 `docs/V1_5_QAChecklist.md`，用于后续 V1.5 自测和人工 QA。
- 已新增 `docs/V1_5_DeviceTestMatrix.md`，覆盖 iPhone SE、iPhone 12 mini、iPhone 17 Pro Max、iPad、Simulator、低电量模式、深色模式、VoiceOver 和 Dynamic Type Accessibility Large。
- App Store 上架前必须完成人工适配检查，尤其是小屏、深色模式、Dynamic Type、VoiceOver 和 Legal 长文可读性。
- 当前仍不准备上传 TestFlight，也不准备 App Store 上架。
- 本地模型仍不是当前 Release 正式功能，当前 App Store 元数据仍不应宣传 AI / 本地模型能力。

V1.5 自测与决策状态：

- V1.5 阶段 10 已完成自测与下一步决策。
- 已新增 `docs/V1_5_TestReport.md`。
- 已新增 `docs/V1_5_ReleaseReadinessDecision.md`。
- Debug build：通过。
- Release build：通过。
- Product Experience Optimization: Pass。
- TestFlight Upload: Not Now。
- App Store Release: No-Go。
- Local Model Default Enablement: No-Go。
- Continue Product Polish: Go。
- 当前仍不准备上架 App Store。
- 当前仍不上传 TestFlight。
- App Store 元数据仍不应宣传 AI / 本地模型。
- 上架前仍需完成 Accessibility、Dynamic Type、深色模式、小屏、iPad、GitHub Pages 隐私页一致性、license / notice、App Icon 授权、签名和 Archive 人工检查。

## 18. V1.6 产品功能打磨状态

当前状态：

- V1.6 进入产品功能打磨阶段。
- 当前仍不准备上传 TestFlight。
- 当前仍不准备 App Store 上架。
- 当前仍不默认启用本地模型。
- 当前仍不把本地模型接入默认结果页。
- V1.6 重点是首次使用体验、常用出生资料、结果文本复制 / 分享、知识库收藏 / 最近阅读、历史记录整理和本地数据管理。
- 已新增 `docs/V1_6_ProductFeaturePlan.md`。
- 已新增 `docs/V1_6_Roadmap.md`。
- 已新增 `docs/V1_6_DataPrivacyPlan.md`。
- 已新增 `docs/V1_6_FeatureBacklog.md`。

V1.6 隐私和上架边界：

- 新增功能必须保持本地处理和隐私友好。
- 出生 Profile、历史收藏、知识库收藏、最近阅读等新增数据必须只保存在设备端。
- 不接账号、不同步、不接 iCloud、不接分析 SDK、不接广告追踪。
- 用户必须能够删除新增本地数据。
- 分享文案不得包含精准预测、改命、化解、避灾、必然发财等高风险表达。
- 本地模型仍不是当前 Release 正式功能，App Store 元数据仍不应宣传 AI / 本地模型。

V1.6 Onboarding 状态：

- V1.6 阶段 2 已加入轻量首次使用说明。
- 首次启动自动展示，完成后通过 `UserDefaults` key `hasCompletedOnboarding` 记录状态。
- 设置页和关于页提供“使用说明”入口，用户可再次查看。
- Onboarding 文案强调传统文化、自我探索、本地处理、本地保存和参考性解读。
- Onboarding 未宣传本地模型能力，未改变默认主流程。

V1.6 常用出生资料状态：

- V1.6 阶段 3 已加入常用出生资料本地保存和复用能力。
- 常用资料仅保存在当前设备的 Application Support JSON 文件中，不上传、不同步、不需要账号。
- 保存字段限于本地显示名、出生日期、出生时辰、创建时间和更新时间。
- 首页选择常用资料只填入输入，不自动查询、不自动保存历史。
- 设置页可删除单条资料或清空全部资料。
- App 内隐私政策和 GitHub Pages 隐私页已补充常用出生资料本地保存说明。

V1.6 结果复制与分享状态：

- V1.6 阶段 4 已加入结果页纯文本复制和系统分享能力。
- 分享摘要由用户手动点击生成，不自动触发、不保存分享记录、不写入历史记录。
- 默认摘要包含 App 名称、命格标题、总重量、称骨诗文、简要解读、行动建议和安全提示。
- 默认摘要不包含完整出生日期、完整农历生日、具体出生时辰、常用出生资料显示名、本地模型润色结果或历史记录信息。
- 当前只做纯文本复制 / 分享，不做图片分享、不做海报、不上传、不接服务端。

V1.6 知识库收藏与最近阅读状态：

- V1.6 阶段 5 已加入知识库收藏和最近阅读。
- 收藏只保存知识文章 `articleId` 列表；最近阅读只保存 `articleId` 和 `viewedAt`。
- 存储位置为当前设备 Application Support 下 `DestinyScope/knowledge_library_state.json`。
- 收藏最多保留 100 个，最近阅读最多保留 20 条。
- 文章详情页支持收藏 / 取消收藏，并在打开详情时记录最近阅读。
- 知识库列表展示本地“我的知识库”摘要、“收藏”分类和最近阅读入口。
- 用户可在知识库列表清空收藏或清空最近阅读。
- 知识库收藏和最近阅读不上传、不同步、不需要账号，不保存文章全文或搜索关键词。
- App 内隐私政策和 GitHub Pages 隐私页已补充知识库收藏 / 最近阅读本地保存说明。
- `knowledge_articles.json` 内容未修改，`KnowledgeRepository` 读取逻辑未修改。
