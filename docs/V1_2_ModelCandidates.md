# DestinyScope V1.2 候选本地小模型调研

更新日期：2026-05-27

## 1. 本阶段结论

本阶段只做候选模型调研与 license 风险记录，不下载模型、不提交模型文件、不接 llama.cpp、不改 Swift 代码。

推荐 PoC 优先级：

- P0 首选：`Qwen2.5-0.5B-Instruct`
- P0 / P1 备选：`Qwen2.5-1.5B-Instruct-GGUF`
- P1 可评估：`Qwen3-0.6B`
- P1 边界候选：`Qwen3-1.7B`
- 暂不推荐进入第一轮 PoC：`Gemma 3 1B`、`Llama 3.2 1B`、`TinyLlama 1.1B`

主要原因：

- DestinyScope 当前 PoC 目标是文本润色和命理问答表达改善，不需要大模型推理能力。
- 首轮更需要低包体、低内存、中文能力、指令跟随和 license 清晰。
- Qwen2.5 0.5B / 1.5B 在中文、多语言、指令跟随和 Apache 2.0 许可上更适合作为起点。
- Gemma 3 1B、Llama 3.2 1B 都存在额外 license / gated access / 语言支持或分发确认成本，不适合作为第一轮最小 PoC。

## 2. 资料来源

本阶段参考：

- Qwen2.5-0.5B-Instruct Hugging Face：https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct
- Qwen2.5 官方博客：https://qwenlm.github.io/blog/qwen2.5/
- Qwen2.5-1.5B-Instruct-GGUF Hugging Face：https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF
- Qwen3 官方博客：https://qwenlm.github.io/blog/qwen3/
- Qwen3-1.7B-GGUF Hugging Face：https://huggingface.co/Qwen/Qwen3-1.7B-GGUF
- Gemma 3 1B Hugging Face：https://huggingface.co/google/gemma-3-1b-it
- Gemma 3 Hugging Face Blog：https://huggingface.co/blog/gemma3
- Llama 3.2 1B Hugging Face：https://huggingface.co/meta-llama/Llama-3.2-1B
- TinyLlama 1.1B Chat Hugging Face：https://huggingface.co/TinyLlama/TinyLlama-1.1B-Chat-v1.0

说明：

- 本文中的预计 4-bit 大小是 PoC 前估算或来自公开 GGUF 页面信息，最终以开发者实际下载的目标文件为准。
- license 判断不是法律意见。进入生产前必须人工复核模型 license、再分发条款、商用条款、署名要求和 acceptable use policy。

## 3. 候选模型对比表

