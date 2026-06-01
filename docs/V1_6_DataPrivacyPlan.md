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

- 状态：已实现。
- 存储：Application Support JSON。
- 文件：`Application Support/DestinyScope/saved_birth_profiles.json`。
- 字段：
  - id
  - displayName
  - birthDate
  - hour
  - createdAt
  - updatedAt
- 数量限制：最多保留 20 条，按更新时间倒序。
- 删除：支持单条删除和全部清空。
- 首页行为：选择常用出生资料只填入出生日期和时辰，不自动查询、不重新计算、不自动保存历史。
- 风险：高于普通偏好，因为出生资料属于敏感个人信息。
- 文案要求：明确仅本地保存，不上传、不同步、不登录。
- 当前隐私说明：App 内隐私政策和 GitHub Pages 隐私页已补充常用出生资料仅本地保存、不上传、不同步、可删除说明。

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

### Result Text Copy / Share

- 状态：已实现纯文本复制和系统分享。
- 触发方式：用户在结果页手动点击“复制摘要”或“分享摘要”。
- 分享内容：App 名称、命格标题、总重量、称骨诗文、简要解读、行动建议和安全提示。
- 默认排除：完整公历出生日期、完整农历生日、具体出生时辰、历史记录、常用出生资料显示名、本地模型润色结果。
- 存储：不保存分享记录，不写入历史记录，不保存分享文本。
- 网络：不上传分享内容，不请求网络，不接服务端。
- 剪贴板：仅在用户点击复制时写入，不读取剪贴板。
- 风险：中，因为用户可能主动分享到其他 App；因此默认摘要应尽量减少出生信息细节，并包含安全提示。

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
