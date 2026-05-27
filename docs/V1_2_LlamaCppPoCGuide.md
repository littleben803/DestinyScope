# DestinyScope V1.2 Llama.cpp PoC Guide

## 1. 阶段定位

V1.2 阶段 3A 只做 llama.cpp Debug-only 接入骨架和实验入口。

当前阶段不加载真实模型、不执行推理、不提交模型文件、不替换默认输出路径。App 默认仍使用本地规则引擎、模板命理师解读和 `TemplateTextRefiner`。

## 2. 当前实现范围

- 新增 `LocalLlamaTextRefiner` 作为 TextRefining 协议下的 llama.cpp PoC 占位实现。
- 新增 `LocalModelDebugConfig` 记录 Debug-only 模型文件名和本地目录说明。
- 新增 Debug-only `LocalModelDebugView`，用于验证接口路径是否可达。
- Settings 中仅在 DEBUG 编译条件下显示“本地模型 PoC”入口。
- `.gitignore` 已增加模型文件忽略规则，避免 GGUF、bin、safetensors、Core ML 模型和本地模型目录进入仓库。

## 3. 当前不做

- 不接入 llama.cpp Swift Package。
- 不加载 GGUF。
- 不做模型下载。
- 不做真实推理。
- 不做流式输出。
- 不做文件选择器。
- 不做聊天 UI。
- 不影响 Release 默认功能。

## 4. 推荐后续模型

阶段 3B 建议优先使用：

- `Qwen2.5-0.5B-Instruct` 的 GGUF 4-bit 量化版本。

选择原因：

- 参数量小，适合先验证 iOS 本地加载和内存压力。
- 中文能力和指令跟随能力相对更适合 DestinyScope 的文本润色 PoC。
- 4-bit GGUF 更符合 Debug-only 性能验证目标。

模型文件不得提交仓库，也不得进入 Release 默认路径。PoC 阶段由开发者手动放入本地测试目录。

## 5. 阶段 3B 记录项

真实加载前必须记录：

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

## 6. 安全边界

本地模型未来只能用于润色和表达改善。

模型不能：

- 生成命理计算结论。
- 负责农历转换、称骨权重、诗文匹配。
- 新增四柱、五行、十神、大运、流年等当前结构化结果没有的数据。
- 输出精准预测、改命、化解、避灾、必然发财等承诺。
- 输出医疗、法律、投资、婚恋或职业确定性建议。

如果后续接入真实本地模型，必须同步更新 App 内隐私政策、GitHub Pages 隐私政策、App Store 元数据和审核备注。
