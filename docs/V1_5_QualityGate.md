# DestinyScope V1.5 Quality Gate

## 1. V1.5 质量门槛

必须满足：

- Debug 构建通过。
- Release 构建通过。
- 仓库不包含 `.gguf` / `.xcframework` / `.bin` / `.safetensors` / `.mlmodel` / `.mlmodelc`。
- `makeDefaultRefiner()` 仍返回 `TemplateTextRefiner`。
- Release 不展示本地模型实验入口，除非未来另有正式决策。
- 默认主流程不依赖模型。
- 隐私政策不夸大承诺。
- 文案不包含高风险营销词。
- App 内没有新增权限申请。
- 没有新增网络请求。
- 没有新增支付 / StoreKit。
- 没有新增广告追踪。

## 2. Source-control 检查

必须检查：

- `.gitignore` 不应误忽略 `DestinyScope/Domain/Models/*.swift`。
- `OpenSourceLicenseItem.swift` 必须可被 git 跟踪。
- 未来新增 Swift 文件不能被 `Models/` 规则误忽略。
- `LocalModels/` 和模型文件仍必须被忽略。
- 仓库外模型文件不能进入 git。

V1.5 阶段 2 最终确认规则：

```gitignore
# Local model artifacts
*.gguf
*.bin
*.safetensors
*.mlmodel
*.mlmodelc
*.xcframework

# Local model directories at repository root only.
/Models/
/LocalModels/

# Optional app-local model test directories
DestinyScope/LocalModels/
```

注意：

- 不再使用宽泛的 `Models/`，避免误忽略 `DestinyScope/Domain/Models`。
- `OpenSourceLicenseItem.swift` 已从 ignored 状态恢复为可跟踪源码。

## 3. 静态扫描命令建议

```bash
git status
```

```bash
git check-ignore -v DestinyScope/Domain/Models/OpenSourceLicenseItem.swift
```

```bash
find DestinyScope/Domain/Models -name "*.swift" -print0 | xargs -0 -I{} sh -c 'git check-ignore -v "{}" || true'
```

```bash
git check-ignore -v test.gguf || true
git check-ignore -v LocalModels/test.gguf || true
git check-ignore -v Models/test.gguf || true
git check-ignore -v DestinyScope/LocalModels/test.gguf || true
git check-ignore -v test.xcframework || true
```

```bash
find . \( -iname "*.gguf" -o -iname "*.xcframework" -o -iname "*.bin" -o -iname "*.safetensors" -o -iname "*.mlmodel" -o -iname "*.mlmodelc" \) -print
```

```bash
rg -n "URLSession|OpenAI|StoreKit|CloudKit|ATTrackingManager|CLLocation|NSCameraUsageDescription|NSPhotoLibraryUsageDescription" DestinyScope
```

```bash
rg -n "精准预测|改命|化解|避灾|必然发财|保证转运|疾病预测|寿命预测|投资收益确定|婚姻确定性" DestinyScope docs
```

## 4. 人工测试项

- 首页查询。
- 结果页阅读。
- 命理问答。
- 本地润色预览实验关闭状态。
- 知识库。
- 历史记录。
- 设置 / 关于。
- 隐私政策。
- 免责声明。
- 开源许可。
- 深色模式。
- 小屏设备。
- 飞行模式。

## 5. V1.5 决策门槛

V1.5 结束时必须给出下一步决策：

- 继续产品体验优化。
- 恢复 TestFlight 上传准备。
- 进入 App Store 上架资源确认。
- 暂停本地模型相关推进。

任何进入 TestFlight 或 App Store 的决策，都必须重新执行 V1.4 readiness 检查，并确认 license / notice、隐私政策、GitHub Pages、公网 URL、签名和测试说明。
