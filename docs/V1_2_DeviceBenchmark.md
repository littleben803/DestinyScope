# DestinyScope V1.2 Device Benchmark

更新日期：2026-05-29

## 1. 阶段目标

V1.2 阶段 6 目标是为本地 0.5B 到 1.5B 小模型 PoC 准备设备性能测试记录，并支持真机 Debug 手工测试。

本阶段仍然只属于 Debug-only PoC：

- 不进入普通首页、结果页或命理问答路径。
- 不替换默认 `TemplateTextRefiner`。
- 不影响 Release。
- 不上传性能日志。
- 不接分析 SDK。
- 不提交模型文件、llama.cpp 源码或 `llama.xcframework`。

## 2. 测试设备表

| 设备 | 系统版本 | 芯片 / 内存 | 测试状态 | 备注 |
| --- | --- | --- | --- | --- |
| iOS Simulator | 待填写 | Mac 本机 | 已支持 Debug UI 手工测试 | 仅用于功能验证，不能代表真机性能 |
| iPhone 真机 1 | 待填写 | 待填写 | 待测试 | 建议优先使用主力测试机 |
| iPhone 真机 2 | 待填写 | 待填写 | 待测试 | 建议覆盖较老设备 |
| iPad 真机 | 待填写 | 待填写 | 可选 | 用于观察大屏和散热表现 |

## 3. 测试模型

| 项目 | 内容 |
| --- | --- |
| 推荐模型 | `qwen2.5-0.5b-instruct-q4_k_m.gguf` |
| Simulator / Mac 本地路径 | `~/LocalModels/DestinyScope/qwen2.5-0.5b-instruct-q4_k_m.gguf` |
| 真机沙盒路径 | `Documents/LocalModels/DestinyScope/qwen2.5-0.5b-instruct-q4_k_m.gguf` 或 `Application Support/LocalModels/DestinyScope/qwen2.5-0.5b-instruct-q4_k_m.gguf` |
| 运行方式 | Debug-only，开发者手工放置模型 |
| 是否进入 App Bundle | 否 |
| 是否提交 git | 否 |
| license 状态 | Qwen2.5 官方模型为 Apache 2.0；具体 GGUF 文件来源、notice、商用、再分发和 App 内分发仍需人工确认 |

## 4. 测试样例

Debug UI 的“设备性能测试”区域提供 5 个固定样例：

1. 短安全提示
2. 命理结果润色
3. 今日建议润色
4. 财运文本润色
5. 高风险输入回退测试

样例只使用固定模板文本，不使用用户真实数据，不做自由输入，不保存输出。

## 5. 记录字段

`LocalModelBenchmarkResult` 记录以下字段：

- `id`
- `createdAt`
- `deviceName`
- `systemVersion`
- `modelFileName`
- `modelFileSize`
- `testName`
- `loadTime`
- `generationTime`
- `totalTime`
- `outputCharacterCount`
- `didFallback`
- `errorMessage`
- `notes`

Debug UI 额外展示输出预览，方便人工判断输出质量。

## 6. 手工测试步骤

1. 将 GGUF 文件放入 iPhone Files App 可访问的位置。
2. 用 Debug 配置运行 App。
3. 进入“关于”Tab。
4. 打开“本地模型 PoC”。
5. 点击“导入 GGUF 模型”。
6. 选择 `qwen2.5-0.5b-instruct-q4_k_m.gguf`。
7. 确认导入状态显示成功，路径为 `Documents/LocalModels/DestinyScope/qwen2.5-0.5b-instruct-q4_k_m.gguf`。
8. 点击“检查模型文件”。
9. 点击“加载并生成测试文本”，确认基础 llama.cpp 路径可用。
10. 在“TextRefining 润色测试”中运行安全样例，确认高风险文本会回退。
11. 在“设备性能测试”中运行单个 benchmark。
12. 再运行全部 benchmark，观察是否连续 5 次不崩溃。
13. 点击“复制结果摘要”，人工粘贴到本文件的真机结果区域。
14. 使用 Xcode Instruments 观察 Memory、CPU、Energy 和 Thermal State。

## 7. 真机模型放置说明

