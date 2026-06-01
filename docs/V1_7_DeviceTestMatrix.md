# DestinyScope V1.7 Device Test Matrix

| id | device | os | screenCategory | testType | required | pages | status | notes |
|---|---|---|---|---|---:|---|---|---|
| D-001 | iPhone SE | 待填写 | Small | Small screen / Dynamic Type | Yes | Onboarding, Home, Result, Knowledge, History, Settings, Legal | pending | 检查按钮、Picker、长卡片和 Legal 长文 |
| D-002 | iPhone 12 mini | 待填写 | Small mini | Small screen / Tier C local model | Yes | Home, Result, Local model experiment, History, Data Management | pending | 应确认 Tier C 默认禁用本地模型实验 |
| D-003 | Standard iPhone | 待填写 | Standard | General regression | Yes | All default user paths | pending | 作为普通用户路径基准设备 |
| D-004 | iPhone 17 Pro Max | 待填写 | Large | Large screen / Local model experiment reference | Yes | Result, Local model experiment, Legal, Data Management | pending | 已知本地模型 PoC 性能较好，但 V1.7 不默认启用 |
| D-005 | iPad | 待填写 | Tablet | iPad layout | Yes | Onboarding, Home, Result, Knowledge, Legal | pending | 检查内容宽度、留白、长文阅读 |
| D-006 | Simulator | 当前 Xcode 环境 | Variable | Build smoke / Debug-only checks | Yes | Main flow, Debug local model page if needed | pending | 不代表真机性能 |
| D-007 | VoiceOver | 待填写 | Accessibility | VoiceOver | Yes | Onboarding, TabView, Home, Result, Knowledge, History, Settings, Legal | pending | 检查焦点顺序、label、hint |
| D-008 | Dynamic Type Accessibility Large | 待填写 | Accessibility | Dynamic Type | Yes | Home, Result, Knowledge, History, Settings, Legal | pending | 检查按钮不截断、长文可滚动 |
| D-009 | Dark Mode | 待填写 | All | Dark mode | Yes | All main pages | pending | 检查背景、卡片、文字、tag、错误提示对比度 |
| D-010 | Low Power Mode | 待填写 | Runtime | Runtime fallback | Yes | Local model experiment, Result | pending | 实验路径应回退，默认主流程不受影响 |
| D-011 | 本地模型实验关闭状态 | 待填写 | Safety | Local model boundary | Yes | Settings, Result | pending | 默认关闭，Release 不展示，结果页不默认调用 |
| D-012 | 本地数据管理危险操作 | 待填写 | Safety | Destructive action UX | Yes | Local Data Management | pending | 删除 / 清空必须确认，文案清楚，只影响本机 |

## 状态说明

- `pending`：尚未人工验证。
- `pass`：已按模板记录并通过。
- `fail`：发现问题，需要进入 issue backlog。
- `blocked`：缺少设备、系统环境或构建条件，无法执行。

## 记录要求

- 每次测试应使用 `docs/V1_7_ManualTestTemplate.md` 记录。
- 如果没有真机，不得标记为通过，应保持 `pending` 或 `blocked`。
- 发现问题后写入 `docs/V1_7_AccessibilityIssueBacklog.md`。
