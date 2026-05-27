# DestinyScope V1.2 Llama.cpp Integration Plan

更新日期：2026-05-27

本阶段只确认 llama.cpp 接入方案，不新增依赖、不修改工程配置、不接真实模型、不做真实推理。

## 1. iOS 接入路线

### 路线 A：Swift Package 接入 `ggml-org/llama.cpp`

通过 Swift Package Manager 直接接入 llama.cpp 官方仓库或其可用于 Apple 平台的 package 配置。

适用场景：

- 希望尽量复用官方构建配置。
- 希望减少本地静态库维护成本。
- 阶段 3C 先做 Debug-only 最小验证。

### 路线 B：参考 `llama.cpp/examples/llama.swiftui` 最小示例

以官方 SwiftUI 示例作为参考，将最小可用的模型加载、prompt 输入和文本生成路径迁移到 DestinyScope Debug-only 实验入口。

适用场景：

- Swift Package 直接接入不够稳定。
- 需要参考官方 iOS / SwiftUI 侧示例代码组织。
- 希望先跑通最小闭环，再决定是否抽象 wrapper。

### 路线 C：本地编译静态库 + Swift / ObjC++ wrapper

本地编译 llama.cpp / ggml 静态库，再通过 Swift 或 ObjC++ wrapper 暴露最小接口给 `LocalLlamaTextRefiner`。

适用场景：

- SPM 无法稳定构建。
- 需要更明确控制编译参数、Metal 开关、架构和链接方式。
- 后续需要生产化控制包体和构建稳定性。

## 2. 路线对比

| 维度 | 路线 A：Swift Package | 路线 B：官方 SwiftUI 示例迁移 | 路线 C：静态库 + wrapper |
| --- | --- | --- | --- |
| 接入复杂度 | 中。依赖官方 package 状态和 Xcode 兼容性 | 中。需要理解示例并裁剪 | 高。需要处理 C/C++/ObjC++/Swift 边界 |
| Debug-only 控制 | 较容易，可只在 Debug 配置引用实验入口 | 较容易，可将示例代码包在 Debug-only 路径 | 可控但配置成本高 |
| 是否影响 Release | 需要谨慎配置，避免 Release 链接实验依赖 | 需要谨慎隔离示例代码 | 可做到最强隔离，但维护成本高 |
| Metal 支持 | 取决于 package 配置 | 可参考官方示例 | 可精细控制，但排错成本高 |
| 构建稳定性 | 中。依赖上游 package 变化 | 中。示例迁移后仍需本地验证 | 中到高。稳定后可控，但初始成本大 |
| 后续维护成本 | 中。跟随上游变化 | 中。需要同步示例变更 | 高。需要维护本地编译和 wrapper |

## 3. 阶段 3C 推荐路线

推荐顺序：

1. 优先尝试路线 A：Swift Package 接入。
2. 如果 SPM 构建或 iOS 配置不稳定，参考路线 B：官方 `llama.swiftui` 示例做最小迁移。
3. 如果前两条路线都不稳定，再评估路线 C：本地静态库 + Swift / ObjC++ wrapper。

阶段 3C 必须保持：

- 仅 Debug-only。
- 只接 `LocalLlamaTextRefiner`。
- 默认 `TextRefinerFactory` 仍返回 `TemplateTextRefiner`。
- 不替换结果页、命理问答或知识库默认输出。
- 不进入 Release 路径。
- 模型文件不提交仓库。

## 4. 阶段 3C 最小目标

阶段 3C 只验证最小闭环：

- 能在 Debug 下加载本地 GGUF。
- 能对固定 prompt 生成一句短文本。
- 能记录模型加载耗时。
- 能记录生成耗时。
- 失败时不崩溃，并能显示明确错误。
- 不影响默认 App 输出。
- 断网状态下仍可运行实验入口。

建议固定 prompt：

```text
请将这句话润色得更温和：今天适合保持节奏，先完成最重要的一件事。
```

输出限制：

- 只生成 1 到 3 句。
- 不涉及命理结论。
- 不涉及医疗、投资、婚恋或职业确定性建议。

## 5. 阶段 3C 不做

- 不做流式 UI。
- 不做 RAG。
- 不做模型下载。
- 不做生产入口。
- 不进入 Release 路径。
- 不替换模板回答。
- 不做开放聊天。
- 不保存模型输出历史。
- 不上传日志。
- 不接在线 AI。

## 6. 风险

技术风险：

- SPM 编译失败。
- C++ / Metal 配置复杂。
- 模拟器和真机表现不一致。
- Debug 可编译但 Release 链接隔离不彻底。
- 上游 llama.cpp API 变化导致维护成本上升。

模型风险：

- 模型文件过大。
- 内存峰值过高。
- 首次加载过慢。
- 输出质量不稳定。
- 0.5B 表达质量不足，1.5B 资源压力较大。

合规风险：

- license 未完全确认。
- 第三方量化 GGUF 来源不清。
- 未保留必要 license / notice。
- 误将模型文件提交仓库或带入 Release。
- App Store 元数据提前宣传真实 AI 能力。

## 7. 3C 验收清单

- Debug 构建通过。
- Release 构建通过。
- Release 下无实验入口。
- 默认 `TextRefinerFactory.makeDefaultRefiner()` 仍返回 `TemplateTextRefiner`。
- 本地模型只由 Debug 实验入口触发。
- 模型文件未进入 git。
- 失败路径不崩溃。
- 记录模型文件名、文件大小、license、设备型号、加载时间、生成时间和峰值内存。