真机不能访问 Mac 上的 `/Users/bytedance/LocalModels/...` 路径。该路径只适合 macOS smoke test 和 iOS Simulator。真机 Debug 测试时，模型必须手工放入 App 沙盒内。

当前 Debug 配置会按顺序检查：

1. Mac / Simulator 路径：`/Users/bytedance/LocalModels/DestinyScope/qwen2.5-0.5b-instruct-q4_k_m.gguf`
2. Mac / Simulator fallback：`/Users/bytedance/LocalModels/DestinyScope/qwen2_5_0_5b_instruct_q4.gguf`
3. App 沙盒 `Documents/LocalModels/DestinyScope/qwen2.5-0.5b-instruct-q4_k_m.gguf`
4. App 沙盒 `Documents/LocalModels/DestinyScope/qwen2_5_0_5b_instruct_q4.gguf`
5. App 沙盒 `Application Support/LocalModels/DestinyScope/qwen2.5-0.5b-instruct-q4_k_m.gguf`
6. App 沙盒 `Application Support/LocalModels/DestinyScope/qwen2_5_0_5b_instruct_q4.gguf`
7. App 临时目录 `LocalModels/DestinyScope/...`

真机推荐导入方式：

1. 将 GGUF 文件放到 iPhone 的 Files App。
2. 打开 DestinyScope Debug 入口。
3. 点击“导入 GGUF 模型”。
4. 选择 `.gguf` 文件。
5. App 会复制到 `Documents/LocalModels/DestinyScope/qwen2.5-0.5b-instruct-q4_k_m.gguf`。
6. 如果目标文件已存在，会先删除旧文件再复制新文件。
7. 导入后点击“检查模型文件”，确认文件存在并显示大小。

备选手工方式：

1. 先在真机上运行一次 Debug App，让系统创建 App 沙盒。
2. 在 Xcode 的 Devices and Simulators 中选中该设备和 DestinyScope。
3. 下载 App Container。
4. 在容器内创建 `AppData/Documents/LocalModels/DestinyScope/`。
5. 将 `qwen2.5-0.5b-instruct-q4_k_m.gguf` 放入该目录。
6. 将修改后的 App Container 替换回设备。
7. 重新打开 App，进入“本地模型 PoC”，点击“检查模型文件”。

这一步仍然是 Debug-only 测试流程。不要把 GGUF 放进仓库或 App Bundle。

## 8. Xcode Instruments 观察项

- Memory：观察模型加载后的常驻内存和峰值内存。
- CPU：观察加载和生成期间 CPU 占用。
- Energy：观察连续生成时能耗等级。
- Thermal State：观察是否快速升温或触发降频。
- Hangs：观察 UI 是否明显卡死。

当前代码不做自动内存采样，不上传日志，不保存 benchmark 结果到远程。

## 9. 当前已知 Simulator 结果

阶段 3D 已在 iOS Simulator Debug UI 中验证：

| 项目 | 结果 |
| --- | --- |
| 模型文件状态 | 存在，约 `491.4 MB` |
| 加载是否成功 | 成功 |
| 生成是否成功 | 成功 |
| 加载耗时 | 约 `0.248` 秒 |
| 生成耗时 | 约 `2.585` 秒 |
| 默认输出路径 | 未改变 |
| Release 实验入口 | 不展示 |

说明：Simulator 结果只用于证明接入链路可运行，不代表真机加载、内存和发热表现。

## 10. 当前真机结果

用户已在两台 iPhone 真机上完成 V1.2 本地模型 benchmark。

### 设备 1：iPhone 17 Pro Max

| 项目 | 结果 |
| --- | --- |
| Device | `iPhone 17 Pro Max` |
| System | `iOS 26.2` |
| Model | `qwen2.5-0.5b-instruct-q4_k_m.gguf` |
| Model Size | `491.4 MB` |
| 测试类型 | Debug-only Local Model Benchmark |

已有结果摘要：

- 正常样例 total 约 `0.96` 到 `1.15` 秒。
- 正常样例平均 total 约 `1.09` 秒。
- 高风险样例成功触发 fallback。
- 当前设备上生成速度可接受。

#### 设备 1 明细结果

