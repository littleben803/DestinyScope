# DestinyScope App Icon 与 Launch Screen 接入计划

## 1. 当前检查结论

### App Icon

当前工程已在 `DestinyScope.xcodeproj/project.pbxproj` 中配置：

- `ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon`

当前 `DestinyScope/Assets.xcassets/AppIcon.appiconset/Contents.json` 只有 iOS 1024x1024 的 universal、dark、tinted 占位条目，未引用任何真实图片文件。

当前 `DestinyScope/Assets.xcassets/AppIcon.appiconset/` 目录内未发现 PNG 或其他图像文件。

结论：App Icon 名称已接入工程，但真实图标资源缺失，暂不满足上架资源要求。

### AccentColor

当前工程已配置：

- `ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor`

当前 `DestinyScope/Assets.xcassets/AccentColor.colorset/Contents.json` 只有 universal 占位条目，未配置具体颜色值。

结论：AccentColor 名称已接入工程，但颜色值尚未配置。阶段 9 的 SwiftUI `AppTheme` 已提供朱砂红、暗金等运行时颜色，后续可同步到资产目录。

### Launch Screen

当前工程配置：

- `GENERATE_INFOPLIST_FILE = YES`
- `INFOPLIST_KEY_UILaunchScreen_Generation = YES`

当前未发现自定义 `LaunchScreen.storyboard`、`LaunchScreen.swift`、`LaunchScreen.xib` 或同名资源文件。

结论：Launch Screen 当前使用 Xcode 自动生成方式，不是自定义 Launch Screen。V1 上架前建议改为可控的自定义 Launch Screen，但本阶段不修改工程配置。

### 已知构建 Warning

阶段 8、阶段 9、阶段 10 构建中出现过既有 warning：

```text
ld: warning: search path '/Users/bytedance/repo/lark/DestinyScope/DestinyScope/Lib' not found
```

对应工程配置中存在：

```text
LIBRARY_SEARCH_PATHS = (
  "$(inherited)",
  "$(PROJECT_DIR)/DestinyScope",
  "$(PROJECT_DIR)/DestinyScope/Lib",
);
```

结论：这是工程配置层面的旧 warning。本阶段仅记录，不修复。

## 2. 推荐 App Icon 设计方向

### 方案 A：命镜罗盘

视觉关键词：

- 圆形命镜。
- 罗盘刻度。
- 星点或细线天象。
- 朱砂红与暗金点缀。
- 宣纸或深墨底色。

优势：

- 与 DestinyScope 的“命理、自我探索、东方文化”定位匹配。
- 小尺寸下可通过圆形主体和中心高对比符号保持识别。
- 不依赖文字，适合 iOS 图标栅格。

### 方案 B：朱砂印章

视觉关键词：

- 方形或圆形朱砂印。
- 简化篆刻风格符号。
- 米白纸底。

优势：

- 东方文化感强。
- 视觉记忆点直接。

风险：

- 如果过度依赖文字或篆字，小尺寸识别会下降。
- 需要避免像单纯书法/印章工具，而不是命理 App。

### 方案 C：星盘八卦

视觉关键词：

- 八卦结构。
- 星盘线条。
- 暗金线框。
- 墨黑或宣纸背景。

优势：

- 命理识别强。
- 适合后续品牌延展。

风险：

- 细节过多时小尺寸容易糊。
- 需要避免宗教化、神秘化过强，保持传统文化学习定位。

## 3. 推荐首选方案

首选：命镜罗盘。

理由：

- 比纯印章更贴合 “DestinyScope” 中的 Scope 概念。
- 比复杂星盘八卦更容易在小图标中保持主体识别。
- 能同时表达传统命理、观察、自我探索和文化学习。

## 4. App Icon 资源规格

上架前至少需要：

- 1024x1024 PNG。
- 不要透明背景。
- 不要 alpha 通道。
- 中央主体要在小尺寸下可识别。
- 不要把文字作为主要识别元素。
- 避免使用未经授权的字体、纹样、插画、照片或第三方图标素材。
- 建议保留 light、dark、tinted 三套 iOS 18 风格资源规划，但可以先接入基础 1024x1024 图标。

建议交付文件：

```text
AppIcon-1024.png
AppIcon-Dark-1024.png
AppIcon-Tinted-1024.png
```

如果暂时只做一版，优先提供无透明背景的基础 `AppIcon-1024.png`。

## 5. Launch Screen 方案

推荐方案：

- 使用纯色或轻微渐变背景。
- 背景与首页视觉保持一致：宣纸米白、墨黑、朱砂红、暗金。
- 中央展示简化 Logo。
- Logo 下方展示 `DestinyScope` 文案。
- 不做广告页。
- 不做复杂动画。
- 不展示命理结果、营销承诺或“精准预测”等文案。

建议 Launch Screen 文案：

```text
DestinyScope
```

可选辅助文案：

```text
东方命理 · 自我探索
```

上架前需要人工确认辅助文案是否放入启动页；如果担心启动页信息过多，保留 App 名称即可。

## 6. 后续 Codex 接入步骤

后续阶段建议按小步执行：

1. 用户提供或确认原创 App Icon 设计稿。
2. 检查 PNG 是否为 1024x1024、无透明背景、无 alpha 通道。
3. 将图片放入 `DestinyScope/Assets.xcassets/AppIcon.appiconset/`。
4. 更新 `AppIcon.appiconset/Contents.json` 的 `filename` 字段。
5. 为 `AccentColor.colorset/Contents.json` 写入与 `AppTheme.Colors.cinnabar` 对齐的 light/dark 颜色。
6. 决定是否创建自定义 `LaunchScreen.storyboard` 或继续使用系统自动生成。
7. 如果创建自定义 Launch Screen，做最小工程配置接入。
8. 运行 Debug 和 Release 构建检查。
9. 在真机上检查图标、启动页、深色模式和小尺寸识别。

本阶段不执行以上接入动作，只保留资源计划和检查结论。