| 模型名称 | 参数量 | 类型 | 中文能力 | 指令跟随 | GGUF 是否可用 | 4-bit 量化是否可用 | 预计 4-bit 模型大小 | iOS PoC 适配性 | license | 是否需要手动接受 license | 商业使用/再分发 | 风险 | 初步结论 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Qwen2.5-0.5B-Instruct | 0.49B | instruct / chat | 强。Qwen2.5 官方说明支持中文等 29+ 语言 | 强。官方说明 Qwen2.5 改善了 instruction following | 可用。官方 HF 原始模型有量化入口，社区和官方 GGUF 可用性较好 | 可用，常见 Q4_K_M / Q4_0 等 | 约 0.35～0.4GB，需以实际 GGUF 文件为准 | 很适合，低包体和低内存优先 | Apache 2.0 | 否 | Apache 2.0 通常允许商用和再分发，但仍需保留 license / notice | 0.5B 表达质量可能不如 1.5B，中文润色需实测 | P0 首选。先用它验证最小包体和最低内存 |
| Qwen2.5-1.5B-Instruct-GGUF | 1.54B | instruct / chat | 强。Qwen2.5 系列支持中文等 29+ 语言 | 强。官方模型卡说明 instruction-tuned，且 GGUF repo 支持 llama.cpp | 可用。官方 GGUF repo 明确支持 llama.cpp | 可用。官方列出 q4_0、q4_K_M 等量化 | 约 0.9～1.1GB，需以实际 Q4_K_M 文件为准 | 适合但更重，适合质量对比 | Apache 2.0 | 否 | Apache 2.0 通常允许商用和再分发，但仍需保留 license / notice | 包体和内存压力明显高于 0.5B | P0/P1 备选。用于验证更好中文表达是否值得增加体积 |
| Qwen3-0.6B | 0.6B | instruct / chat / reasoning-capable | 强。Qwen3 官方说明支持 100+ 语言和方言 | 强，但有 thinking / non-thinking 使用复杂度 | 可评估。官方说明本地工具包括 llama.cpp，社区 GGUF 较多 | 可评估，社区 Q4_K_M 可见 | 约 0.4～0.5GB，需以目标 GGUF 为准 | 可评估，大小接近 0.5B | Apache 2.0 | 否 | Apache 2.0 通常允许商用和再分发，但仍需复核具体 repo | Qwen3 工具链、prompt 模式和非思考模式需额外验证 | P1 可评估。先不作为第一轮首选 |
| Qwen3-1.7B | 1.7B | instruct / chat / reasoning-capable | 强。Qwen3 官方说明支持 100+ 语言和方言 | 强，但需控制 thinking / non-thinking 模式 | 可用。官方 Qwen3-1.7B-GGUF 存在，官方 repo 主要列 q8_0；社区 Q4_K_M 可见 | 官方 GGUF 页面需确认 4-bit；社区 Q4_K_M 可见 | 约 1.0～1.2GB，社区 Q4_K_M 约 1.1GB | 边界适配，超过 1.5B 上限一点 | Apache 2.0 | 否 | Apache 2.0 通常允许商用和再分发，但社区量化 repo 仍需单独确认 | 超过目标上限，包体、内存和生成速度风险更高 | P1 边界候选。仅当 1.5B 质量不足时再评估 |
| Gemma 3 1B | 1B | instruct / chat | 谨慎。Gemma 3 1B 在公开摘要中标注 text-only，博客表格显示 1B 侧重 English；4B+ 才标注 140+ languages | 可用，instruction-tuned | 可评估。HF 页面有量化入口 | 可评估，需确认目标 GGUF | 约 0.6～0.8GB，需实测 | 技术可评估，但不是中文 PoC 首选 | Gemma license | 是。HF 页面要求登录并接受 Google usage license | 需人工确认，不默认等同 Apache 2.0 | license、gated access、中文能力和再分发条件都需审慎确认 | 暂不推荐第一轮 PoC |
| Llama 3.2 1B | 1.23B | base；另有 instruct 版本可另查 | 谨慎。官方支持语言列出 8 种，不含中文；可训练数据更广但中文不在显式支持列表 | base 版不适合直接做指令润色；需另评 instruct | 可评估，Llama 生态 GGUF 丰富 | 可评估，官方有 quantized 用途说明 | 约 0.7～0.9GB，需按目标 GGUF 确认 | 技术可评估，但中文和 license 成本较高 | Llama 3.2 Community License | 是。HF 页面要求登录或注册 review conditions | 可商用但受 Llama 3.2 Community License、AUP、署名和月活限制约束，需人工确认 | 非 Apache；中文不在官方支持语言；分发需遵守 Built with Llama / notice 等要求 | 暂不推荐第一轮 PoC |
| TinyLlama 1.1B Chat | 1.1B | chat | 弱。HF 标签和模型介绍以 English 为主 | 可用，chat fine-tune | 可用，HF 有量化入口和大量 quantization | 可用 | 约 0.6～0.8GB，需按目标 GGUF 确认 | 技术轻量，但中文润色目标不匹配 | Apache 2.0 | 否 | Apache 2.0 通常允许商用和再分发，但需保留 license / notice | 中文能力不足，训练方向不适合 DestinyScope 中文润色 | 暂不推荐 |

## 4. 推荐 PoC 优先级

### P0 推荐

1. `Qwen2.5-0.5B-Instruct`
   - 首轮最小 PoC 首选。
   - 目标是验证 iOS 本地推理、加载时间、内存峰值和短文本润色链路。
   - 优点是体积小、中文能力较好、license 清晰。
   - 风险是 0.5B 的表达质量可能不稳定，需要严格 prompt 和安全回退。

