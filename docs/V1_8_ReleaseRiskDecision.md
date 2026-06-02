# DestinyScope V1.8 Release Risk Decision

决策日期：2026-06-02

## 决策结论

Production Candidate: Conditional Go

V1.8 当前可以作为“生产候选”继续进入下一阶段真机生产包复测与上线前材料修复，但当前不得直接上传 App Store，也不建议立即上传 TestFlight，除非用户下一步明确要求并先完成 TestFlight readiness。

## 通过条件

当前已满足：

- Debug build 通过。
- Release build 通过。
- 指定 GGUF 已由 Git LFS 跟踪。
- 指定 GGUF 已进入 Release `.app` 产物。
- GGUF sha256 已记录。
- Release 可链接 `llama.framework`。
- Release `.app` 已嵌入 `Frameworks/llama.framework/llama`。
- `TextRefinerFactory.makeDefaultRefiner()` 当前返回 `AutoLocalTextRefiner()`。
- 设备不达标、模型不可用、framework 不可用、超时、异常或安全检查失败时回退模板。
- 模板结果始终保留。
- 本地润色不写入历史记录。
- Swift 源码未发现新增网络、在线 AI、StoreKit、CloudKit、追踪或敏感权限。
- 未发现用户可见高风险营销文案。

## 条件和限制

Conditional Go 的条件：

- 只能进入阶段 4：真机生产包复测与上线前材料修复。
- 不能直接进入 App Store 上传。
- 不能直接进入 TestFlight 上传，除非用户明确要求并重新执行 TestFlight checklist。
- 必须完成 iPhone 17 Pro Max 生产内置模型复测。
- 必须完成 iPhone 12 mini 生产内置模型复测。
- 必须记录真机模型加载、生成耗时、内存、发热、低电量和 fallback 行为。
- Qwen2.5 GGUF license / notice / commercial use / redistribution / App 内分发条件已由用户人工确认通过。
- 必须记录真实 Archive、IPA 或 App Store 分发体积。
- 必须复核 App Store 元数据、截图、Review Notes 和隐私政策 URL。

## 风险判断

### 技术风险

当前风险等级：Medium

- Release 构建和链接已通过。
- Release `.app` 中包含 GGUF 和 `llama.framework`。
- 结果页依赖启动后后台 preload；如果用户过快进入结果页，可能先回退模板。
- 该 preload 时机风险不阻断主流程，但会影响“默认本地润色”的实际触达率。
- 仍需真机生产包验证 dyld、加载、性能、内存和发热。

### 包体风险

当前风险等级：High

- 仓库 GGUF 约 `469 MiB`。
- `llama.xcframework` 目录约 `612M`。
- Release Simulator `.app` 约 `502M`。
- 真正上架前必须记录 Archive / IPA / App Store 分发体积，并评估下载成本和低存储设备体验。

### License / Notice 风险

当前风险等级：Low

- App 内开源许可页已有 Qwen2.5 / GGUF / llama.cpp / ggml 说明。
- Qwen2.5 base、Qwen2.5 GGUF、bundled `qwen2.5-0.5b-instruct-q4_k_m.gguf`、llama.cpp 和 `llama.xcframework` 分发 license 已由用户人工确认通过。
- Remaining license blocker：none。

### 隐私和合规风险

当前风险等级：Low to Medium

- 静态扫描未发现新增网络、在线 AI、支付、追踪或敏感权限。
- 隐私政策已说明设备端处理、不上传模型输入输出、不提供模型下载。
- 高风险词命中集中于禁止事项、安全规则和测试样例。
- 仍需复核 App Store 元数据、截图和 Review Notes，避免把本地润色包装成确定性预测或专业建议。

### 设备覆盖风险

当前风险等级：Medium

- 设备评分代码满足模拟器默认启用、高端设备默认启用、iPhone 12 mini 默认模板的策略。
- 本阶段没有真机生产包复测。
- iPhone 17 Pro Max 和 iPhone 12 mini 必须在下一阶段复测。

## Go / No-Go 判断

当前不是 No-Go，因为：

- Release 构建未失败。
- 模型已由 LFS 管理。
- Release `.app` 能找到模型文件。
- Release 可链接并嵌入 `llama.framework`。
- fallback 逻辑存在。
- 未发现新增网络、在线 AI、敏感权限、追踪或支付。
- 未发现高风险用户可见营销文案。

当前也不是 App Store Go，因为：

- 真机生产包未复测。
- license / notice 已完成用户人工确认和证据留档。
- Archive / IPA / 分发体积未记录。
- App Store 元数据、截图和 Review Notes 尚未完成 V1.8 生产候选复核。

## 下一阶段建议

进入：

V1.8 阶段 4：真机生产包复测与上线前材料修复。

阶段 4 建议覆盖：

- iPhone 17 Pro Max 生产内置模型加载和结果页润色。
- iPhone 12 mini 生产内置模型禁用 / fallback。
- 低电量模式 fallback。
- 长时间运行后的温度和内存观察。
- 断网完整主流程。
- Release Archive 体积记录。
- license / notice 人工留档已完成。
- App Store 元数据、截图、Review Notes 和隐私 URL 最终复核。
