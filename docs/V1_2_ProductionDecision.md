# DestinyScope V1.2 Production Decision

更新日期：2026-05-29

## 1. V1.2 PoC 总结

V1.2 的目标是验证本地 0.5B 到 1.5B 小模型是否具备离线润色能力，而不是直接进入生产路径。

当前 PoC 结果：

- llama.cpp Debug-only 接入成功。
- `Qwen2.5-0.5B` Q4 GGUF 已在 iOS Simulator 和 iPhone 真机上运行。
- `TextRefining` 接口接入成功，Debug 路径可以调用 `LocalLlamaTextRefiner`。
- `SafetyChecker` 和 fallback 生效，高风险输出可以回退到本地模板文本。
- 已完成 iPhone 17 Pro Max 和 iPhone 12 mini 双设备 benchmark。
- iPhone 17 Pro Max 正常样例平均 total 约 `1.09` 秒。
- iPhone 12 mini 可运行，但正常短文本 total 可能达到 4 到 5 秒。
- 高风险样例已触发 fallback。
- 默认 App 输出未受影响，普通首页、结果页和命理问答仍使用本地规则与模板。
- Release 不暴露本地模型实验入口。
- 模型文件、llama.cpp 源码和 `llama.xcframework` 未进入 git。

## 2. 当前结论

结论：**Conditional Go**。

不建议 V1.2 直接进入生产上线，但可以进入 V1.3 的生产化方案设计阶段。

理由：

- 技术链路可行：Debug-only llama.cpp + GGUF 已能在真机上加载并生成短文本。
- 性能初步可接受但需要分级：iPhone 17 Pro Max 约 1 秒级，iPhone 12 mini 可运行但明显变慢。
- 安全回退机制有效：高风险样例可以触发 fallback，避免模型输出直接进入用户可见路径。
- 产品价值成立：本地模型可作为模板文案的润色层，而不是替代命理计算引擎。

但以下事项尚未闭环：

- 设备覆盖不足。
- 内存、CPU、Energy、Thermal 数据不足。
- iPhone 12 mini 上出现一次疑似提示词泄露：`<|im_end|>`，后续需要加强 stop token、特殊 token 清理和后处理。
- 模型 license、notice、商业使用、再分发和 App 内分发仍需人工确认。
- 隐私政策、审核备注和 App Store 元数据尚未为生产级本地模型更新。
- 当前安全检查仍是规则式，覆盖有限。
- 模型输出仍可能出现重复、越界或质量不稳定。

## 3. 不建议现在直接生产上线的原因

- 已测试 iPhone 17 Pro Max 和 iPhone 12 mini，但仍缺少更多设备、低端设备和 iPad 测试。
- 未使用 Xcode Instruments 记录 Memory、CPU、Energy、Thermal 数据。
- 未验证连续长时间生成的稳定性。
- 模型 license、notice、再分发和 App 内分发条件仍需人工确认。
- App 内隐私政策、GitHub Pages 隐私政策、App Store 元数据和审核备注尚未更新。
- 当前安全检查仍是规则式，无法覆盖所有越界表达。
- 当前模型仍可能输出重复、越界或质量不稳定文本。
- iPhone 12 mini / A14 级别设备性能较慢，不建议默认全量开启本地模型。
- 生产路径需要明确失败回退、设备分级和功能开关，当前还未完成设计。

## 4. V1.3 生产化设计前置事项

如果进入 V1.3 生产化设计，需要先完成：

- 设备分级策略：明确哪些设备可启用，哪些设备只使用模板。
- 模型文件分发策略：内置模型还是手动 / 后续下载；V1.3 需要单独评估。
- 最低设备要求：基于真机性能和内存数据确定。
- 内存与能耗测试：使用 Xcode Instruments 记录 Memory、CPU、Energy、Thermal。
- 模型 license / notice 审计：确认商业使用、再分发和 App 内分发。
- 隐私政策更新：说明本地模型处理、模型文件来源和数据不上传。
- App Store Review Notes 更新：说明本地模型仅离线润色，不负责命理结论。
- 安全过滤加强：扩展规则、测试集和人工审校流程。
- 开关策略：默认关闭、实验开关或按设备启用。
- 回退策略：模型失败或安全检查失败时必须使用模板文本。
- 结果页标识策略：是否展示“本地模型润色”需要谨慎设计，避免夸大 AI 能力。

## 5. 决策建议

- V1.2 不进入生产路径。
- V1.2 成功证明本地小模型 PoC 可行。
- 下一步建议进入 V1.3：本地模型生产化方案设计。
- V1.3 第一阶段仍应只写方案文档，不改生产代码。
- 当前 App Store 元数据不应宣传 AI、本地模型或本地 LLM 功能。
- 当前 Release 仍应保持纯本地规则和模板输出。

## 6. Go / No-Go 表

| 评估项 | 状态 | 说明 |
| --- | --- | --- |
| 技术可行性 | Pass | llama.cpp + GGUF Debug-only 链路已跑通，Simulator 和真机均可生成短文本。 |
| 性能 | Partial | iPhone 17 Pro Max 约 1 秒级；iPhone 12 mini 可运行但可能达到 4 到 5 秒，不适合默认开启。 |
| 安全 | Partial | SafetyChecker 和 fallback 有效，但当前仍是规则式检查，覆盖有限。 |
| 隐私 | Risk | 当前 PoC 不上传、不联网；若生产化，需要更新 App 内和网页隐私政策。 |
| License | Risk | Qwen2.5 官方模型为 Apache 2.0，但具体 GGUF 来源、notice、再分发和 App 内分发仍需人工确认。 |
| App Store 审核 | Risk | 生产化前必须更新审核备注、元数据和本地模型处理说明，且不能夸大 AI 能力。 |
| 设备覆盖 | Risk | 已覆盖 iPhone 17 Pro Max 和 iPhone 12 mini，但仍缺少更多低端设备、iPad、连续运行和发热数据。 |
| 产品价值 | Pass | 本地模型作为润色层有明确价值，且不改变规则引擎的命理结论来源。 |

## 7. 最终判断

V1.2 判定为：**PoC 成功，Conditional Go 到 V1.3 方案设计，不直接进入生产路径**。

V1.3 应先完成生产化设计文档，明确模型分发、设备分级、license、隐私、审核、安全和回退策略后，再决定是否修改生产代码。
