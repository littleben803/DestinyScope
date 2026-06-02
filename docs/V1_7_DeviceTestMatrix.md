# DestinyScope V1.7 Device Test Matrix

| id | device | os | screenCategory | testType | required | pages | status | notes |
|---|---|---|---|---|---:|---|---|---|
| D-001 | iPhone SE | 用户未补充 | Small | Small screen / Dynamic Type | Yes | Onboarding, Home, Result, Knowledge, History, Settings, Legal | Pass | 用户反馈小屏与 Dynamic Type 已人工自测 OK；主要由 iPhone 12 mini 覆盖，iPhone SE 专项信息待补充 |
| D-002 | iPhone 12 mini | 用户未补充 | Small mini | Small screen / Tier C local model | Yes | Home, Result, Local model experiment, History, Data Management | Pass | 用户人工反馈 OK |
| D-003 | Standard iPhone | 用户未补充 | Standard | General regression | Yes | All default user paths | Pass | 用户反馈默认主流程人工自测 OK |
| D-004 | iPhone 17 Pro Max | 用户未补充 | Large | Large screen / Local model experiment reference | Yes | Result, Local model experiment, Legal, Data Management | Pass | 用户人工反馈 OK |
| D-005 | iPad | 用户未补充 | Tablet | iPad layout | Yes | Onboarding, Home, Result, Knowledge, Legal | Pass | 用户人工反馈 iPad OK；具体型号待补充 |
| D-006 | Simulator | 当前 Xcode 环境 | Variable | Build smoke / Debug-only checks | Yes | Main flow, Debug local model page if needed | Pass | 用户反馈模拟器 / 本地模型路径和运行 OK；不代表真机性能 |
| D-007 | VoiceOver | 用户未补充 | Accessibility | VoiceOver | Yes | Onboarding, TabView, Home, Result, Knowledge, History, Settings, Legal | Pass | 用户人工反馈 OK |
| D-008 | Dynamic Type Accessibility Large | 用户未补充 | Accessibility | Dynamic Type | Yes | Home, Result, Knowledge, History, Settings, Legal | Pass | 用户人工反馈 OK |
| D-009 | Dark Mode | 用户未补充 | All | Dark mode | Yes | All main pages | Pass | 用户人工反馈 OK |
| D-010 | Low Power Mode | 用户未补充 | Runtime | Runtime fallback | Yes | Local model experiment, Result | Pass | 用户人工反馈本地模型加载和运行路径 OK |
| D-011 | 本地模型实验关闭状态 | 用户未补充 | Safety | Local model boundary | Yes | Settings, Result | Pass | 用户人工反馈 OK |
| D-012 | 本地数据管理危险操作 | 用户未补充 | Safety | Destructive action UX | Yes | Local Data Management | Pass | 用户人工反馈 OK |

## 状态说明

- `Pending`：尚未人工验证。
- `Pass`：已按模板记录并通过。
- `Fail`：发现问题，需要进入 issue backlog。
- `Blocked`：缺少设备、系统环境或构建条件，无法执行。

## V1.7 阶段 2 人工反馈状态

- 用户已反馈 iPhone 17 Pro Max、iPhone 12 mini、VoiceOver、Dynamic Type、深色模式、小屏、iPad、本地模型加载和运行等均已人工自测 OK。
- 当前矩阵状态已根据用户人工反馈更新为 `Pass`。
- 具体 OS、App build、iPad 型号和 iPhone SE 专项机型记录仍建议在上架或 TestFlight 前补齐。
- 构建和静态扫描类验证记录见 `docs/V1_7_ManualTestRecords.md`。

## 记录要求

- 每次测试应使用 `docs/V1_7_ManualTestTemplate.md` 记录。
- 如果后续没有明确人工结果，不得标记为通过，应保持 `Pending` 或 `Blocked`。
- 发现问题后写入 `docs/V1_7_AccessibilityIssueBacklog.md`。
