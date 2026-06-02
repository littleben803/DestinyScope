# V1.8 User-Facing Copy Cleanup Report

更新日期：2026-06-02

## Scope

阶段 8 清理上线前用户可见文案。目标是把 App 内关于、设置、隐私政策、免责声明和开源许可页面从内部评审口径改为正式上线口径。

本阶段不修改业务逻辑、本地模型运行逻辑、设备评分逻辑、结果页结构、历史记录、工程配置、签名、Bundle ID、Version、Build、模型文件、framework、CSV、知识库或 RAG 数据。

## Swift Changes

Updated:

- `DestinyScope/UI/Settings/AboutView.swift`
- `DestinyScope/UI/Settings/SettingsView.swift`
- `DestinyScope/UI/Legal/OpenSourceLicensesView.swift`
- `DestinyScope/UI/Legal/PrivacyPolicyView.swift`
- `DestinyScope/Domain/Models/OpenSourceLicenseItem.swift`

Not changed:

- `DestinyScope/UI/Legal/DisclaimerView.swift`

## User-Facing Copy Result

- Removed user-facing draft wording from About and Settings open-source license entry.
- Replaced "local model experiment" wording with "local model text refining" wording in release-visible pages.
- Replaced "production candidate" wording in Privacy Policy with normal V1.8 feature wording.
- Open Source Licenses now shows normal license information fields:
  - Name
  - Source
  - License
  - Usage
  - Copyright / Notice
  - Notes
- Open Source Licenses no longer shows review or distribution status fields in the UI.

## Web And Store Copy

Updated:

- `docs/privacy/privacy.md`
- `docs/privacy/index.html`
- `docs/AppStoreMetadata.md`
- `docs/AppReviewNotes.md`
- `docs/ScreenshotPlan.md`
- `docs/V1_8_AppStoreConnectDraft.md`

Result:

- Public privacy page no longer uses production-candidate wording.
- App Store metadata and review notes now describe V1.8 local text refining as a regular on-device capability with fallback.
- Screenshot plan version label now uses `V1.8`.

## Remaining Notes

- `SettingsView` still contains Debug-only text under `#if DEBUG` for `LocalModelDebugView`; this is not visible in Release builds.
- Internal historical docs may still contain terms such as Debug, TestFlight, candidate or manual review because they record earlier stage decisions.
- App Store Connect, IPA export and final release checklist remain separate later-stage tasks.
