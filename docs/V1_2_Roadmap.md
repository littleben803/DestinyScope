# DestinyScope V1.2 Roadmap

更新日期：2026-05-27

V1.2 只做本地小模型 PoC，不直接进入生产路径。每个阶段必须保持小步验证，优先证明可行性、风险和退出条件。

## 当前完成状态

更新日期：2026-05-27

- 阶段 1：已完成。已新增本地小模型预研、PoC 计划和 V1.2 Roadmap。
- 阶段 2：已完成。已新增 `docs/V1_2_ModelCandidates.md`，初步推荐 P0 为 `Qwen2.5-0.5B-Instruct`，备选为 `Qwen2.5-1.5B-Instruct-GGUF`。
- 阶段 3：未开始。下一步建议做 llama.cpp 最小集成 PoC，必须 Debug-only，模型文件不得提交仓库。

## V1.2 阶段 1：本地小模型调研与 PoC 设计

阶段目标：

- 明确 V1.2 是 Debug / 实验性质的本地小模型 PoC。
- 比较 llama.cpp + GGUF、Core ML、MLX Swift 三条路线。
- 设计 PoC 输入、Prompt、安全边界和验收指标。

允许修改范围：

- `docs/V1_2_LocalLLMResearch.md`
- `docs/V1_2_PoCPlan.md`
- `docs/V1_2_Roadmap.md`
- `docs/AppStoreChecklist.md`

不允许做的事：

- 不改 Swift 代码。
- 不新增模型文件。
- 不新增依赖。
- 不改工程配置。
- 不接真实模型。

验收标准：

- 三份 V1.2 文档存在。
- 明确首选 PoC 路线为 llama.cpp + GGUF。
- 明确本地模型只做润色，不生成命理结论。
- 明确生产化前风险和人工确认项。

建议 commit message：

```text
Document V1.2 local LLM PoC plan
```

## V1.2 阶段 2：候选模型调研与 license 检查

阶段目标：

- 列出 0.5B 到 1.5B 候选模型。
- 检查中文能力、指令跟随、量化版本、GGUF/Core ML/MLX 可用性。
- 人工确认 license 是否允许 App 分发和商业使用。

允许修改范围：

- `docs/V1_2_ModelCandidates.md`
- `docs/V1_2_LocalLLMResearch.md`
- `docs/AppStoreChecklist.md`

不允许做的事：

- 不下载模型到仓库。
- 不新增模型文件。
- 不接推理框架。
- 不改 Swift 代码。

验收标准：

- 至少列出 3 到 5 个候选模型。
- 每个模型记录参数量、中文能力、量化可用性、license 风险和初步结论。
- 未确认 license 的模型不得进入后续集成。

建议 commit message：

```text
Document V1.2 model candidate research
```

## V1.2 阶段 3：llama.cpp 最小集成 PoC，Debug-only

阶段目标：

- 做最小 llama.cpp + GGUF 本地推理实验。
- 仅 Debug-only，不进入默认用户路径。
- 验证模型可加载、可生成短文本、断网可用。

允许修改范围：

- Debug-only 实验目录。
- 最小桥接代码。
- 本地实验说明文档。
- 必要的工程配置，但必须单独说明。

不允许做的事：

- 不影响 Release 生产路径。
- 不替换现有模板输出。
- 不做模型下载。
- 不接在线 AI。
- 不提交未经 license 确认的模型文件。

验收标准：

- Debug 构建可运行。
- 实验入口可触发一次本地推理。
- 断网可用。
- 记录模型大小、加载时间、首 token 时间、总生成时间和内存情况。

建议 commit message：

```text
Add debug-only llama.cpp local model PoC
```

## V1.2 阶段 4：TextRefining 接入 PoC，不影响默认输出

阶段目标：

- 通过 `TextRefining` 接口接入 PoC 实现。
- 默认仍使用 `TemplateTextRefiner`。
- 本地模型实现只在 Debug / 实验开关下启用。

允许修改范围：

- `DestinyScope/Domain/TextRefining/*`
- Debug-only 实验入口。
- PoC 文档。

不允许做的事：

- 不改变普通用户默认输出。
- 不让模型生成命理结论。
- 不让模型输出绕过安全检查。
- 不接服务端或在线 AI。

验收标准：

- `TextRefinerFactory` 默认仍返回模板实现。
- 实验路径可选择本地模型 refiner。
- 输入来自模板结论和结构化上下文。
- 输出可回退到模板文本。

建议 commit message：

```text
Wire local model PoC through text refining interface
```

## V1.2 阶段 5：提示词和安全过滤

阶段目标：

- 固化 PoC Prompt。
- 增加输出安全检查和模板回退策略。
- 扫描高风险词和越界内容。

允许修改范围：

- `DestinyScope/Domain/TextRefining/*`
- Debug-only 安全测试工具。
- `docs/V1_2_SafetyEvaluation.md`

不允许做的事：

- 不开放给普通用户。
- 不移除免责声明。
- 不允许模型新增命理结论。

验收标准：

- 模型输出不得包含绝对预测、改命、化解、避灾、必然发财、寿命疾病预测、投资确定性、婚姻确定性等内容。
- 越界输出自动回退到模板文本。
- 记录至少 20 组测试输入输出。

建议 commit message：

```text
Add safety checks for local model PoC output
```

## V1.2 阶段 6：设备性能测试

阶段目标：

- 在多台 iPhone 上测试加载、生成、内存、耗电和发热。
- 评估不同模型大小和量化等级的体验差异。

允许修改范围：

- `docs/V1_2_DeviceBenchmark.md`
- Debug-only 性能记录代码，如确实需要。

不允许做的事：

- 不进入生产路径。
- 不做用户数据采集。
- 不上传日志。
- 不接分析 SDK。

验收标准：

- 至少记录 2 到 3 类设备测试结果。
- 包含首 token 时间、总生成时间、峰值内存、发热主观观察。
- 明确最低推荐设备线。

建议 commit message：

```text
Document local model device benchmark results
```

## V1.2 阶段 7：是否进入生产路径决策

阶段目标：

- 基于模型质量、性能、包体、license、隐私和审核风险决定是否进入生产。
- 输出 go / no-go 决策文档。

允许修改范围：

- `docs/V1_2_ProductionDecision.md`
- `docs/AppStoreChecklist.md`
- 如决定进入生产，再另开后续路线文档。

不允许做的事：

- 不在本阶段直接开启生产功能。
- 不在未更新隐私政策和审核备注前宣传本地 AI。
- 不在 license 未确认前随 App 分发模型。

验收标准：

- 明确是否进入生产路径。
- 明确模型、包体、最低设备、隐私政策、App Store 元数据和安全过滤要求。
- 如果 no-go，明确继续保留模板方案。

建议 commit message：

```text
Document V1.2 local model production decision
```