2. `Qwen2.5-1.5B-Instruct-GGUF`
   - 作为质量对比模型。
   - 目标是验证更好中文表达是否值得增加包体和内存。
   - 优点是官方 GGUF repo 明确支持 llama.cpp 和多种量化。
   - 风险是包体和内存压力显著高于 0.5B。

### P1 可评估

1. `Qwen3-0.6B`
   - 适合在 Qwen2.5 0.5B 之后评估。
   - 需要确认 GGUF、4-bit、非 thinking 模式和 llama.cpp 工具链成熟度。
   - 不要误用 `Qwen3-ASR`，ASR 是语音识别，不适合文本润色 PoC。

2. `Qwen3-1.7B`
   - 超过 1.5B 上限一点，只作为边界候选。
   - 若 Qwen2.5 1.5B 表达质量不足，可再做对比。
   - 需要重点测试内存、速度和包体。

### 暂不推荐

1. `Gemma 3 1B`
   - 需要接受 Google Gemma usage license。
   - 不应默认按 Apache 2.0 处理。
   - 中文能力和 App 分发条件需要人工确认。

2. `Llama 3.2 1B`
   - 需要接受 Meta Llama license 和 Acceptable Use Policy。
   - 商用和再分发虽有授权框架，但有额外条款、署名和限制，需要人工确认。
   - 官方支持语言不含中文，不适合作为中文润色首选。

3. `TinyLlama 1.1B Chat`
   - Apache 2.0 清晰，技术上轻量。
   - 但中文能力不足，不适合 DestinyScope 中文命理文本润色。

## 5. License 原则

- 未确认 license 前不得随 App 分发模型文件。
- 未确认商业使用和再分发条件前不得进入生产路径。
- PoC 阶段模型可由开发者手动下载到本地，不提交到仓库。
- 如果模型需要 Hugging Face gated access 或手动接受协议，必须在文档中明确。
- Apache 2.0 模型仍需保留 license / notice，并确认量化 repo 是否继承同样 license。
- 第三方量化 GGUF repo 需要单独确认来源、license、文件完整性和是否允许再分发。
- 非 Apache 模型不得默认认为可以 App Store 分发。
- 如果未来模型随 App 分发，需要在 App 内、GitHub Pages 隐私政策、App Store 审核备注和开源声明中同步说明。

## 6. V1.2 阶段 3 建议输入

建议进入 V1.2 阶段 3：llama.cpp 最小集成 PoC，Debug-only。

阶段 3 推荐模型输入：

- 优先：`Qwen2.5-0.5B-Instruct` 的 GGUF 4-bit 量化版本。
- 备选：`Qwen2.5-1.5B-Instruct-GGUF` 的 Q4_K_M 版本。

选择策略：

- 如果目标是最小化包体和内存，先试 0.5B。
- 如果目标是更好中文表达，试 1.5B。
- 两者都必须由开发者手动下载到本地测试目录。
- 模型文件不提交仓库。
- 仅 Debug-only。
- 不影响默认 App 输出。
- 不进入 App Store 生产版本。

建议阶段 3 记录：

- 模型 repo 和具体文件名。
- 文件大小。
- license 文件保存位置。
- 是否需要 Hugging Face 登录或协议接受。
- iPhone 设备型号。
- 首次加载时间。
- 首 token 时间。
- 200～500 字生成总耗时。
- 峰值内存。
- 是否断网可用。
- 是否出现安全越界输出。

## 7. 阶段 2 结论

可以进入 V1.2 阶段 3，但只建议进入 llama.cpp Debug-only PoC，不建议进入生产路径。

进入阶段 3 前需要人工确认：

- 目标 GGUF 文件的实际 license。
- 目标量化文件是否来自官方 repo 或可信量化 repo。
- 模型文件不提交仓库。
- PoC 入口仅 Debug 可见。
- 默认 App 输出仍走 `TemplateTextRefiner`。
