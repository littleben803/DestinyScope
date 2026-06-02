# DestinyScope V1.8 Production Local AI Implementation Report

## 阶段结论

V1.8 阶段 2 已完成生产候选本地 AI 润色一次性接入，并同步完成首页第一屏主路径强化。

本阶段的方向变更来自用户明确要求：

- 本地模型从 Debug 实验路径升级为生产候选能力。
- 模型文件直接打包进 App 安装包。
- 设备评分达标时默认启用本地润色。
- 模拟器默认启用本地润色。
- 用户不需要手动开启本地润色。
- 不达标、失败、超时、低电量、过热或安全检查失败时自动回退模板。
- 首页第一屏聚焦生辰查询，查询按钮尽量首屏可见。

## 模型与 Framework

内置模型：

- 文件名：`qwen2.5-0.5b-instruct-q4_k_m.gguf`
- 路径：`DestinyScope/Resources/Models/qwen2.5-0.5b-instruct-q4_k_m.gguf`
- 文件大小：约 469 MiB，约 491.4 MB
- sha256：`74a4da8c9fdbcd15bd1f6d01d621410d31c6fc00986f5eb687824e7b93d7a9db`

Framework：

- 路径：`DestinyScope/Frameworks/llama.xcframework`
- 来源：仓库外本地构建产物
- Xcode 通过标准 `ProcessXCFramework` 处理。
- 已移除旧的手工 `Embed llama.xcframework` 脚本阶段，避免重复 rsync 破坏 framework bundle。

## 真机 dyld Crash 修复

用户在真机 Debug 运行时遇到启动崩溃：

- `Library not loaded: @rpath/llama.framework/llama`
- `DestinyScope.debug.dylib` 已链接 `llama.framework`
- 但 App 包内缺少 `DestinyScope.app/Frameworks/llama.framework/llama`

根因：

- 工程已通过 `FRAMEWORK_SEARCH_PATHS` 和 `OTHER_LDFLAGS = -framework llama` 链接 `llama.framework`。
- 但 target 缺少标准 `Embed Frameworks` copy phase。
- 真机启动时 dyld 无法在 App bundle 的 `Frameworks` 目录找到动态 framework。

修复：

- 在 `DestinyScope.xcodeproj/project.pbxproj` 为 `DestinyScope` target 新增 `Embed Frameworks` phase。
- 嵌入 `llama.framework`，并设置 `CodeSignOnCopy` 与 `RemoveHeadersOnCopy`。
- 保持 `llama.xcframework` 由 Xcode `ProcessXCFramework` 选择对应平台 slice。

验证：

- Debug 真机平台构建通过：`xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Debug -destination 'generic/platform=iOS' build`
- 构建产物已包含：`DestinyScope.app/Frameworks/llama.framework/llama`
- Release Simulator 构建通过，并同样嵌入 `DestinyScope.app/Frameworks/llama.framework/llama`
- Release 真机平台构建通过，并同样嵌入和签名 `DestinyScope.app/Frameworks/llama.framework/llama`

## Git LFS 与忽略规则

新增 `.gitattributes`：

- `DestinyScope/Resources/Models/*.gguf` 使用 Git LFS。
- `DestinyScope/Frameworks/llama.xcframework/**` 使用 Git LFS。

更新 `.gitignore`：

- 继续忽略普通临时模型文件：`*.gguf`、`*.bin`、`*.safetensors`、`*.mlmodel`、`*.mlmodelc`、`*.xcframework`。
- 仅放行生产候选路径：
  - `DestinyScope/Resources/Models/*.gguf`
  - `DestinyScope/Frameworks/llama.xcframework/**`
- 继续避免宽泛 `Models/` 误伤 `DestinyScope/Domain/Models/*.swift`。

注意：

- `git lfs install` 已尝试执行，但当前仓库已有 `pre-push` hook，Git LFS 提示不能直接覆盖。
- 当前 Git LFS filter 配置可用，`.gitattributes` 已确保后续 `git add` 指定模型和 framework 时走 LFS。
- 未执行 `git commit` 或 `git push`。

