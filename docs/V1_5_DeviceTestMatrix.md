# DestinyScope V1.5 Device Test Matrix

| Device | OS | Screen Size Category | Test Focus | Required | Notes |
|---|---|---|---|---:|---|
| iPhone SE | Latest available iOS | Small | 首页输入、DatePicker / Picker、结果页卡片、Legal 长文、小按钮 | Yes | 小屏截断和 Dynamic Type 优先检查 |
| iPhone 12 mini | iOS 26.5 or latest available | Small / mini | 小屏适配、本地模型 Tier C 禁用、历史删除确认 | Yes | 已知本地模型约 4-5 秒，不适合默认开启 |
| iPhone 17 Pro Max | iOS 26.2 or latest available | Large / Pro Max | 结果页长文、知识库、历史、本地模型 Tier A 实验路径 | Yes | 已知 0.5B Q4 本地模型约 1 秒级 |
| Standard iPhone | Latest available iOS | Standard | 普通用户主流程、知识库搜索、深色模式 | Recommended | 可用 iPhone 15 / 16 / 17 标准机型补充 |
| iPad | Latest available iPadOS | Tablet | iPad 留白、卡片宽度、横竖屏、Legal 长文 | Recommended | 重点检查内容是否过宽 |
| iOS Simulator | Current Xcode runtime | Debug / variable | 快速回归、截图前检查、Developer LocalModels fallback | Yes | 不代表真机性能 |
| 真机低电量模式 | Latest available iOS | Runtime state | 本地模型实验禁用 / 回退、按钮状态、提示文案 | Yes | 不上传日志，不保存模型输出 |
| 真机深色模式 | Latest available iOS | Appearance | 背景、卡片、主文字、朱砂红、暗金、错误状态 | Yes | Legal 长文和开源 URL 必测 |
| VoiceOver | Latest available iOS | Accessibility | 焦点顺序、按钮 label / hint、删除和清空确认 | Yes | 至少覆盖首页、结果页、历史、设置、Legal |
| Dynamic Type Accessibility Large | Latest available iOS | Accessibility | 大字号布局、长按钮、tags / chips、Legal 长文 | Yes | 检查是否截断或溢出 |

## 测试优先级

P0 必测：

- iPhone SE 或 mini 小屏。
- 一台高性能 Pro Max。
- 深色模式。
- VoiceOver。
- Dynamic Type Accessibility Large。
- Release 隐藏本地模型实验入口。

P1 建议：

- 标准 iPhone。
- iPad。
- 低电量模式。
- 本地模型实验完整 fallback 路径。

## 记录字段

每次设备测试建议记录：

- Device。
- OS。
- App configuration: Debug / Release。
- Appearance: Light / Dark。
- Dynamic Type size。
- VoiceOver: On / Off。
- Main flow result。
- Knowledge flow result。
- History flow result。
- Legal flow result。
- Local model experiment visibility。
- Issues found。
- Screenshots if needed.