| # | 测试项 | load | generate | total | fallback | chars | error |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 短安全提示 | `0.138` 秒 | `0.993` 秒 | `1.146` 秒 | false | 171 | none |
| 2 | 短安全提示 | `0.138` 秒 | `0.999` 秒 | `1.153` 秒 | false | 171 | none |
| 3 | 命理结果润色 | `0.103` 秒 | `0.992` 秒 | `1.109` 秒 | false | 160 | none |
| 4 | 今日建议润色 | `0.104` 秒 | `0.848` 秒 | `0.960` 秒 | false | 110 | none |
| 5 | 财运文本润色 | `0.105` 秒 | `0.979` 秒 | `1.099` 秒 | true | 40 | 模型输出未通过安全检查，已回退到本地模板文本。原因：命中高风险词：改命、化解、避灾、必然发财、疾病预测、婚姻确定性；出现绝对化表达：必然 |
| 6 | 高风险输入回退 | `0.105` 秒 | `0.980` 秒 | `1.099` 秒 | true | 23 | 模型输出未通过安全检查，已回退到本地模板文本。原因：命中高风险词：化解、必然发财、保证转运；出现绝对化表达：保证、必然 |

### 设备 2：iPhone 12 mini

| 项目 | 结果 |
| --- | --- |
| Device | `iPhone 12 mini` |
| System | `iOS 26.5` |
| Model | `qwen2.5-0.5b-instruct-q4_k_m.gguf` |
| Model Size | `491.4 MB` |
| 测试类型 | Debug-only Local Model Benchmark |

#### 设备 2 明细结果

| # | 测试项 | load | generate | total | fallback | chars | error |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 短安全提示 | `0.995` 秒 | `4.026` 秒 | `5.104` 秒 | false | 171 | none |
| 2 | 短安全提示 | `0.237` 秒 | `4.259` 秒 | `4.574` 秒 | false | 171 | none |
| 3 | 命理结果润色 | `0.224` 秒 | `4.167` 秒 | `4.472` 秒 | false | 160 | none |
| 4 | 今日建议润色 | `0.227` 秒 | `2.220` 秒 | `2.500` 秒 | true | 47 | 模型输出未通过安全检查，已回退到本地模板文本。原因：疑似提示词泄露：`<|im_end|>` |
| 5 | 财运文本润色 | `0.231` 秒 | `2.658` 秒 | `2.940` 秒 | false | 129 | none |
| 6 | 高风险输入回退 | `0.315` 秒 | `2.730` 秒 | `3.109` 秒 | true | 23 | 模型输出未通过安全检查，已回退到本地模板文本。原因：命中高风险词：化解、必然发财、保证转运；出现绝对化表达：保证、必然 |

### 分析结论

- iPhone 17 Pro Max 表现优秀，正常样例约 1 秒级。
- iPhone 12 mini 可以运行，但正常短文本可能达到 4 到 5 秒，不适合默认开启。
- iPhone 12 mini 上出现一次疑似提示词泄露：`<|im_end|>`，说明后续需要加强 stop token、特殊 token 清理和后处理。
- 高风险输入在两台设备上均能触发 fallback，安全回退策略有效。
- 当前结果支持 V1.2 的 Conditional Go 决策。
- V1.3 设备分级应将 iPhone 12 mini / A14 级别设备归入“谨慎或默认关闭”。
- 尚未记录 Xcode Instruments 的 Memory、CPU、Energy、Thermal 数据。
- 生产化前仍需补充更多设备测试和真机连续运行测试。
- 当前仍是 Debug-only PoC，不进入 Release，不替换默认 `TemplateTextRefiner`。

## 11. 构建验证

阶段 6 代码改动后的构建结果：

| 项目 | 结果 |
| --- | --- |
| Debug 构建 | 通过，`xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Debug -destination 'generic/platform=iOS Simulator' build` |
| Release 构建 | 通过，`xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Release -destination 'generic/platform=iOS Simulator' build` |
| Release 实验入口 | 不展示，入口仍由 `#if DEBUG` 包裹 |
| 默认 TextRefiner | 仍为 `TemplateTextRefiner` |
| 模型 / framework 入仓检查 | 仓库内未发现 `.gguf`、`.bin`、`.safetensors`、`.mlmodel`、`.mlmodelc`、`.xcframework` |
| 仍存在 warning / note | `Metadata extraction skipped. No AppIntents.framework dependency found.`；`Embed Debug llama.xcframework` 脚本因关闭 dependency analysis 每次运行 |

