# DestinyScope V1.5 Source-control 审计

检查日期：2026-06-01

## 1. 问题背景

V1.5 阶段 1 将 source-control 风险列为 P0。当前 `.gitignore` 中存在宽泛规则：

```gitignore
Models/
```

该规则会匹配任意层级的 `Models` 目录，因此误忽略：

```text
DestinyScope/Domain/Models/OpenSourceLicenseItem.swift
```

风险是本地仍能编译，但被忽略的 Swift 源码不会进入仓库；其他人 clone 后可能缺少源码文件。

## 2. 修复前检查

执行：

```bash
git status --short --ignored
git check-ignore -v DestinyScope/Domain/Models/OpenSourceLicenseItem.swift || true
find DestinyScope/Domain/Models -name "*.swift" -print
```

修复前结果：

- `DestinyScope/Domain/Models/OpenSourceLicenseItem.swift` 被 `.gitignore:70:Models/` 命中。
- `git status --short --ignored` 显示该文件为 ignored。
- `DestinyScope/Domain/Models` 下存在多个 Swift 源码文件，宽泛 `Models/` 规则存在继续误伤未来源码的风险。

## 3. .gitignore 修改内容

已将宽泛规则：

```gitignore
Models/
LocalModels/
```

收窄为：

```gitignore
# Local model artifacts
*.gguf
*.bin
*.safetensors
*.mlmodel
*.mlmodelc
*.xcframework

# Local model directories at repository root only.
# Do not use broad "Models/" because it also ignores DestinyScope/Domain/Models Swift sources.
/Models/
/LocalModels/

# Optional app-local model test directories
DestinyScope/LocalModels/
```

修复目标：

- 不再误忽略 `DestinyScope/Domain/Models/`。
- 继续忽略仓库根目录下的本地模型目录。
- 继续忽略 GGUF、bin、safetensors、Core ML 模型文件。
- 继续防止 app-local 测试模型目录进入仓库。

## 4. 修复后检查

执行：

```bash
git check-ignore -v DestinyScope/Domain/Models/OpenSourceLicenseItem.swift || true
find DestinyScope/Domain/Models -name "*.swift" -print0 | xargs -0 -I{} sh -c 'git check-ignore -v "{}" || true'
```

结果：

- `OpenSourceLicenseItem.swift` 不再被 `check-ignore` 命中。
- `DestinyScope/Domain/Models` 下 Swift 文件均不再被忽略。

## 5. Swift 文件跟踪状态

修复 `.gitignore` 后，`OpenSourceLicenseItem.swift` 从 ignored 状态变为未跟踪：

```text
?? DestinyScope/Domain/Models/OpenSourceLicenseItem.swift
```

已按本阶段要求将该 Swift 源码加入 git 索引：

```bash
git add DestinyScope/Domain/Models/OpenSourceLicenseItem.swift
```

本阶段未修改该 Swift 文件源码内容。

## 6. 模型文件忽略规则验证

执行：

```bash
git check-ignore -v test.gguf || true
git check-ignore -v LocalModels/test.gguf || true
git check-ignore -v Models/test.gguf || true
git check-ignore -v DestinyScope/LocalModels/test.gguf || true
git check-ignore -v test.xcframework || true
```

结果：

- `test.gguf` 仍被 `*.gguf` 忽略。
- `LocalModels/test.gguf` 仍被 `/LocalModels/` 忽略。
- `Models/test.gguf` 仍被 `/Models/` 忽略。
- `DestinyScope/LocalModels/test.gguf` 仍被 `DestinyScope/LocalModels/` 忽略。
- `test.xcframework` 仍被 `*.xcframework` 忽略。

## 7. 大文件扫描

执行：

```bash
find . \( -iname "*.gguf" -o -iname "*.bin" -o -iname "*.safetensors" -o -iname "*.mlmodel" -o -iname "*.mlmodelc" -o -iname "*.xcframework" \) -print
```

结果：

- 仓库内未发现 `.gguf`、`.bin`、`.safetensors`、`.mlmodel`、`.mlmodelc` 或 `.xcframework`。

## 8. 默认输出路径检查

执行：

```bash
rg -n "makeDefaultRefiner|TemplateTextRefiner" DestinyScope/Domain/TextRefining/TextRefinerFactory.swift
```

结果：

- `makeDefaultRefiner()` 仍返回 `TemplateTextRefiner()`。
- 本阶段未修改默认输出路径。

## 9. 构建结果

执行：

```bash
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Debug -destination 'generic/platform=iOS Simulator' build
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Release -destination 'generic/platform=iOS Simulator' build
```

结果：

- Debug 构建：通过。
- Release 构建：通过。

非阻断提示：

- `IDERunDestination: Supported platforms for the buildables in the current scheme is empty.`
- `The domain/default pair of (com.bytedance.jojo, JoJoBuildVersion) does not exist`
- `Embed Debug llama.xcframework` run script 当前每次构建都会运行，因为未启用 Based on dependency analysis。

## 10. 遗留风险

- 本阶段只修复 source-control 误忽略，不改 UI、不改业务逻辑、不改工程配置。
- 当前仓库扫描未发现模型文件或 `.xcframework`，但后续仍需在提交前持续执行质量门槛扫描。
