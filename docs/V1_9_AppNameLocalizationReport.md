# V1.9 App Name Localization Report

日期：2026-06-11

## 目标

上线前阶段 1 将用户可见 App 名称和副标题统一 token 化，避免中文 UI、法律文案、上线材料中继续硬编码 `DestinyScope` / `八字命镜` / `八字命鏡`。

## 新增 Token

| Token | zh-Hans | zh-Hant | en |
| --- | --- | --- | --- |
| `app.name` | 八字命镜 | 八字命鏡 | DestinyScope |
| `app.subtitle` | 称骨命格与传统解读 | 稱骨命格與傳統解讀 | Life Weight & Destiny Insights |
| `app.brand.internal` | DestinyScope | DestinyScope | DestinyScope |

## 实现方式

- 项目当前没有 `Localizable.strings`、String Catalog 或现存 `InfoPlist.strings`。
- 运行时文案沿用现有 `DestinyScope/Resources/Localization/*.json` catalog。
- `LocalizationStore` 增加标准 token 自动替换：`{appName}`、`{appSubtitle}`、`{appBrandInternal}`。
- `HomeHeroCard` 的副标题改为读取 `app.subtitle`。
- `InfoPlist.strings` 和 `LaunchScreen.strings` 新增三语言本地化资源。
- 工程使用 generated Info.plist，因此只补充 `INFOPLIST_KEY_CFBundleDisplayName = "$(PRODUCT_NAME)"`，不修改 Bundle ID、签名、Team、Version 或 Build。

## InfoPlist.strings

已配置：

- `DestinyScope/zh-Hans.lproj/InfoPlist.strings`
- `DestinyScope/zh-Hant.lproj/InfoPlist.strings`
- `DestinyScope/en.lproj/InfoPlist.strings`

Release 产物中已确认三套 `InfoPlist.strings` 被复制进 `.app`，且值为：

- zh-Hans：`CFBundleDisplayName = 八字命镜`，`CFBundleName = 八字命镜`
- zh-Hant：`CFBundleDisplayName = 八字命鏡`，`CFBundleName = 八字命鏡`
- en：`CFBundleDisplayName = DestinyScope`，`CFBundleName = DestinyScope`

## 已替换页面和材料

- 首页：大标题继续走 `app.name`，Hero 副标题改走 `app.subtitle`。
- 关于页：标题卡继续走 `app.name`，实际显示随语言变化。
- 设置页：关于入口和无障碍提示改为 `{appName}`。
- 使用说明页：首屏说明文案改为 `{appName}`。
- 隐私政策页：中文/繁中文案中的 App 名称改为 `{appName}`。
- 免责声明页：中文/繁中文案中的 App 名称改为 `{appName}`。
- 开源许可页：中文/繁中文案中的 App 名称改为 `{appName}`。
- Launch Screen：新增三语言 `LaunchScreen.strings`，标题和副标题分别使用最终 App 名和副标题。
- `docs/privacy/index.html` 和 `docs/privacy/privacy.md`：中文材料统一为“八字命镜”，并保留“英文/内部品牌名：DestinyScope”说明。
- `docs/AppStoreMetadata.md`：已更新 App Name、Subtitle、English / Internal Brand、Traditional Chinese App Name、Traditional Chinese Subtitle。
- `docs/AppReviewNotes.md`：中文审核备注改为“八字命镜”，英文审核备注保留 `DestinyScope`。
- `docs/ScreenshotPlan.md`：标题更新为“八字命镜”口径。
- `docs/AppStoreChecklist.md`、`docs/CODEX_PROJECT_STATE.md`：补充本阶段状态。

## 保留的 DestinyScope

- `app.brand.internal` token：用于英文/内部品牌名。
- `app.name` 英文值：英文显示名仍为 `DestinyScope`。
- Swift 文件头注释、类型名、target/module 名、bundle path、Bundle ID、存储目录：属于技术内部标识。
- LaunchScreen storyboard Base fallback：实际三语言显示由 `LaunchScreen.strings` 覆盖。
- App Store / Review / Privacy 英文材料：英文品牌名按要求保留 `DestinyScope`。
- 隐私政策 URL 路径 `https://littleben803.github.io/DestinyScope/privacy/`：属于既有发布路径。
- `DestinyScope/Resources/Knowledge/*` 中的 `Curated DestinyScope supplement` / build source metadata：属于受保护知识库资源，本阶段不修改。

## 扫描结果

- `rg -n "DestinyScope|八字命镜|八字命鏡|称骨命格|稱骨命格" DestinyScope docs --glob '!docs/legal_evidence/**'` 已执行；命中被分类为用户可见文案、技术内部标识、历史文档、上线最终材料四类。
- `rg -n '"zh-Hans"\s*:\s*"[^"]*DestinyScope|"zh-Hant"\s*:\s*"[^"]*DestinyScope' DestinyScope/Resources/Localization` 仅命中 `app.brand.internal` 的简体/繁体值。
- `rg -n "DestinyScope" DestinyScope/UI DestinyScope/Resources/Localization docs/privacy docs/AppStoreMetadata.md docs/AppReviewNotes.md docs/ScreenshotPlan.md` 中，用户可见中文 UI 不再硬编码 `DestinyScope`；剩余命中为英文材料、内部品牌 token、Swift 文件头注释或路径/URL。

## 验证

- JSON 语法校验：通过。
- `.strings` 语法校验：通过。
- `git diff --check`：通过。
- Debug 构建：通过。
- Release 构建：通过。
- Release App Bundle 大模型 / framework 扫描：无输出。

## 未修改

- 未修改 `LifeWeightEngine`。
- 未修改 `LifeWeightRepository`。
- 未修改 `DataManager`。
- 未修改 CSV、`knowledge_articles.json`、`life_weight_readings.json`、`rag_chunks.json`。
- 未修改本地模型文件或 `llama.xcframework`。
- 未修改 Bundle ID、Signing、Team、Version、Build。
- 未新增网络、服务端、在线 AI、TestFlight 上传或 App Store Connect 记录。
