# V1.9 Final Submission Consistency Report

更新日期：2026-06-11

## 目标

V1.9 阶段 4 用于在创建 App Store Connect 记录前，复核 App Store Metadata、Review Notes、截图文案、隐私材料与当前 App 实际功能是否一致。本阶段不新增功能，不修改业务逻辑，不上传 TestFlight，不创建 App Store Connect 记录。

## 结论

本阶段发现并修复了“常用出生资料 / saved birth profiles”在最终上线材料中的不一致。

当前 App 实际情况为情况 B：

- 当前 App 不再包含常用出生资料用户功能。
- 首页没有“常用资料”卡片或“保存为常用资料”入口。
- 设置页没有常用出生资料管理入口。
- 本地数据管理没有常用出生资料单独清理项。
- App 内隐私政策和 GitHub Pages 隐私页没有常用出生资料说明。
- `BirthProfile` 是称骨计算与历史详情复用的内部领域模型，不代表常用出生资料功能。
- `saved_birth_profiles.json` 只作为旧版本遗留文件，在清空全部本地用户数据时静默删除。

## 修复内容

已从最终上线材料中删除：

- 常用出生资料
- 常用资料
- 复用常用资料
- saved birth profiles
- saved profiles
- Saved Birth Profiles

已改为描述当前真实存在的能力：

- 历史记录。
- 知识库收藏。
- 最近阅读。
- 知识库搜索历史。
- 本地数据管理。
- 结果页和历史详情页系统分享。
- 命格详解。
- 本地处理。

## 文件一致性

### App Store Metadata

状态：一致。

- Description 不再描述保存常用出生资料。
- 隐私与本地处理段落改为历史记录、知识库收藏、最近阅读和结果主要在设备端处理。
- Privacy Policy URL 仍为 `https://littleben803.github.io/DestinyScope/privacy/`。
- Support URL 仍为 `https://littleben803.github.io/DestinyScope/support/`。

### Review Notes

状态：一致。

- Core features 不再包含常用出生资料。
- Data processing 不再包含 saved birth profiles。
- Suggested review steps 不再要求打开常用出生资料。
- 测试步骤改为检查历史记录、本地回看和历史详情分享。

### Screenshot Plan

状态：一致。

- 第 5 张截图从“历史与常用资料”改为“历史记录”。
- 副文案改为“历史记录仅保存在设备端”。
- 画面建议改为历史记录列表或历史详情，不再要求展示常用出生资料。

### Privacy Nutrition Label Draft

状态：一致。

- Data inventory 删除常用出生资料。
- 出生日期、出生时辰、性别改为可选随历史记录保存。
- 本地数据删除说明改为历史记录、知识库收藏、最近阅读、搜索历史和首次使用说明状态。

### Privacy 文案

状态：一致，无需修改。

- `docs/privacy/privacy.md` 当前只覆盖历史记录、知识库收藏、最近阅读、搜索历史、本地数据管理和系统分享。
- `docs/privacy/index.html` 当前只覆盖历史记录、知识库收藏、最近阅读、搜索历史、本地数据管理和系统分享。
- 未发现常用出生资料相关说明。

## 扫描结果

### 常用出生资料材料扫描

命令：

```bash
rg -n "常用出生资料|保存常用|常用资料|birth profile|saved birth profile|Saved Birth Profiles|复用资料" docs/AppStoreMetadata.md docs/AppReviewNotes.md docs/ScreenshotPlan.md docs/V1_9_AppStoreSubmissionPackage.md docs/V1_9_ReviewNotesFinalDraft.md docs/V1_9_PrivacyNutritionLabelDraft.md docs/V1_9_ScreenshotCopyPlan.md docs/privacy || true
```

结果：无命中。

### 当前 App 代码扫描

命令：

```bash
rg -n "SavedBirthProfile|BirthProfile|常用出生|常用资料|保存为常用|saved birth profile" DestinyScope || true
```

结果：仅命中内部 `BirthProfile` 领域模型、`LifeWeightResult.birthProfile`、历史详情中构造轻量结果，以及 `LocalDataManagementService.deleteLegacyBirthProfileFileIfNeeded()`。未发现当前用户可见的常用出生资料入口、保存入口或管理入口。

### 高风险词扫描

命令：

```bash
rg -n "AI 算命|精准预测|改命|化解|避灾|必然发财|保证转运|疾病预测|寿命预测|投资收益确定|婚姻确定性|大师在线|付费改运" docs/AppStoreMetadata.md docs/AppReviewNotes.md docs/ScreenshotPlan.md docs/V1_9_AppStoreSubmissionPackage.md docs/V1_9_ReviewNotesFinalDraft.md docs/V1_9_ScreenshotCopyPlan.md docs/privacy DestinyScope/UI || true
```

结果：命中仅出现在“不要写 / 不出现 / 不提供”的 guardrail 或免责声明语境中。未发现营销文案、App Store Description 或截图文案中使用高风险承诺。

## 字段长度检查

| Field | Length | Limit | Result |
| --- | ---: | ---: | --- |
| zh-Hans App Name | 4 | 30 | Pass |
| zh-Hans Subtitle | 9 | 30 | Pass |
| zh-Hans Promotional Text | 53 | 170 | Pass |
| zh-Hans Keywords | 43 | 100 | Pass |
| zh-Hant App Name | 4 | 30 | Pass |
| zh-Hant Subtitle | 9 | 30 | Pass |
| zh-Hant Promotional Text | 53 | 170 | Pass |
| zh-Hant Keywords | 43 | 100 | Pass |
| en App Name | 12 | 30 | Pass |
| en Subtitle | 30 | 30 | Pass |
| en Promotional Text | 131 | 170 | Pass |
| en Keywords | 90 | 100 | Pass |

Description 正文长度充足，未发现异常格式。App Store Connect 最终粘贴时仍需人工确认字段限制和换行展示。

## Swift 修改与构建

- 是否修改 Swift：否。
- 是否需要 build：否。本阶段只修改 docs。
- Debug build：未运行。
- Release build：未运行。

## 风险与后续

- 当前最终 App Store Description 可以作为 App Store Connect 填写基础。
- 当前 Review Notes 可以作为 App Store Connect 填写基础。
- Privacy Nutrition Label 草案仍需账号持有人在 App Store Connect 问卷中人工确认。
- 截图仍需使用真实 App 页面实拍或导出，并人工确认尺寸、状态栏、无调试浮层和无真实出生信息。

## 建议

建议进入 App Store Connect 创建 App 记录准备阶段，但仍不建议上传构建或提交审核，直到完成：

- App Store Connect 字段人工粘贴与复核。
- Review contact 填写。
- 截图实际页面确认。
- 最终 Archive / IPA 包内容与 `PrivacyInfo.xcprivacy` 确认。
