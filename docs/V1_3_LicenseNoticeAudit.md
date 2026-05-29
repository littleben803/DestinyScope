# DestinyScope V1.3 License Notice Audit

更新日期：2026-05-29

> 本文档是工程和发布风险审计记录，不构成法律意见。进入 TestFlight 或 App Store 分发前，仍需要人工复核原始 license、notice、模型来源和分发条款。

## 1. 审计范围

本次审计范围包括：

- Qwen2.5-0.5B-Instruct。
- Qwen2.5-0.5B-Instruct-GGUF。
- `qwen2.5-0.5b-instruct-q4_k_m.gguf`。
- llama.cpp。
- ggml / gguf 相关组件。
- 未来可能加入 App 的 license / notice 页面。

当前状态：

- 模型文件仅用于 Debug / TestFlight PoC 设计，不进入当前 Release。
- 模型文件未提交仓库。
- `llama.xcframework` 未提交仓库。
- 当前 Release 不包含模型和 framework，因此当前正式版暂不需要新增本地模型相关开源声明。

## 2. Qwen 模型 license 审计

公开来源：

- Base repo: https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct
- GGUF repo: https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF

Hugging Face 页面当前显示：

- `Qwen/Qwen2.5-0.5B-Instruct`：License 为 `apache-2.0`。
- `Qwen/Qwen2.5-0.5B-Instruct-GGUF`：License 为 `apache-2.0`。

审计表：

| 项目 | 记录 |
| --- | --- |
| 模型名称 | Qwen2.5-0.5B-Instruct |
| Hugging Face repo URL | https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct |
| GGUF repo URL | https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF |
| 当前 PoC 文件名 | `qwen2.5-0.5b-instruct-q4_k_m.gguf` |
| license 类型 | 页面标注 `apache-2.0` |
| 是否 Apache 2.0 | 初步是，需人工最终确认 |
| 是否官方 Qwen 仓库 | repo owner 为 `Qwen`，需人工确认是否满足“官方来源”要求 |
| 是否允许商业使用 | Apache 2.0 通常允许，但需人工复核模型卡和仓库文件 |
| 是否允许修改 / 分发 | Apache 2.0 通常允许，但需保留 license / notice，需人工复核 |
| 是否允许 App 内分发 | 需人工确认 |
| 是否需要保留 LICENSE | 是，若分发模型文件应保留 |
| 是否需要保留 NOTICE | 如仓库包含 NOTICE，应保留 |
| 是否有 use restriction / acceptable use policy | 当前未在本次文档中完成逐条审计，需人工确认 |
| 是否需要人工最终确认 | 是 |

风险说明：

- Hugging Face 页面上的 license 标签不足以替代完整 license / notice 审计。
- 需要检查 repo 文件列表中的 LICENSE、NOTICE、README、model card 和可能的 use restriction。
- 需要确认当前实际使用的 Q4_K_M GGUF 文件来自 `Qwen/Qwen2.5-0.5B-Instruct-GGUF` 官方仓库，或来自其他量化仓库。
- 如果实际 GGUF 来自第三方量化仓库，需要单独审计第三方仓库 license / notice。

## 3. llama.cpp / ggml license 审计

公开来源：

- llama.cpp repo: https://github.com/ggml-org/llama.cpp
- LICENSE: https://github.com/ggml-org/llama.cpp/blob/master/LICENSE

GitHub 页面当前显示：

- llama.cpp 仓库 License 为 `MIT license`。
- LICENSE 文件显示 `MIT License`，copyright 为 `2023-2026 The ggml authors`。

审计表：

| 项目 | 记录 |
| --- | --- |
| repo URL | https://github.com/ggml-org/llama.cpp |
| license 类型 | MIT |
| 是否允许商业使用 | MIT 通常允许，需保留 copyright 和 permission notice |
| 是否允许 App 内链接 / 分发 | MIT 通常允许，需人工确认打包方式和依赖清单 |
| 是否需要保留 license | 是 |
| 是否需要 App 内展示开源声明 | 建议需要 |
| 使用编译后的 `llama.xcframework` 是否需要附带 notice | 建议随 App 附带开源许可说明 |
| 是否需要人工最终确认 | 是 |

ggml / gguf 相关说明：

- llama.cpp 项目包含 ggml 相关代码，当前按 llama.cpp repo 的 MIT license 处理。
- 如果后续额外引入独立 ggml、GGUF 工具、转换脚本、第三方 wrapper 或 binary release，需要逐项审计。
- 如果使用 llama.cpp binary target 或 release zip，需要确认对应 release 的 license 文件和依赖 notice。

