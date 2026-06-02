# V1.8 Privacy Nutrition Label Draft

更新日期：2026-06-02

## Recommended App Store Connect Answer

建议选择：

```text
Data Not Collected
```

理由：当前版本无账号、无登录、无服务端、无在线 AI、无分析 SDK、无广告追踪、无支付订阅、无 CloudKit / iCloud 同步；出生信息、历史记录、常用出生资料、知识库收藏、最近阅读、本地模型输入和输出均在设备端处理，不上传给开发者或第三方。

## Local-Only Data Inventory

| Data | Purpose | Stored Locally | Uploaded |
|---|---|---:|---:|
| Birth date and birth hour | Local life-weight calculation | Optional via history/profile | No |
| Lightweight history record | Local review of past result | Yes | No |
| Saved birth profile | Quick input reuse | Yes | No |
| Knowledge favorites | Local favorites list | Yes | No |
| Recent reads | Local recent articles | Yes | No |
| Onboarding state | Hide completed onboarding | Yes | No |
| Local model input | Refine existing template text | Temporary/on device | No |
| Local model output | Display refined text | Not saved to history by default | No |

## Tracking

```text
No
```

当前版本不接入广告追踪、跨 App 追踪、分析 SDK 或第三方在线模型服务。

## User-Linked Data

```text
None
```

当前版本无账号、无登录、无用户标识体系。

## System Sharing

如果用户主动触发 iOS 系统分享面板，分享内容由用户选择的系统分享目标处理。DestinyScope 不会自动分享内容，也不会通过分享功能把数据上传给开发者服务。

## Required Reason API

`PrivacyInfo.xcprivacy` 建议声明：

- `NSPrivacyAccessedAPICategoryUserDefaults` / `CA92.1`
- `NSPrivacyAccessedAPICategoryFileTimestamp` / `C617.1`

## Manual Review Items

- 在 App Store Connect 最终填写前，确认没有新增联网、账号、分析、支付、同步或第三方 SDK。
- 确认 `PrivacyInfo.xcprivacy` 已进入 Archive 包。
- 如未来启用服务端、模型下载、账号、同步、分析 SDK、支付或第三方服务，本草案必须重新评估。
