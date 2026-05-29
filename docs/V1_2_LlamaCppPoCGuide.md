# DestinyScope V1.2 Llama.cpp PoC Guide

## 1. 阶段定位

V1.2 阶段 3A 只做 llama.cpp Debug-only 接入骨架和实验入口。

当前阶段不加载真实模型、不执行推理、不提交模型文件、不替换默认输出路径。App 默认仍使用本地规则引擎、模板命理师解读和 `TemplateTextRefiner`。

V1.2 阶段 3B 只确认模型文件准备方式和 llama.cpp 接入方案。阶段 3B 仍不接真实模型、不修改 App 主流程、不新增依赖、不下载模型。

V1.2 阶段 3C 开始尝试 Debug-only 真实加载路径。本次实现增加了本地模型文件检查、Debug View 状态展示和 `LlamaCppSession` 最小封装。

V1.2 阶段 3D 已修复 Codex shell 找不到 CMake 的 PATH 问题，在仓库外构建 `llama.xcframework`，并以 Debug-only 方式接入工程。Debug / Release 构建均通过；仓库外 macOS smoke test 和 iOS Simulator Debug UI 均已验证同一个 GGUF 文件可以通过 `llama.xcframework` 加载并生成短文本。

## 2. 当前实现范围

- 新增 `LocalLlamaTextRefiner` 作为 TextRefining 协议下的 llama.cpp PoC 占位实现。
- 新增 `LocalModelDebugConfig` 记录 Debug-only 模型文件名和本地目录说明。
- 新增 Debug-only `LocalModelDebugView`，用于验证接口路径是否可达。
- Settings 中仅在 DEBUG 编译条件下显示“本地模型 PoC”入口。
- `.gitignore` 已增加模型文件忽略规则，避免 GGUF、bin、safetensors、Core ML 模型和本地模型目录进入仓库。
- 阶段 3B 新增 `docs/V1_2_ModelFileSetup.md` 和 `docs/V1_2_LlamaCppIntegrationPlan.md`，用于约束模型文件、license、路径和阶段 3C 接入路线。
- 阶段 3C 新增 `LlamaCppSession` 和 `LlamaCppModelInfo`，并增强 `LocalModelDebugView` 的模型检查、耗时展示和错误展示。
- 阶段 3D 在仓库外生成 `~/LocalModels/DestinyScope/llama.xcframework`，Debug 配置下链接 `llama.framework`，Release 不链接、不展示、不调用本地模型实验入口。
- 阶段 6A 增加 Debug-only GGUF 文件导入能力。真机可通过 Files App 选择 `.gguf` 文件，并复制到 App Documents 沙盒目录；Release 不展示该入口。

## 3. 当前不做

- 不接入 llama.cpp Swift Package，当前使用仓库外 `llama.xcframework`。
- 不做模型下载。
- 不做流式输出。
- 不做文件选择器。
- 不做聊天 UI。
- 不影响 Release 默认功能。
- 不下载模型。
- 不提交模型文件。
- 不将真实推理接入普通用户路径。
- 不替换 `TemplateTextRefiner` 默认输出。

## 4. 推荐后续模型

阶段 3B 建议优先使用：

- `Qwen2.5-0.5B-Instruct` 的 GGUF 4-bit 量化版本。

选择原因：

- 参数量小，适合先验证 iOS 本地加载和内存压力。
- 中文能力和指令跟随能力相对更适合 DestinyScope 的文本润色 PoC。
- 4-bit GGUF 更符合 Debug-only 性能验证目标。

模型文件不得提交仓库，也不得进入 Release 默认路径。PoC 阶段由开发者手动放入本地测试目录。

推荐 Simulator / Mac 本地路径：

```text
~/LocalModels/DestinyScope/
```

可选本地未跟踪路径：

```text
LocalModels/
```

`LocalModels/` 已被 `.gitignore` 忽略，但仍建议优先使用仓库外路径。

真机 Debug 测试路径：

```text
Documents/LocalModels/DestinyScope/qwen2.5-0.5b-instruct-q4_k_m.gguf
```

真机无法访问 Mac 的 `~/LocalModels`。在 Debug App 的“本地模型 PoC”页面点击“导入 GGUF 模型”，从 Files App 选择 `.gguf` 文件后，App 会复制到上述 Documents 路径。如果目标文件已存在，会覆盖旧文件。

## 5. 阶段 3B 记录项

阶段 3B 已确认真实加载前必须记录：

- 模型文件名
- 文件大小
- license 和再分发条件
- 测试设备型号
- App 配置和构建类型
- 模型加载时间
- 首 token 时间
- 总生成时间
- 峰值内存
- 断网可用性
- 输出安全性问题

阶段 3D 已完成仓库外 framework 构建、Debug-only 工程接入和 iOS Simulator Debug UI 手工验证。下一步如果继续推进，应先补充真机性能验证，再进入阶段 4 的 `TextRefining` PoC 接入准备。

当前阶段 3D 结果记录见：

- `docs/V1_2_LlamaCppPoCResult.md`

阶段 4 已将本地 llama.cpp PoC 接入 `TextRefining` 抽象，但仍只在 Debug-only 实验入口中验证。默认 `TextRefinerFactory.makeDefaultRefiner()` 仍返回 `TemplateTextRefiner`，普通 App 输出不受影响。

阶段 4 结果记录见：

- `docs/V1_2_TextRefiningPoCResult.md`

## 6. 安全边界

本地模型未来只能用于润色和表达改善。

模型不能：

- 生成命理计算结论。
- 负责农历转换、称骨权重、诗文匹配。
- 新增四柱、五行、十神、大运、流年等当前结构化结果没有的数据。
- 输出精准预测、改命、化解、避灾、必然发财等承诺。
- 输出医疗、法律、投资、婚恋或职业确定性建议。

如果后续接入真实本地模型，必须同步更新 App 内隐私政策、GitHub Pages 隐私政策、App Store 元数据和审核备注。
