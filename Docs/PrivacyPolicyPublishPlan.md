# DestinyScope Privacy Policy 发布计划

更新日期：2026-05-27

## 1. 仓库地址

```text
https://github.com/littleben803/DestinyScope.git
```

## 2. 本阶段已准备文件

- `docs/privacy/index.html`
- `docs/privacy/privacy.md`
- `docs/README.md`

`index.html` 是可直接部署到 GitHub Pages 的静态页面，不依赖外部 JS、外部 CSS CDN、远程字体、npm、Jekyll 或其他静态站点生成器。

## 3. 推荐 GitHub Pages 设置

在 GitHub 仓库中进入：

1. Settings
2. Pages
3. Build and deployment
4. Source: Deploy from a branch
5. Branch: main
6. Folder: /docs
7. Save

## 4. 发布后预期 URL

```text
https://littleben803.github.io/DestinyScope/privacy/
```

该 URL 已同步写入 `Docs/AppStoreMetadata.md`，用于替代原先的隐私政策 URL 占位。

## 5. 发布后人工确认事项

- 用浏览器打开 `https://littleben803.github.io/DestinyScope/privacy/`。
- 确认页面无 404。
- 确认手机端可读。
- 确认页面没有加载外部 JS、CSS、字体或追踪资源。
- 确认内容与 App 内隐私政策一致。
- 将 URL 填入 App Store Connect 的 Privacy Policy URL。
- 确认 `Docs/AppStoreMetadata.md` 中的隐私政策 URL 已替换为真实 URL。

## 6. 自定义域名

如果后续 GitHub Pages 使用自定义域名，可以将 App Store Connect 中的 Privacy Policy URL 替换为自定义域名下的隐私政策地址，并同步更新：

- `Docs/AppStoreMetadata.md`
- `Docs/AppStoreChecklist.md`
- App Store Connect Privacy Policy URL 字段

## 7. 内容边界

当前隐私政策页面覆盖 DestinyScope V1：

- 无账号、无需登录。
- 出生日期和出生时辰仅用于设备本地计算。
- 不上传出生信息。
- 不接服务端。
- 不接在线 AI。
- 不使用真实本地 LLM 推理。
- 不使用定位、相机、相册、通讯录、麦克风等敏感权限。
- 不接入广告追踪。
- 不接入分析 SDK。
- 不包含付费订阅。
- 本地命理数据来自 App Bundle 内置 CSV。
- 本地知识库来自 App Bundle 内置 JSON。
- 如果未来新增联网、账号、AI、订阅或数据同步，会更新隐私政策。
- 联系方式：littleben803@gmail.com。
