# DestinyScope V1.8 Bundled Model Plan

## 1. 模型文件

V1.8 计划内置模型：

- 文件名：`qwen2.5-0.5b-instruct-q4_k_m.gguf`
- 模型大小：约 `491.4 MB`
- 目标用途：本地文本表达润色。
- 目标位置：App Bundle。
- Xcode 接入方式：Copy Bundle Resources。

模型只用于：

- 对已有模板文本做表达润色。
- 不生成新的命理结论。
- 不改变称骨计算、诗文匹配、命格洞察或问答结论。

## 2. Git 管理

普通 GitHub 仓库不能直接推送 100MB 以上普通文件。

V1.8 模型文件管理建议：

- 使用 Git LFS 跟踪 `.gguf`。
- 新增或更新 `.gitattributes`。
- 调整 `.gitignore`，允许指定 bundle model 路径进入 LFS。
- 继续忽略其他临时模型文件和开发者本地模型目录。

需要继续忽略：

- 根目录 `/LocalModels/`。
- 根目录 `/Models/`。
- 临时 `.bin`。
- 临时 `.safetensors`。
- 临时 `.mlmodel` / `.mlmodelc`。
- 仓库外 llama.cpp 源码。
- 非指定路径的 `.gguf` 临时文件。

## 3. 推荐路径

推荐内置模型路径：

```text
DestinyScope/Resources/Models/qwen2.5-0.5b-instruct-q4_k_m.gguf
```

推荐 `.gitattributes` 规则：

```text
DestinyScope/Resources/Models/*.gguf filter=lfs diff=lfs merge=lfs -text
```

推荐 `.gitignore` 策略：

```text
# Ignore local model artifacts by default
*.gguf
*.bin
*.safetensors
*.mlmodel
*.mlmodelc

# Allow production bundled model path to be tracked by Git LFS
!DestinyScope/Resources/Models/
!DestinyScope/Resources/Models/*.gguf

# Keep temporary local model dirs ignored
/Models/
/LocalModels/
DestinyScope/LocalModels/
```

实际实现前必须验证：

- `git lfs install` 已完成。
- `.gitattributes` 生效。
- 指定 GGUF 文件由 Git LFS 跟踪，而不是普通 Git blob。
- 其他临时模型文件仍被忽略。

## 4. License / Notice

当前候选：

- Qwen2.5-0.5B-Instruct：初步按 Apache 2.0 处理，最终以模型仓库为准。
- Qwen2.5-0.5B-Instruct-GGUF：需要确认具体 GGUF repo、文件来源、license 和 notice。
- llama.cpp：MIT License。

生产候选前必须归档：

- 模型 base repo URL。
- GGUF repo URL。
- 文件名。
- 文件大小。
- sha256。
- license。
- notice。
- 是否允许商业使用。
- 是否允许 App 内分发。
- 是否允许 TestFlight 分发。
- 人工确认人和确认日期。

App 内开源许可页面必须更新：

- Qwen2.5 模型条目。
- GGUF 文件来源。
- llama.cpp / ggml / GGUF 说明。
- license / notice 状态。

## 5. App Size 风险

内置约 491.4 MB 模型会显著增加 App 包体。

风险：

- 用户下载成本增加。
- App Store 包体审核和分发成本增加。
- 低存储设备体验下降。
- 更新 App 时下载体积增加。

初步判断：

- 约 500 MB 内置模型可以作为生产候选评估。
- 仍需记录最终 Archive 体积、安装后体积和 App Store 分发影响。
- 上架前必须明确 App Size 风险和用户体验取舍。

## 6. 不做模型下载

V1.8 不做：

- 模型下载。
- CDN。
- 断点续传。
- 远程 sha256 拉取。
- 模型更新服务。

如果未来改为按需下载，需要重新更新：

- 隐私政策。
- App Store Review Notes。
- 网络权限和下载说明。
- 存储管理和删除机制。

