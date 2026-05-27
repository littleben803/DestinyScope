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
- 真实本地模型尚未接入生产路径。
- 当前 App 默认仍使用本地规则和模板输出，不接在线 AI，不接真实本地 LLM，不下载模型。

V1.2 上架风险提醒：

- V1.2 PoC 不应进入 App Store 生产版本，除非完成性能、license、隐私、文案安全和人工验收。
- 如果未来接入真实本地模型，需要更新 App 内隐私政策、GitHub Pages 隐私政策、App Store 元数据和审核备注。
- 如果模型文件随 App 分发，需要人工确认模型 license 允许 App 分发和商业使用。
- Gemma 3 1B、Llama 3.2 1B 等非 Apache 或 gated/license 复杂模型，必须人工确认使用、商用、再分发、署名和 acceptable use 条款后才能进入 PoC 或生产。
- V1.2 阶段 3 如使用模型文件，只允许开发者手动下载到本地 Debug 测试环境，不提交仓库，不进入 Release 默认路径。
- App Store 元数据不得提前宣传真实 AI 推理，不得宣称精准预测、改命、化解或确定性现实建议。
- 本地模型只能润色已生成文本，不能负责命理计算、农历转换、称骨权重、诗文匹配或最终命理结论。
