# DestinyScope 当前项目状态

## 当前方向

DestinyScope 已回退到本地优先、确定性算法和模板解释路线。

当前产品形态：

- Native iOS / SwiftUI
- 无账号
- 无登录
- 无服务端
- 无在线生成服务
- 生辰八字查询
- 称骨结果
- 称骨诗
- 权重明细
- 命格详解使用本地结构化文案
- 本地知识库读取与搜索
- 本地历史记录

当前明确不做：

- 取名功能
- 开放聊天
- 生成式润色
- 生成式问答
- 投资、疾病、婚姻重大决策、精准预测或灾祸化解
- 模板结果之外的新命理结论
- 服务端、登录、同步、分析追踪、广告、订阅或敏感权限

## 上线前阶段状态

### V1.9 阶段 1：App 名称多语言 token 化

- 当前目标：用户可见 App 主名称统一走 `app.name`，App 副标题统一走 `app.subtitle`，英文/内部品牌名统一走 `app.brand.internal`。
- 简体中文主名称：八字命镜。
- 繁体中文主名称：八字命鏡。
- 英文/内部品牌名：DestinyScope。
- 本阶段不修改 Bundle ID、签名、Team、Version / Build、称骨计算、本地数据或知识库资源。

### V1.9 阶段 2：启动页重新设计

- 启动页已按“八字命镜”上线口径改为静态图形方案。
- `LaunchScreen.storyboard` 位于 `Base.lproj`，显示本地化 App 名称和 Subtitle，三语言文案由 `LaunchScreen.strings` 提供。
- 中心视觉使用设计师提供的命镜罗盘 logo `LaunchLogoCenter`，启动页运行时引用顶层 bundle PNG `LaunchLogoCenter.png`，并保留同名 image set 作为工程内设计资源；品牌组整体略高于屏幕中心。
- 背景使用浅宣纸色，与首页背景和原启动页背景保持一致。
- 本阶段不修改首页业务逻辑、称骨计算、本地模型、Bundle ID、签名、Team、Version / Build。

### 上线前静态页面与 App Store URL

- `docs/privacy/index.html` 和 `docs/privacy/privacy.md` 已同步 App 内 `legal.json` 当前隐私口径，覆盖知识库搜索历史、本地数据管理、网络与服务端、系统分享和本地资源说明。
- App Store Connect Privacy Policy URL 规划为 `https://littleben803.github.io/DestinyScope/privacy/`。
- App Store Connect Support URL 规划为 `https://littleben803.github.io/DestinyScope/support/`，对应静态页面 `docs/support/index.html`。
- App Review Notes 已补充 App 内隐私政策路径：关于/设置 Tab -> 隐私与安全 -> 隐私政策。
- GitHub Pages 部署和 App Store Connect 字段填写仍由人工后续执行。

## 已完成清理

### 阶段一

- 保留现有内置库。
- 基于清洗产物生成新的本地知识库资源。
- 生成知识文章、知识片段、manifest、SQLite 和构建报告。

### 阶段二

- 补充五行、天干、地支基础知识条目。
- 正式知识文章和知识片段扩展到 306 条。
- 清理文章、片段和 SQLite 中的冗余使用边界与重复问题文本。

### 阶段三

- 回退正式入口中的生成式解释链路。
- 移除首页、结果页和 Tab 中新增的生成式入口。
- 保留纯本地知识库读取与搜索能力。

### 阶段四

- 移除运行时生成链路资源和依赖。
- 移除旧文本生成实验封装、调试入口和剩余用户可见文案。
- App Bundle 不再包含大型生成资源目录或相关 framework。
- 工程配置不再链接或嵌入相关 framework。

## 当前保留资源

- `DestinyScope/Resources/Knowledge/destiny_knowledge_articles.json`
- `DestinyScope/Resources/Knowledge/destiny_rag_chunks.json`
- Knowledge 目录当前只保留运行时需要的正式 articles / chunks JSON。
- SQLite、manifest、reserved naming 属于离线构建/审计产物，不再放入 App Resources。
- `DestinyScope/Resources/Data/life_weight_readings.json`
- 称骨、八字、权重计算相关本地数据和代码

## 当前验证要求

涉及 Swift 或工程配置修改时，需要运行：

```bash
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Debug -destination 'generic/platform=iOS Simulator' build
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Release -destination 'generic/platform=iOS Simulator' build
```

结束前需要检查：

- Debug build 通过
- Release build 通过
- App Bundle 不包含已移除的大型生成资源目录
- App Bundle 不包含已移除的 framework 目录
- App 源码、工程配置和本地化资源不存在已移除能力的入口或文案
- `git status` 中无非预期文件
