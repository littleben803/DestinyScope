# DestinyScope V1.4 Legal Update Summary

更新日期：2026-06-01

## 1. 本阶段目标

V1.4 阶段 7 目标是落地 App 内开源许可页面，并更新 App 内隐私政策与 GitHub Pages 隐私页草案。本阶段不改变默认输出路径，不接生产功能，不修改本地模型推理逻辑。

## 2. App 内页面更新

已更新：

- `DestinyScope/UI/Legal/PrivacyPolicyView.swift`
- `DestinyScope/UI/Legal/DisclaimerView.swift`
- `DestinyScope/UI/Settings/AboutView.swift`
- `DestinyScope/UI/Settings/SettingsView.swift`

已新增：

- `DestinyScope/UI/Legal/OpenSourceLicensesView.swift`
- `DestinyScope/Domain/Models/OpenSourceLicenseItem.swift`

页面入口：

- 设置页新增“开源许可”入口。
- 关于页的“法律与隐私”区新增“开源许可”入口。
- 原有“隐私政策”和“免责声明”入口保留。

## 3. 开源许可页面内容

开源许可页面当前覆盖：

- `llama.cpp`
  - 来源：`https://github.com/ggml-org/llama.cpp`
  - License：MIT License
  - 说明：用于本地模型 Debug/TestFlight 实验路径；若未来随 App 分发 framework，需要保留 license / notice。
- `ggml / GGUF`
  - 来源：llama.cpp 项目相关组件
  - License：以 llama.cpp 仓库 LICENSE 为准
  - 说明：用于本地 GGUF 模型推理支持。
- `Qwen2.5-0.5B-Instruct / GGUF`
  - 来源：
    - `https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct`
    - `https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF`
  - License：Apache 2.0，最终以模型仓库为准
  - 说明：当前仅用于本地模型实验验证；进入 TestFlight 或 App Store 分发前仍需人工确认具体文件来源、LICENSE / NOTICE、商业使用、再分发和 App 内分发条件。

页面明确：

- 本页面不是法律意见。
- 如果未来 App 正式包含模型或框架，会继续补充相应 license / notice。
- 当前正式功能仍可在不启用本地模型实验的情况下使用。

## 4. 隐私政策更新重点

App 内隐私政策已补充：

- 当前正式功能无账号、无登录、无服务端、无在线 AI、无付费订阅、无广告追踪、无分析 SDK。
- 出生日期和出生时辰仅用于设备端本地计算。
- 当前版本不上传出生信息，也不上传命理结果。
- 本地历史记录仅保存在设备端，不上传、不云同步。
- 不使用定位、相机、相册、通讯录、麦克风等敏感权限。
- 本地模型润色实验默认关闭，需要用户手动开启。
- 本地模型只在设备端对已有模板文本做表达润色。
- 本地模型不生成新的命理结论，不替代称骨计算、诗文匹配、命格洞察或模板问答。
- 本地模型实验不上传模型输入、模型输出、出生信息、命理结果或历史记录。
- 润色结果默认不保存到历史记录。
- 失败、超时、低电量、过热或安全检查失败时回退本地模板文本。
- 当前版本不提供正式模型下载功能；未来如支持下载，需要更新隐私政策。

## 5. GitHub Pages 隐私页更新

已更新：

- `docs/privacy/index.html`
- `docs/privacy/privacy.md`

更新点：

- 内容与 App 内隐私政策保持一致。
- 保留中文主文案和英文摘要。
- 继续使用纯静态 HTML，不引用外部 JS、CSS、CDN 或远程字体。
- 补充本地历史记录和本地模型润色实验说明。
- 明确本地模型润色默认关闭、设备端运行、不上传模型输入输出。

## 6. 仍需人工确认

进入 TestFlight 或 App Store 分发前仍需人工确认：

- Qwen base repo license 原始页面和文件。
- Qwen GGUF repo license 原始页面和文件。
- 当前实际 GGUF 文件来源 URL。
- 是否存在 Qwen NOTICE 文件。
- llama.cpp / ggml license 和 notice。
- `llama.xcframework` 对应源码版本、license 和 notice。
- 是否允许 TestFlight 分发模型文件。
- 是否允许商业 App 内分发模型文件。
- App 内“开源许可”页面是否满足最终法务和审核要求。

## 7. 上架前复核

上架前需要再次复核：

- App 内隐私政策、GitHub Pages 隐私页、App Store Review Notes 和 App Store Connect 隐私说明是否一致。
- App Store 元数据是否避免夸大本地模型能力。
- 如果正式包包含模型或 framework，开源许可页面是否完整覆盖对应 license / notice。
- 如果未来新增模型下载，是否补充网络请求、模型文件大小、存储位置、删除方式和校验机制。

## 8. 结论

V1.4 阶段 7 已完成 App 内开源许可页面、隐私政策更新和 GitHub Pages 隐私页草案同步。当前仍不改变默认输出路径，不修改 `TextRefinerFactory.makeDefaultRefiner()`，本地模型润色仍是受控实验路径。