## 设备评分与默认启用

新增设备评分路径：

- `LocalModelDeviceScore`
- `LocalModelDeviceScoringService`
- `ProductionLocalAIAvailability`

默认策略：

- 模拟器：score 100，默认启用。
- iPhone 17 Pro Max / 新款高端设备：高分，默认启用。
- A17 Pro / A18 / A19 等高性能设备：默认启用候选。
- iPhone 12 mini / `iPhone13,1`：score 35，默认模板。
- unknown：score 50，默认模板。

硬性禁用条件：

- 低电量模式。
- thermal serious / critical。
- 内置模型缺失。
- llama framework 不可用。
- Tier C。
- unknown 真机。

超时策略：

- 高分 / Tier A：3 秒。
- 中等可用设备：5 秒。
- 不达标设备：不运行本地模型。

## TextRefining 默认策略

`TextRefinerFactory.makeDefaultRefiner()` 已从固定 `TemplateTextRefiner()` 调整为 `AutoLocalTextRefiner()`。

新的默认语义：

- 若 `ProductionLocalAIAvailability` 达标，使用 `LocalLlamaTextRefiner` 做本地文本润色。
- 若不达标、失败、超时、安全检查失败或模型不可用，自动回退 `TemplateTextRefiner`。
- 本地模型只润色已有文本，不生成新的命理结论。
- 本地模型输出不写入历史记录。
- 不上传模型输入输出。

## 结果页接入

新增 `ProductionLocalRefiningCard`。

展示策略：

- 模板结果始终保留。
- 本地润色版作为独立卡片展示。
- 文案标注“设备端生成，只做表达润色，不改变命理结论”。
- 不写“AI 算命”。
- 不宣传预测准确性。
- 失败时回退模板，不覆盖原始结果。

## 首页第一屏强化

首页结构已压缩为查询优先：

- 顶部 Hero 缩短。
- 查询输入卡片前置。
- 出生日期、时辰、查询按钮更靠近第一屏。
- 本地隐私提示内嵌到输入卡片中。
- 常用资料、历史草稿、最近历史和知识库入口后置。

保持边界：

- 不自动查询。
- 不上传数据。
- 不请求网络。
- 常用资料和历史草稿仍只填入输入，不触发计算。

## 隐私与 Legal 文案

已更新：

- App 内隐私政策。
- App 内开源许可说明。
- GitHub Pages 隐私页 Markdown。
- GitHub Pages 隐私页 HTML。

重点：

- 本地模型生产候选为设备端处理。
- 内置模型不需要下载。
- 不上传出生信息、命理结果、模型输入输出或历史记录。
- 模型只做表达润色，不生成新的命理结论。

## 构建结果

Debug build：

- 通过。
- 命令：`xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Debug -destination 'generic/platform=iOS Simulator' build`

Release build：

- 通过。
- 命令：`xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Release -destination 'generic/platform=iOS Simulator' build`

真机平台构建：

- Debug 通过。
- 命令：`xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Debug -destination 'generic/platform=iOS' build`
- Release 通过。
- 命令：`xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Release -destination 'generic/platform=iOS' build`
- Debug / Release 真机平台产物均已嵌入并签名 `DestinyScope.app/Frameworks/llama.framework/llama`。

已知非阻断提示：

- `AppIntents.framework dependency found` 相关 metadata skipped 提示仍存在，为既有非阻断提示。
- `LlamaCppSession.swift` 中 `var batch` 可改为 `let` 的 warning 仍存在，不影响构建。

## 未解决问题

- 需要人工最终确认 Qwen2.5 GGUF 来源、license、notice、商业使用和 App 内分发条件。
- 需要真实 Archive 后记录最终 App 包体和安装体积。
- 需要真机验证内置模型 bundle 路径与 framework 加载路径。
- `git lfs install` 因已有 `pre-push` hook 未自动安装 hook，后续如需要可人工合并 hook 或执行 `git lfs update --manual`。