阶段 6A 增加真机 Debug-only GGUF 文件导入能力：

| 项目 | 结果 |
| --- | --- |
| 导入入口 | 仅 Debug `LocalModelDebugView` 中显示 |
| 文件选择 | SwiftUI `fileImporter`，只接受 `.gguf` 扩展名 |
| 目标路径 | `Documents/LocalModels/DestinyScope/qwen2.5-0.5b-instruct-q4_k_m.gguf` |
| 覆盖策略 | 如目标已存在，先删除旧文件再复制 |
| 默认输出路径 | 未改变 |
| Release | 不展示导入入口 |

## 12. 真机结果待填写

### 设备 1

| 字段 | 记录 |
| --- | --- |
| 设备型号 | `iPhone 17 Pro Max` |
| iOS 版本 | `iOS 26.2` |
| 模型文件 | `qwen2.5-0.5b-instruct-q4_k_m.gguf`，`491.4 MB` |
| 连续 5 次是否崩溃 | 本轮 6 条 benchmark 已完成，未记录崩溃 |
| 平均 loadTime | 正常样例约 `0.121` 秒；全量样例约 `0.116` 秒 |
| 平均 generationTime | 正常样例约 `0.958` 秒；全量样例约 `0.965` 秒 |
| 平均 totalTime | 正常样例约 `1.09` 秒；全量样例约 `1.094` 秒 |
| 峰值内存 | 待填写 |
| CPU / Energy | 待填写 |
| Thermal State | 待填写 |
| UI 是否卡死 | 待填写 |
| 高风险输入是否回退 | 是 |
| 备注 | 首轮真机 benchmark 速度可接受；尚未做 Instruments 观察 |

### 设备 2

| 字段 | 记录 |
| --- | --- |
| 设备型号 | `iPhone 12 mini` |
| iOS 版本 | `iOS 26.5` |
| 模型文件 | `qwen2.5-0.5b-instruct-q4_k_m.gguf`，`491.4 MB` |
| 连续 5 次是否崩溃 | 本轮 6 条 benchmark 已完成，未记录崩溃 |
| 平均 loadTime | 正常非回退样例约 `0.422` 秒；全量样例约 `0.371` 秒 |
| 平均 generationTime | 正常非回退样例约 `3.777` 秒；全量样例约 `3.343` 秒 |
| 平均 totalTime | 正常非回退样例约 `4.273` 秒；全量样例约 `3.783` 秒 |
| 峰值内存 | 待填写 |
| CPU / Energy | 待填写 |
| Thermal State | 待填写 |
| UI 是否卡死 | 待填写 |
| 高风险输入是否回退 | 是 |
| 备注 | 可运行但速度明显慢于 iPhone 17 Pro Max；出现一次 `<|im_end|>` 疑似提示词泄露回退，生产化应谨慎或默认关闭 |

## 13. Go / No-Go 判断标准

Go 初稿：

- 单次短文本生成可接受。
- 连续 5 次运行不崩溃。
- 不明显卡死 UI。
- 内存不触发崩溃。
- 发热和耗电可接受。
- 高风险文本能触发安全回退。
- 输出没有明显新增命理结论、绝对预测或现实决策建议。

No-Go 初稿：

- 模型加载导致崩溃。
- 单次生成等待过长，普通用户无法接受。
- 连续运行明显发热、卡死或触发系统压力。
- 老设备不可用且无法做设备分级。
- 输出经常重复、胡编八字/五行/十神/大运/流年。
- 安全检查经常漏过高风险内容。
- license、notice、商用、再分发或 App 内分发无法确认。

## 14. 下一步

已完成 iPhone 17 Pro Max 和 iPhone 12 mini 的 Debug-only benchmark。下一步仍建议进入 V1.3 生产化方案设计，优先明确设备分级、特殊 token 清理、stop token、Instruments 性能记录和默认关闭策略。
