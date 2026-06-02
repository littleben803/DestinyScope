# DestinyScope V1.7 Test Report

更新日期：2026-06-02

## 1. V1.7 阶段完成情况

| 阶段 | 状态 | 说明 |
|---|---|---|
| V1.7 阶段 1：多设备人工验收与无障碍修复计划 | 完成 | 已建立验收范围、设备矩阵、问题 backlog 和人工测试模板。 |
| V1.7 阶段 2：人工验收记录汇总 | 完成 | 已根据用户人工自测反馈记录 iPhone 17 Pro Max、iPhone 12 mini、VoiceOver、Dynamic Type、深色模式、小屏、iPad、本地模型加载和运行均 OK。 |
| V1.7 阶段 3：P0 可访问性与小屏修复 | No-op 完成 | 复核后当前无 P0 / P1 / P2 issue，不需要代码修复。 |
| V1.7 阶段 4：深色模式与 Dynamic Type 修复 | Skipped | 用户人工自测反馈 OK，无对应修复项。 |
| V1.7 阶段 5：Legal 长文与开源许可可读性修复 | Skipped | 用户人工自测反馈 OK，无对应修复项。 |
| V1.7 阶段 6：首页 / 结果页 / 知识库 / 历史回归测试 | Merged into 阶段 7 | 本轮回归结果合并到 V1.7 收尾自测记录。 |
| V1.7 阶段 7：自测与下一步决策 | 完成 | 已完成构建检查、静态扫描、人工验收回顾和下一步决策。 |

## 2. 构建结果

| 项目 | 命令 | 结果 |
|---|---|---|
| Debug build | `xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Debug -destination 'generic/platform=iOS Simulator' build` | 通过 |
| Release build | `xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Release -destination 'generic/platform=iOS Simulator' build` | 通过 |

构建日志中的已知非阻断提示：

- `IDERunDestination: Supported platforms for the buildables in the current scheme is empty.`
- `The domain/default pair of (com.bytedance.jojo, JoJoBuildVersion) does not exist`
- `Run script build phase 'Embed Debug llama.xcframework' will be run during every build because "Based on dependency analysis" is unchecked.`
- `Metadata extraction skipped. No AppIntents.framework dependency found.`
- `No AppShortcuts found - Skipping.`

这些提示不阻塞 V1.7 收尾；如后续进入工程卫生专项，可再判断是否清理 Xcode script phase dependency analysis 提示。

## 3. 仓库与静态扫描结果

| 检查项 | 结果 | 说明 |
|---|---|---|
| `git diff --check` | 通过 | 无 whitespace error 输出。 |
| `git status --short --ignored` | 通过，存在 docs 工作区变更 | 当前仅记录 docs 变更和既有 ignored 项，如 `.DS_Store`、Xcode workspace 用户数据、`Pods/`。 |
| `OpenSourceLicenseItem.swift` 是否被忽略 | 通过 | `git check-ignore` 无命中。 |
| `DestinyScope/Domain/Models/*.swift` 是否被忽略 | 通过 | `git check-ignore` 无命中。 |
| 模型 / framework 文件扫描 | 通过 | 仓库内未发现 `.gguf`、`.bin`、`.safetensors`、`.mlmodel`、`.mlmodelc` 或 `.xcframework`。 |
| `makeDefaultRefiner()` | 通过 | `DestinyScope/Domain/TextRefining/TextRefinerFactory.swift` 仍返回 `TemplateTextRefiner()`。 |
| 网络 / 支付 / 权限 / 追踪扫描 | 通过 | 命中集中在 docs 检查项和历史报告，未发现 Swift 源码新增 `URLSession`、OpenAI、StoreKit、CloudKit、ATTrackingManager、CLLocation 或敏感权限 key。 |
| 高风险文案扫描 | 通过，需语境区分 | 命中集中在禁止事项说明、安全规则、SafetyChecker 词表和 Debug-only 测试样例，不属于营销文案或功能承诺。 |

## 4. 人工验收总结

基于 `docs/V1_7_ManualTestRecords.md` 和 `docs/V1_7_ManualTestSummary.md`：

- iPhone 17 Pro Max：用户人工自测 OK。
- iPhone 12 mini：用户人工自测 OK。
- VoiceOver：用户人工自测 OK。
- Dynamic Type：用户人工自测 OK。
- 深色模式：用户人工自测 OK。
- 小屏：用户人工自测 OK。
- iPad：用户人工自测 OK。
- 本地模型加载和运行：用户人工自测 OK。
- `pendingCount = 0`。
- 当前无 P0 / P1 / P2 issue。

本报告不新增或伪造新的人工测试结果，只汇总用户已反馈结果和本轮实际构建 / 静态扫描结果。

## 5. 本地模型实验边界

当前仍保持：

- `makeDefaultRefiner()` 返回 `TemplateTextRefiner()`。
- 本地模型实验默认关闭。
- 本地模型不进入默认结果页。
- 本地模型润色结果不写入历史记录。
- Release 不应暴露本地模型实验入口。
- 模型文件仍由本地导入或开发者准备，不提交仓库，不打入当前 Release。
- 不做模型下载、不接服务端、不请求网络。

## 6. 默认主流程状态

当前默认主流程仍为：

- 首页手动输入或选择本地资料。
- 用户手动点击查询。
- 本地规则生成 `LifeWeightResult`。
- 本地模板生成 `FortuneInterpretation`。
- 本地规则生成 `LifeWeightInsight`。
- 命理问答使用本地模板。
- 历史、常用资料、知识库状态均只保存在本机。

默认主流程不依赖本地模型，不上传用户数据，不接账号、同步、服务端或在线 AI。

## 7. 未解决的非阻断问题

- Release / Debug 构建日志可能仍出现 Debug `llama.xcframework` script phase dependency analysis 提示。
- AppIntents metadata skipped 提示仍可能出现。
- JoJoBuildVersion defaults 缺失提示仍可能出现。
- 上架前仍需要重新执行 release readiness、签名、版本号、GitHub Pages 隐私 URL 公网可访问性、license / notice、素材授权和 App Store Review Notes 检查。

## 8. V1.7 结论

- V1.7 Accessibility & Multi-device QA：Pass。
- 当前无 P0 / P1 / P2 修复项。
- TestFlight Upload：Not Now。
- App Store Release：No-Go。
- Local Model Default Enablement：No-Go。
- Continue Product Polish：Go。

