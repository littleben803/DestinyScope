# DestinyScope V1.2 Model File Setup

更新日期：2026-05-27

本阶段只确认模型文件准备方案，不下载模型、不提交模型文件、不修改 Xcode 工程配置、不接真实推理。

## 1. 推荐首个 PoC 模型

首个 PoC 推荐：

- `Qwen2.5-0.5B-Instruct` 的 GGUF 4-bit 量化版本

推荐原因：

- 体积小，适合先验证 iOS 真机加载、内存峰值和耗时。
- 中文能力较好，适合 DestinyScope 的中文文本润色目标。
- 指令跟随能力满足“只能润色、不能新增结论”的 PoC 约束。
- 官方模型页面标注 Apache 2.0，license 风险相对清晰。
- 更适合最小 PoC，不会过早引入 1B+ 模型的包体和内存压力。

注意：具体 GGUF 文件仍需要人工确认来源、license、文件完整性和量化方式。

## 2. 备选模型

备选模型：

- `Qwen2.5-1.5B-Instruct-GGUF` 的 `Q4_K_M` 版本

备选原因：

- 中文表达质量可能优于 0.5B。
- 官方 GGUF 页面直接提供 llama.cpp 的 `Q4_K_M` 使用方式。
- 适合在 0.5B PoC 成功后做质量对比。

主要风险：

- 文件体积更大。
- 加载时间、内存峰值、发热和耗电压力更高。
- 更容易超过 V1.2 最小 PoC 的工程复杂度。

## 3. 模型文件命名建议

建议统一本地文件名，避免空格、大小写混乱和模型版本不清：

```text
qwen2_5_0_5b_instruct_q4.gguf
qwen2_5_1_5b_instruct_q4_k_m.gguf
```

如果实际下载文件名来自官方或可信量化 repo，可保留原始文件名，但需要在 PoC 记录中写清：

- 原始文件名
- 本地重命名后的文件名
- 来源 URL
- sha256
- license

## 4. 本地放置路径建议

优先使用仓库外路径：

```text
~/LocalModels/DestinyScope/
```

可选使用本地未跟踪路径：

```text
LocalModels/
```

当前 `.gitignore` 已包含：

```text
*.gguf
*.bin
*.safetensors
*.mlmodel
*.mlmodelc
Models/
LocalModels/
```

要求：

- 模型文件不得提交 git。
- 模型文件不得进入 Release 默认路径。
- 阶段 3C 如需真机调试，优先由开发者手动放入本地 Debug 测试目录。
- 不做 App 内模型下载功能。

## 5. License 检查清单

每个模型进入真实加载 PoC 前，必须完成以下记录：

| 检查项 | 记录 |
| --- | --- |
| 模型名称 | 待填写 |
| 模型 repo URL | 待填写 |
| 具体 GGUF 文件 URL | 待填写 |
| license 类型 | 待填写 |
| 是否 Apache 2.0 | 待填写 |
| 是否来自官方 repo 或可信量化 repo | 待填写 |
| 是否需要保留 license / notice | 待填写 |
| 是否允许商业使用 | 待填写 |
| 是否允许再分发 | 待填写 |
| 是否允许 App 内分发 | 待填写 |
| PoC 阶段是否只本地手动下载 | 是 |
| 是否需要 Hugging Face gated access | 待填写 |
| 人工确认人 | 待填写 |
| 人工确认日期 | 待填写 |

首轮建议填写：

- 模型 repo URL：`https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct`
- 备选 GGUF repo URL：`https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF`

license 判断不是法律意见。进入生产或随 App 分发前，必须由项目负责人人工复核。

## 6. 下载后的本地检查命令

以下命令只用于开发者本地检查，不会下载模型：

```bash
# 仓库外路径检查
ls -lh ~/LocalModels/DestinyScope/

# 指定文件是否存在
test -f ~/LocalModels/DestinyScope/qwen2_5_0_5b_instruct_q4.gguf && echo "model exists"

# 文件大小
du -h ~/LocalModels/DestinyScope/qwen2_5_0_5b_instruct_q4.gguf

# sha256
shasum -a 256 ~/LocalModels/DestinyScope/qwen2_5_0_5b_instruct_q4.gguf

# 确认 git 未跟踪模型文件
git status --short

# 确认仓库内没有误放 GGUF
find . -name "*.gguf" -print
```

如果使用 `LocalModels/` 作为仓库内本地测试目录，必须再次确认：

```bash
git status --short --ignored LocalModels/
find LocalModels -name "*.gguf" -print
```

`LocalModels/` 可以存在于本地，但不得进入 git 跟踪。

## 7. 进入阶段 3C 前门禁

进入真实加载前必须满足：

- 模型文件只存在于本地开发机。
- `git status --short` 不显示模型文件。
- `find . -name "*.gguf"` 不显示仓库内误提交文件，除非只显示被忽略的本地测试目录且不会提交。
- license / notice / 再分发条件已人工确认。
- Debug-only 入口仍然不影响 Release。
- 默认 `TextRefinerFactory` 仍返回 `TemplateTextRefiner`。