## 4. Apache 2.0 初步义务说明

如果 Qwen 模型和 GGUF 文件最终确认是 Apache 2.0，需要注意：

- 需要保留 license。
- 需要保留 copyright notice。
- 如果有 NOTICE 文件，需要保留 NOTICE。
- 修改或再分发时需要遵守 license 条款。
- App 内可提供“开源许可”页面或 About 页面入口。
- 分发模型文件时需要在发布包、App 内页面或随附文档中提供对应 license / notice。

注意：

- 本文档不是法律意见。
- 生产分发前需要人工复核。
- 如果模型来源不是官方 Qwen GGUF repo，不能套用本节结论。

## 5. TestFlight 与 App Store 分发差异

### TestFlight

- TestFlight 仍属于分发，需要谨慎处理 license / notice。
- 不应忽略 license。
- 不能因为是内测就提交不明来源模型。
- 如果 TestFlight 包内包含模型或 framework，应准备 license / notice。
- 如果模型由开发者手动导入，也应记录来源和 license 确认。

### App Store

- 必须完成 license / notice。
- 必须确认模型分发权利。
- 必须确认隐私说明。
- 必须确认审核备注。
- 如果模型或 framework 随 App 分发，应提供 App 内开源许可入口或等价说明。

## 6. 当前结论

初步结论：

- `Qwen2.5-0.5B-Instruct` / `Qwen2.5-0.5B-Instruct-GGUF` 页面当前标注 Apache 2.0。
- 如果确认当前 GGUF 文件来自官方 Qwen GGUF repo 且 license / notice 完整，可继续作为 V1.3 TestFlight 候选。
- 但进入 TestFlight 前必须把 license / notice 草案落地。
- 未完成前不得把模型文件随 App 分发。
- llama.cpp / ggml 当前按 MIT license 初步处理，也必须纳入开源声明。
- 当前 Release 不包含模型和 framework，因此暂不影响正式版开源声明。

不允许：

- 不明来源 GGUF 进入 TestFlight。
- 未确认 license 的模型随 App Bundle 分发。
- 未准备 license / notice 的 `llama.xcframework` 随 App 分发。
- 在 App Store 元数据中夸大模型能力。

## 7. 需要人工确认清单

进入 TestFlight 或生产前，必须人工确认：

- Qwen base repo license 截图 / 文档记录。
- Qwen GGUF repo license 截图 / 文档记录。
- 实际使用的 `qwen2.5-0.5b-instruct-q4_k_m.gguf` 文件来源 URL。
- 实际使用的 GGUF 文件是否来自官方 Qwen GGUF repo。
- llama.cpp license 截图 / 文档记录。
- 是否存在 Qwen NOTICE 文件。
- 是否存在 llama.cpp / ggml NOTICE 或 AUTHORS 文件需要保留。
- 是否允许商业 App 分发。
- 是否允许 TestFlight 分发。
- 是否允许 App 内分发模型文件。
- 是否需要 App 内开源声明页面。
- 是否需要 GitHub Pages 增加 license notice。
- 是否需要 App Store Review Notes 提到模型 license。
- 如果使用 binary `llama.xcframework`，需要确认 binary 对应的源码版本、license 和 notice。

## 8. 建议未来 App 内开源声明结构

建议在 About 页面新增“开源许可”入口。

页面结构草案：

| 名称 | 来源 URL | License | Copyright | Notice |
| --- | --- | --- | --- | --- |
| DestinyScope | 项目仓库 URL | 项目自有 | 待填写 | 待填写 |
| llama.cpp | https://github.com/ggml-org/llama.cpp | MIT | `2023-2026 The ggml authors` | 保留 MIT notice |
| ggml | 随 llama.cpp | MIT / 随上游确认 | The ggml authors | 随上游确认 |
| Qwen2.5-0.5B-Instruct | https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct | Apache 2.0 | Qwen Team / Alibaba Cloud，需人工确认 | 如有 NOTICE 需保留 |
| Qwen2.5-0.5B-Instruct-GGUF | https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF | Apache 2.0 | Qwen Team / Alibaba Cloud，需人工确认 | 如有 NOTICE 需保留 |

后续如果新增其他模型、wrapper、下载 SDK、压缩库或校验库，也必须加入该页面。
