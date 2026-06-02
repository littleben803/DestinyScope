# DestinyScope V1.8 Device Scoring Plan

## 1. 评分目标

设备评分用于判断是否默认启用本地 AI 润色。

目标：

- 高端设备默认开启本地 AI 润色。
- 低端设备默认使用模板文本。
- 模拟器默认开启，方便开发验证。
- 设备运行状态不佳时自动禁用或回退模板。
- 评分只影响本地润色，不影响称骨计算和模板结论。

## 2. 评分维度

设备评分建议包含：

- `device identifier`。
- `physicalMemory`。
- `thermalState`。
- `lowPowerMode`。
- bundled model availability。
- llama framework availability。

运行时硬禁用条件：

- 低电量模式。
- thermal serious / critical。
- 模型文件缺失。
- llama framework 缺失。
- 安全检查失败。
- 连续失败过多。

## 3. 初始分数建议

| 设备 / 条件 | 初始分数 | 说明 |
|---|---:|---|
| Simulator | 100 | 模拟器默认开启，用于开发验证。 |
| iPhone 17 Pro Max / future high-end | 95 | 已知真机约 1 秒级，适合默认开启。 |
| A17 Pro / A18 / A19 level | 90 | 高性能设备候选。 |
| recent Pro models | 80 | 近期 Pro 机型候选。 |
| recent standard iPhone | 70 | 可运行但默认开启需谨慎。 |
| iPhone 12 mini / iPhone13,1 | 35 | 已知约 4 到 5 秒，不适合默认开启。 |
| unknown | 50 | 未识别设备保守处理。 |

## 4. 阈值

推荐阈值：

- `score >= 75`：默认开启本地 AI 润色。
- `score < 75`：默认使用模板文本。
- `lowPowerMode == true`：直接禁用本地 AI 润色。
- `thermalState == serious / critical`：直接禁用本地 AI 润色。
- `model missing`：直接禁用本地 AI 润色。
- `framework missing`：直接禁用本地 AI 润色。

说明：

- 阈值只决定是否运行本地润色。
- 不达标设备仍可正常使用 App 主流程。
- 不达标设备不影响称骨计算、模板解读、知识库、历史记录或分享。

## 5. 超时策略

推荐初稿：

- 高分设备：3 秒。
- 中等设备：5 秒。
- 低分设备：不运行本地 AI 润色。
- 任何设备加载失败立即回退模板。
- 任何设备安全检查失败立即回退模板。

超时后：

- 不重试多次。
- 不阻塞结果页。
- 保留模板文本。
- 可显示温和提示，或不打扰用户。

## 6. 后续实现建议

V1.8 阶段 2 实现时建议新增或调整：

- `DeviceScoringService`。
- `LocalAIAvailability`。
- bundled model resolver。
- runtime fallback policy。
- timeout policy。

保守原则：

- 未识别设备默认低于阈值。
- 高端设备默认开启，但仍受低电量、过热、模型缺失、framework 缺失和安全检查约束。
- iPhone 12 mini / `iPhone13,1` 明确不默认开启。

