# DestinyScope V1.2 TextRefining PoC Result

更新日期：2026-05-29

## 1. 阶段目标

V1.2 阶段 4 目标是把本地 llama.cpp PoC 接入现有 `TextRefining` 抽象，并且只在 Debug-only 实验入口中测试。

本阶段保持以下边界：

- 不替换默认 App 输出。
- 不进入普通首页、结果页或命理问答路径。
- 不影响 Release。
- 不提交模型文件。
- 不提交 llama.cpp 源码。
- 不提交 `llama.xcframework`。
- 不请求网络，不做模型下载，不做 RAG，不做开放聊天。

## 2. 接入结果

| 项目 | 结果 |
| --- | --- |
| 是否完成 `TextRefining` 接口接入 | 是 |
| `makeDefaultRefiner()` | 仍返回 `TemplateTextRefiner` |
| Debug local llama refiner | 仅 `#if DEBUG` 下通过 `makeDebugLocalLlamaRefiner()` 获取 |
| `LocalLlamaTextRefiner.refine(_:)` | 已真实实现 |
| 普通 App 输出 | 未改变 |
| Release 实验入口 | 不暴露 |

## 3. 新增组件

| 文件 | 作用 |
| --- | --- |
| `TextRefiningPromptBuilder.swift` | 根据 `TextRefiningInput` 构造 Qwen chat template prompt |
| `TextRefiningSafetyRules.swift` | 提供默认安全规则和统一安全提示 |
| `TextRefiningSafetyChecker.swift` | 对模型输出做高风险词和提示词泄露检查 |

## 4. Prompt 设计

Prompt 明确要求：

- 只能润色已有文本。
- 不能新增命理结论。
- 不能编造四柱、五行、十神、大运、流年。
- 不能做绝对预测。
- 不能提供医疗、法律、投资、婚恋或职业确定性建议。
- 输出一段短文本。
- 保留安全提示。

当前使用 Qwen Instruct chat template：

- `<|im_start|>system`
- `<|im_start|>user`
- `<|im_start|>assistant`

## 5. 安全检查

高风险词检查包括：

- 精准预测
- 改命
- 化解
- 避灾
- 必然发财
- 保证转运
- 必有灾祸
- 寿命预测
- 疾病预测
- 投资收益确定
- 婚姻确定性
- 大师在线

额外检查：

- `严格限制`
- `安全规则`
- `待润色文本`
- `请只输出`
- `<|im_start|>`
- `<|im_end|>`

如果命中高风险词、提示词泄露、重复句、过长输出或其他安全规则，`LocalLlamaTextRefiner` 会返回 fallback 输出，并在 engine 中标记 `llama.cpp-qwen2.5-0.5b-q4-debug-fallback`。

## 6. Debug UI 验证

测试入口：

- 关于
- 本地模型 PoC
- TextRefining 润色测试
- 调用 `TextRefining.refine`

固定测试输入：

```text
命格结果提示你重视长期积累，做事宜稳中求进。以上内容仅供娱乐、自我探索和传统文化学习参考。
```

验证结果：

| 项目 | 结果 |
| --- | --- |
| 是否真实调用 `LocalLlamaTextRefiner.refine` | 是 |
| engine | `llama.cpp-qwen2.5-0.5b-q4-debug` |
| wasRefined | `true` |
| 是否通过安全检查 | 是 |
| 是否触发回退 | 否 |
| UI 记录耗时 | `5.660` 秒 |
| 安全提示 | `以上内容仅供娱乐、自我探索和传统文化学习参考，不构成现实决策建议。` |

模型输出样例：

```text
命格结果提示你重视长期积累，做事宜稳中求进。以上内容仅供娱乐、自我探索和传统文化学习参考。命格结果提示你重视长期积累。以上内容仅供娱乐、自我探索和传统文化学习参考，不构成现实决策建议。
```

质量备注：

- 当前 PoC 已证明 `TextRefining` 抽象可以调用本地 llama.cpp 模型。
- 输出仍有重复表达，后续阶段需要继续优化 prompt、采样参数和后处理。
- 当前结果不能进入生产路径。

## 7. 构建结果

| 项目 | 结果 |
| --- | --- |
| Debug 构建 | 通过 |
| Release 构建 | 通过 |
| Release 是否暴露入口 | 否，入口仍由 `#if DEBUG` 包裹 |
| 默认输出是否改变 | 否 |
| 是否有模型文件进入 git | 否 |

## 8. 阶段 5 更新

阶段 5 已完成提示词和安全过滤优化。

阶段 5 变化：

- Prompt 明确模型只做中文文本润色。
- Prompt 要求不扩写事实、不新增结论、不重复免责声明。
- Prompt 禁止标题、列表、编号和解释过程。
- SafetyChecker 增加空输出、长度、重复句、安全提示重复、提示词泄露、输入外命理术语、绝对化表达、现实决策建议倾向检查。
- `LocalLlamaTextRefiner.refine(_:)` 在安全检查失败时内部回退到 `sourceText`，不抛到普通 UI。
- 回退输出 engine 标记为 `llama.cpp-qwen2.5-0.5b-q4-debug-fallback`。
- Debug UI 新增固定安全测试样例，可选择正常样例和高风险样例运行。

阶段 5 详细记录见：

- `docs/V1_2_SafetyEvaluation.md`

## 9. 是否建议进入阶段 6

可以进入 V1.2 阶段 6：设备性能测试。

不建议进入生产路径。生产化前仍需完成真机性能、内存、耗电、模型 license、隐私政策和 App Store 元数据更新。

## 10. 阶段 6B 真机 benchmark 更新

阶段 6B 已完成首轮 iPhone 真机 Debug-only benchmark。

| 项目 | 结果 |
| --- | --- |
| 设备 | iPhone，具体型号未细化 |
| 系统 | `iOS 26.2` |
| 模型 | `qwen2.5-0.5b-instruct-q4_k_m.gguf` |
| 模型大小 | `491.4 MB` |
| 正常样例平均 total | 约 `1.09` 秒 |
| 高风险样例回退 | 已触发 |
| 默认输出 | 未改变，仍为 `TemplateTextRefiner` |
| Release | 不暴露本地模型 PoC |

结论：0.5B Q4 模型在本轮真机测试中的短文本润色速度可接受，安全检查可以拦截高风险输出并回退到模板文本。但当前只覆盖一台 iPhone，尚未记录 Instruments 的内存、CPU、Energy 和 Thermal 数据，不建议进入生产路径。
