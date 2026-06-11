# V1.9 Privacy Nutrition Label Draft

更新日期：2026-06-11

本文件用于 App Store Connect 隐私问卷手工填写前复核。最终提交前需由账号持有人根据实际 Archive、依赖和 App Store Connect 问卷逐项人工确认。

## Recommended App Store Connect Answer

建议选择：

```text
Data Not Collected
```

理由：当前版本无账号、无登录、无服务端、无在线 AI、无分析 SDK、无广告追踪、无支付订阅、无 CloudKit / iCloud 同步；出生日期、出生时辰、性别、历史记录、知识库收藏、最近阅读、搜索历史和本地数据管理状态仅在设备端处理或保存，不上传给开发者或第三方。

## Local-Only Data Inventory

| Data | Purpose | Stored Locally | Uploaded | Linked to Identity |
| --- | --- | ---: | ---: | ---: |
| 出生日期 | 本地称骨计算和结果展示 | 可选，随历史记录保存 | No | No |
| 出生时辰 | 本地称骨计算和结果展示 | 可选，随历史记录保存 | No | No |
| 性别 | 本地命格详解 variant 选择和展示 | 可选，随历史记录保存 | No | No |
| 历史记录 | 本地回看过去结果 | Yes | No | No |
| 知识库收藏 | 本地展示收藏文章 | Yes | No | No |
| 最近阅读 | 本地展示最近阅读文章 | Yes | No | No |
| 知识库搜索历史 | 本地展示最近搜索关键词 | Yes | No | No |
| 本地数据管理状态 | 展示和执行本机数据清理 | Yes | No | No |
| 首次使用说明状态 | 控制是否再次展示引导 | Yes | No | No |

## Tracking

```text
No
```

当前版本不接入广告追踪、跨 App 追踪、分析 SDK 或第三方在线模型服务。

## Data Linked to User

```text
None
```

当前版本无账号、无登录、无用户标识体系，不把本地数据链接到用户身份。

## Data Used to Track User

```text
None
```

当前版本不使用 App 数据进行跨 App 或跨网站追踪。

## System Sharing

如果用户主动触发 iOS 系统分享面板，分享内容由用户选择的系统分享目标处理。八字命镜不会自动分享内容，也不会通过分享功能把数据上传给开发者服务。用户主动系统分享不视为 App 收集数据。

## Local Data Deletion

用户可在 App 内本地数据管理中清理历史记录、知识库收藏、最近阅读、搜索历史和首次使用说明状态等本机数据。删除仅影响当前设备，不影响 App Bundle 内置知识库、称骨 CSV、`life_weight_readings.json` 或本地计算规则。

## Required Reason API

`PrivacyInfo.xcprivacy` 建议继续声明并在最终 Archive 中确认：

- `NSPrivacyAccessedAPICategoryUserDefaults` / `CA92.1`
- `NSPrivacyAccessedAPICategoryFileTimestamp` / `C617.1`

## Manual Review Items

- 最终提交前需用户人工确认 App Store Connect 隐私问卷。
- 确认最终构建没有新增联网、账号、分析、支付、同步、广告追踪、第三方 SDK 或敏感权限。
- 确认 `PrivacyInfo.xcprivacy` 已进入 Archive / IPA。
- 如未来加入服务端、模型下载、账号、同步、分析 SDK、支付或第三方服务，本草案必须重新评估。
