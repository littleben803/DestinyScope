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

## 5. Accessibility / Dark Mode / Small Screen Gate

V1.5 进入下一步决策前，应至少完成以下人工 gate：

Accessibility：

- VoiceOver 可按合理顺序读出首页、结果页、知识库、历史、设置和 Legal 页面。
- 删除、清空、导入、生成、重新生成等关键按钮具备可理解的 label / hint。
- 错误状态和空状态可被读出，且说明下一步。
- 本地模型实验路径不会被朗读成默认命理能力。

Dynamic Type：

- 默认、Large、Extra Large、Accessibility Large 至少各检查一次。
- 首页输入区不挤压。
- 结果页卡片、tags、按钮和免责声明不截断。
- 知识库分类 chips、搜索、详情页 source URL 不溢出。
- 历史记录列表和详情仍可读。
- Legal 页面长文可完整滚动。

Dark Mode：

- 背景、卡片、主文字、次文字对比足够。
- 朱砂红、暗金、tag / chip / badge、divider 在深色模式下可读。
- 错误提示和 fallback 提示在深色模式下明显但不刺眼。
- Legal 长文不出现低对比度段落。

Small Screen / iPad：

- iPhone SE / mini 上 DatePicker、Picker、按钮、TabView 不明显截断。
- 结果页长文可完整滚动。
- 知识库分类 chips 可横向滚动。
- 开源许可长 URL 可换行。
- iPad 上内容宽度和留白需要人工确认。

Local Model Experiment：

- Release 不展示实验入口。
- `makeDefaultRefiner()` 仍返回 `TemplateTextRefiner`。
- 实验开关默认关闭，未接受说明不能开启。
- Tier C / unknown 不可用。
- 模型不存在、低电量、过热、超时、安全检查失败时回退。
- 润色结果不覆盖原始文本、不写入历史记录。

参考文档：

- `docs/V1_5_AccessibilityDarkModeSmallScreenPlan.md`
- `docs/V1_5_QAChecklist.md`
- `docs/V1_5_DeviceTestMatrix.md`

## 6. V1.5 决策门槛

V1.5 结束时必须给出下一步决策：

- 继续产品体验优化。
- 恢复 TestFlight 上传准备。
- 进入 App Store 上架资源确认。
- 暂停本地模型相关推进。

任何进入 TestFlight 或 App Store 的决策，都必须重新执行 V1.4 readiness 检查，并确认 license / notice、隐私政策、GitHub Pages、公网 URL、签名和测试说明。
