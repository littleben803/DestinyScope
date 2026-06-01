# DestinyScope V1.6 Data Privacy Plan

## 1. V1.6 新增本地数据类型规划

V1.6 可能新增以下本地数据：

| 数据类型 | 用途 | 是否包含敏感信息 | 初步存储建议 |
|---|---|---:|---|
| onboarding seen flag | 记录是否看过首次使用说明 | 否 | `UserDefaults` |
| local birth profiles | 保存常用出生日期和时辰，便于快速复用 | 是 | Application Support JSON |
| favorite knowledge article ids | 收藏知识库文章 | 否 | `UserDefaults` 或 JSON |
| recently viewed knowledge article ids | 最近阅读文章 | 否 | `UserDefaults` 或 JSON |
| pinned / favorite history record ids | 标记历史记录收藏 / 置顶 | 可能间接关联出生信息 | JSON 或扩展 HistoryRecord，需谨慎 |
| share template preference | 记录用户偏好的分享文案模板 | 否 | `UserDefaults` |
| local data management state | 辅助展示本地数据管理状态 | 视具体字段而定 | `UserDefaults` 或 JSON |

## 2. 隐私原则

V1.6 新增数据必须遵守：

- 只保存在设备端。
- 不上传。
- 不同步。
- 不登录。
- 不接 iCloud。
- 不接分析 SDK。
- 不接广告追踪。
- 用户可以删除。
- 文案不写过度承诺，例如“永远不会收集任何数据”。
- 推荐写法：“当前版本的这些数据仅保存在本设备。”

## 3. 每类数据的存储建议

### Onboarding Seen Flag

- 存储：`UserDefaults`。
- 字段示例：`hasSeenOnboarding`。
- 删除：本地数据管理页可重置，或保留默认行为。
- 风险：低。

### Local Birth Profiles

- 存储：Application Support JSON。
- 建议字段：
  - id
  - displayName
  - solarDate
  - hour
  - createdAt
  - updatedAt
- 删除：必须支持单条删除和全部清空。
- 风险：高于普通偏好，因为出生资料属于敏感个人信息。
- 文案要求：明确仅本地保存，不上传、不同步、不登录。

### Favorite Knowledge Article IDs

- 存储：`UserDefaults` 或 JSON。
- 内容：article id 列表。
- 删除：支持取消收藏和清空全部收藏。
- 风险：低。

### Recently Viewed Knowledge Article IDs

- 存储：`UserDefaults` 或 JSON。
- 内容：article id + viewedAt。
- 策略：限制数量，例如最近 20 条。
- 删除：支持清空最近阅读。
- 风险：低。

### Pinned / Favorite History Record IDs

- 存储方案 A：额外 JSON 保存 record id 集合。
- 存储方案 B：扩展 `HistoryRecord` 字段。
- 推荐：优先使用额外 JSON 保存 UI 状态，避免改变历史记录存储结构。
- 删除：历史记录删除时应同步清理 pin/favorite id。
- 风险：中，因为与历史查询记录关联。

### Share Template Preference

- 存储：`UserDefaults`。
- 内容：用户选择的分享模板类型。
- 风险：低。

### Local Data Management State

- 存储：按具体字段选择 `UserDefaults` 或 JSON。
- 原则：不保存完整模型输入输出，不保存不必要的个人信息。

## 4. 风险提示

- 出生资料属于敏感个人信息，需要明确本地保存。
- 如果保存多个出生资料，需要提供删除能力。
- 如果未来同步，需要重新更新隐私政策。
- 当前不做同步。
- 当前不做账号。
- 当前不做远程备份。
- 当前不做 iCloud。
- 本地模型润色结果默认不写入历史记录或分享模板。

## 5. 文案建议

常用出生资料：

> 当前版本的常用出生资料仅保存在本设备，用于快速填充首页输入。你可以随时删除这些资料。

知识库收藏：

> 收藏和最近阅读仅保存在本设备，用于帮助你继续阅读本地知识库内容。

历史记录：

> 历史记录仅保存在本设备，不上传、不同步，也不会用于在线服务。

本地数据管理：

> 你可以在本地数据管理中删除历史记录、收藏、最近阅读和常用出生资料。删除后仅影响本设备，且无法恢复。

