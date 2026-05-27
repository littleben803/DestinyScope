# DestinyScope V1.2 Llama.cpp PoC Result

更新日期：2026-05-27

## 1. 本阶段目标

阶段 3D 目标是在仓库外构建 `llama.xcframework`，并以 Debug-only 方式接入 DestinyScope 工程，验证本地 GGUF 模型加载路径。

本阶段保持以下边界：

- 不提交模型文件。
- 不提交 llama.cpp 源码。
- 不提交 `llama.xcframework`。
- 不复制模型进仓库或 App Bundle。
- 不替换默认 `TemplateTextRefiner`。
- 不暴露 Release 实验入口。
- 不影响 App 主流程输出。

## 2. Codex PATH 与 CMake

初始检查显示 Codex shell 的 `PATH` 未包含 Homebrew / CMake 路径，因此 `cmake --version` 报 `command not found`。

本次执行显式设置：

```sh
export PATH="/opt/homebrew/bin:/usr/local/bin:/Applications/CMake.app/Contents/bin:$PATH"
```

修复后结果：

| 项目 | 结果 |
| --- | --- |
| CMake 是否可用 | 是 |
| CMake 路径 | `/opt/homebrew/bin/cmake` |
| CMake 版本 | `4.3.2` |

## 3. 模型文件记录

| 项目 | 结果 |
| --- | --- |
| 模型文件名 | `qwen2.5-0.5b-instruct-q4_k_m.gguf` |
| 模型文件路径 | `~/LocalModels/DestinyScope/qwen2.5-0.5b-instruct-q4_k_m.gguf` |
| fallback 文件名 | `qwen2_5_0_5b_instruct_q4.gguf` |
| 文件大小 | `491400032` bytes，约 `469 MB` |
| sha256 | `74a4da8c9fdbcd15bd1f6d01d621410d31c6fc00986f5eb687824e7b93d7a9db` |
| license 确认状态 | Qwen2.5 模型页面标注 Apache 2.0；App 分发前仍需人工确认具体 GGUF 文件来源、notice、商用、再分发和 App 内分发条件 |
| 模型是否进入 git | 否 |

## 4. llama.cpp 与 Framework

| 项目 | 结果 |
| --- | --- |
| llama.cpp 路径 | `~/LocalModels/DestinyScope/llama.cpp` |
| 是否在仓库外 | 是 |
| `build-xcframework.sh` | 成功 |
| 官方输出路径 | `~/LocalModels/DestinyScope/llama.cpp/build-apple/llama.xcframework` |
| 稳定引用路径 | `~/LocalModels/DestinyScope/llama.xcframework` |
| 稳定引用方式 | 仓库外 symlink |
| framework 是否进入 git | 否 |

## 5. Xcode 接入结果

已做最小 Debug-only 工程配置：

- Debug 配置增加 `llama.xcframework` 对应 slice 的 framework search path。
- Debug 配置增加 `-framework llama` link flag。
- 新增 `Embed Debug llama.xcframework` build phase。
- build phase 在非 Debug 配置下立即退出，不复制 framework。
- Debug target 关闭 User Script Sandboxing，以允许脚本从仓库外路径复制 Debug framework slice。
- Release 不链接 llama，不展示 Debug 入口，不调用本地模型路径。

注意：build phase 作为 target phase 存在于工程中，但脚本首行检查 `CONFIGURATION != Debug` 时直接退出，因此 Release 不会复制 `llama.framework`。

## 6. Swift 接入结果

已新增 / 更新：

- `LlamaCppSession`：Debug-only llama.cpp C API 最小封装。
- `LlamaCppModelInfo`：记录本地模型路径、文件名和大小。
- `LocalLlamaTextRefiner`：通过 `LlamaCppSession` 执行固定 prompt 测试。
- `LocalModelDebugConfig`：记录模型路径、fallback 路径和 `llama.xcframework` 路径。
- `LocalModelDebugView`：显示模型文件状态、framework 配置状态、加载耗时、生成耗时、输出文本和错误信息。

默认 `TextRefinerFactory.makeDefaultRefiner()` 仍返回 `TemplateTextRefiner`。

## 7. 构建结果

| 项目 | 结果 |
| --- | --- |
| Debug 构建 | 通过，`xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Debug -destination 'generic/platform=iOS Simulator' build` |
| Release 构建 | 通过，`xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Release -destination 'generic/platform=iOS Simulator' build` |
| Release 是否隐藏实验入口 | 是，入口由 `#if DEBUG` 包裹 |
| Release 是否链接 llama | 否，Release 未配置 `-framework llama` |
| 默认 TextRefiner | 仍为 `TemplateTextRefiner` |
| 构建 warning | 仅保留 `Metadata extraction skipped. No AppIntents.framework dependency found.` |

## 8. 运行验证

本次执行做了仓库外 macOS smoke test：

- 使用 `llama.xcframework/macos-arm64_x86_64` slice。
- 使用同一个 GGUF 模型文件。
- 使用同一类 llama.cpp C API 调用流程。
- 不写入仓库。
- 不修改 App 主流程。

结果：

| 项目 | 结果 |
| --- | --- |
| 模型文件检查 | 成功 |
| 加载是否成功 | 成功 |
| 生成是否成功 | 成功 |
| 加载耗时 | `7.939` 秒 |
| 生成耗时 | `2.548` 秒 |
| 输出文本 | `命理结果只适合作为自我探索参考，但不应成为自我实现的唯一途径。生命的意义和价值在于自我探索和自我实现，而命理结果只是探索和实现过程中的一个参考。` |

另外，本次已在 iOS Simulator Debug app 的 `LocalModelDebugView` 中完成手工点击验证：

| 项目 | 结果 |
| --- | --- |
| framework 状态 | 已配置 |
| 模型文件状态 | 存在，大小 `491.4 MB` |
| 加载是否成功 | 成功 |
| 生成是否成功 | 成功 |
| 加载耗时 | `0.248` 秒 |
| 生成耗时 | `2.585` 秒 |
| 输出文本 | 可展示，内容为“命理结果只适合作为自我探索参考...”开头的安全提示文本 |

说明：

- macOS smoke test 证明仓库外 `llama.xcframework` 与 GGUF 文件可真实加载和生成。
- iOS Simulator Debug app 已完成构建、链接和 Debug UI 加载 / 生成验证。
- 当前输出仍只用于 Debug 实验入口，不进入普通用户路径。

## 9. 仓库检查

已执行仓库内模型 / framework 文件检查：

- 未发现 `.gguf`。
- 未发现 `.bin`。
- 未发现 `.safetensors`。
- 未发现 `.mlmodel`。
- 未发现 `.mlmodelc`。
- 未发现 `.xcframework`。

`llama.cpp` 源码和 `llama.xcframework` 均保留在仓库外 `~/LocalModels/DestinyScope/`。

## 10. 是否建议进入阶段 4

可以进入 V1.2 阶段 4 的 PoC 设计与接入准备。

阶段 4 前建议补充真机验证：

- 在真机 Debug 构建中确认模型路径策略。
- 记录真机加载耗时、生成耗时、输出文本和内存表现。
- 确认老设备上的崩溃、发热和内存压力风险。

阶段 4 仍应保持：

- 默认输出不替换。
- Release 不暴露实验入口。
- 模型只用于润色表达。
- 不让模型生成命理结论。
