# V1.9 Launch Screen Redesign Report

日期：2026-06-11

## 当前启动页问题

- 旧版 `LaunchScreen.storyboard` 使用居中文字栈。
- Base storyboard 中硬编码 `DestinyScope` 和 `东方命理 · 自我探索`。
- 视觉较接近普通文字占位页，东方命理 / 生肖 / 剪纸风格识别不足。
- 旧版仅有文字，没有中心视觉元素。

## 新设计方案

- 启动页改为纯静态图形方案。
- 背景恢复为浅宣纸色：`#F7EFDC`，与首页背景和原启动页背景保持一致。
- 中心图使用设计师提供的命镜罗盘 logo，整体视觉组略高于屏幕中心。
- 图形下方展示 App 名称和 Subtitle，不放长文案，不做广告式启动页，不展示结果、承诺或营销词。
- 浅色背景下红色剪纸图形更清晰，启动页到首页的视觉过渡更自然。

## 是否放文字

放文字。

内容：

- App 名称：使用 storyboard localization。
- Subtitle：使用 storyboard localization。
- App 名称字号更大，Subtitle 使用较小字号和暗金色。

## 是否本地化

- 启动页文字通过 `LaunchScreen.strings` 提供三语言本地化。
- `LaunchScreen.storyboard` 已移动到 `Base.lproj`，使用标准 Base storyboard + `.lproj/LaunchScreen.strings` 结构。
- Base storyboard 文案使用简体中文兜底，避免 localization 未命中时在中文主场景回退英文。
- 简体中文：八字命镜 / 称骨命格与传统解读
- 繁体中文：八字命鏡 / 稱骨命格與傳統解讀
- 英文：DestinyScope / Life Weight & Destiny Insights
- App 系统显示名本地化仍由阶段 1 的 `InfoPlist.strings` 提供。

## 中心图资源

- Asset 名称：`LaunchLogoCenter`
- 启动页运行时文件：`DestinyScope/LaunchLogoCenter.png`
- 工程内 image set：`DestinyScope/Assets.xcassets/LaunchLogoCenter.imageset/launch_logo_center.png`
- 来源：设计师提供的 `/Users/bytedance/Desktop/logo.png`
- 启动页运行时文件规格：512x512 PNG，有 alpha 通道，已将边缘连通白底转为透明。
- Image set 规格：1x 171x171、2x 342x342、3x 513x513 PNG。
- 当前图形为命镜罗盘风格 logo，Storyboard 继续使用语义明确的 `LaunchLogoCenter` 资源名。

## Auto Layout

- 使用根 view 直接承载 `UIImageView`、App 名称 `UILabel` 和 Subtitle `UILabel`，避免启动页静态渲染环境中 `UIStackView` 与图片尺寸推导不一致。
- Content Mode：`Aspect Fit`。
- Logo Center X 居中，Center Y 上移 56 pt。
- Logo 宽高固定 180 pt。
- App 名称位于 Logo 下方 18 pt，Subtitle 位于 App 名称下方 8 pt。
- App 名称 34 pt semibold，Subtitle 18 pt medium。

适配预期：

- iPhone 小屏：最小宽度保证图形不会过小。
- iPhone 大屏：相对宽度保证视觉中心稳定。
- iPad：最大宽度限制避免图形过大或变形。

## 运行时图片显示问题排查

- 磁盘资源目录当前保留 `DestinyScope/Assets.xcassets/LaunchLogoCenter.imageset`，并新增顶层 bundle PNG `DestinyScope/LaunchLogoCenter.png`。
- `LaunchScreen.storyboard` 当前引用 `LaunchLogoCenter`。
- `DestinyScope.xcodeproj/project.pbxproj` 使用 `PBXFileSystemSynchronizedRootGroup` 同步 `DestinyScope` 目录，asset catalog 子项不需要也不会逐个写入 pbx 文件。
- Debug / Release 构建均通过，`actool` 可以读取 `LaunchLogoCenter.imageset`，`Assets.car` 也包含该资源。
- `--wait-for-debugger` 实拍真实系统启动页时，asset catalog 图片未显示；把同一 `UIImageView` 临时改为 `AppIcon` 后也未显示，说明问题不在 `LaunchLogoCenter` 单个 image set。
- 将 logo 作为普通 bundle PNG 引用后，真实系统启动页可以显示图片。
- 结论：当前 iOS 26 模拟器的 SplashBoard 启动页生成路径对 asset catalog 图片渲染不稳定；最终采用同名顶层 PNG `LaunchLogoCenter.png` 作为启动页运行时图片来源，保留 image set 作为工程资源。

## 验证结果

- `sips` 检查 `LaunchLogoCenter.png`：512x512 PNG，`hasAlpha: yes`。
- `sips` 检查 image set：1x 171x171、2x 342x342、3x 513x513。
- `plutil -lint` 检查三语言 `LaunchScreen.strings`：通过。
- `node` JSON parser 检查 `LaunchLogoCenter.imageset/Contents.json`：通过。
- 启动页相关扫描：`LaunchScreen.storyboard` 和 `LaunchLogoCenter.imageset` 未命中 `草案`、`Debug`、`TestFlight`、`AI 算命`、`精准预测`、`改命`、`转运`；品牌文字由 `LaunchScreen.strings` 本地化覆盖。
- `assetutil` 检查 Release 产物：`Assets.car` 已包含 `LaunchLogoCenter` 的 1x/2x/3x renditions。
- `GeneratedAssetSymbols.swift` 检查：已生成 `launchLogoCenter`。
- `simctl launch --wait-for-debugger` 实拍启动页：`LaunchLogoCenter.png` 方案可以显示透明背景 logo。
- Release App 包检查：已包含 `en.lproj/LaunchScreen.strings`、`zh-Hans.lproj/LaunchScreen.strings`、`zh-Hant.lproj/LaunchScreen.strings`。
- Release App 包扫描：未发现 `llama`、`.gguf`、`.bin`、`.safetensors`、`.mlmodel`、`.mlmodelc`、`.xcframework`。
- `git diff --check`：通过。
- Debug 构建：通过，`xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Debug -destination 'generic/platform=iOS Simulator' build`。
- Release 构建：通过，`xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Release -destination 'generic/platform=iOS Simulator' build`。

## 后续可替换资源

- 如果后续提供更高清 logo 资源，需要同步替换 `LaunchLogoCenter.png` 和 `LaunchLogoCenter.imageset` 中的 1x/2x/3x PNG。
- 替换资源仍建议保持 PNG、无水印、无多余文字，并在浅宣纸色背景下边缘清晰。
