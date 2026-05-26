# DestinyScope App Store 上架检查清单

## 1. App Icon

当前状态：

- `ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon` 已配置。
- `AppIcon.appiconset/Contents.json` 存在。
- AppIcon 目前只有占位 JSON 条目，未发现真实图片文件。

上架前待办：

- 提供原创或已授权的 1024x1024 PNG。
- 确认无透明背景、无 alpha 通道。
- 确认小尺寸下主体可识别。
- 接入 `AppIcon.appiconset` 并验证真机显示。

## 2. Launch Screen

当前状态：

- 工程使用 `INFOPLIST_KEY_UILaunchStoryboardName = LaunchScreen` 指向自定义启动页。
- 已新增 `DestinyScope/LaunchScreen.storyboard`。
- 启动页为静态布局：宣纸米白背景、居中 `DestinyScope`、副标题 `东方命理 · 自我探索`。
- 启动页不包含广告、复杂动画、网络图片或高风险营销文案。

上架前待办：

- 在 iPhone 和 iPad 真机或模拟器上检查启动页居中、文字可读、与首页视觉一致。
- 如后续增加 Logo，只使用原创或已授权素材。

## 3. 隐私政策

当前状态：

- App 内已有隐私政策页入口。
- 文案已覆盖无账号、无登录、出生信息本地处理、不上传、无服务端、无在线 AI、无广告追踪、无敏感权限等 V1 特性。

上架前待办：

- 准备 App Store Connect 需要填写的隐私政策 URL。
- 确认隐私政策 URL 内容与 App 内文案一致。
- 如未来加入联网、账号、AI、订阅、数据同步，需要同步更新。

## 4. 免责声明

当前状态：

- App 内已有免责声明页入口。
- 结果页已有短免责声明提示。
- 文案说明结果仅供娱乐、自我探索和传统文化学习参考。

上架前待办：

- 确认 App Store 元数据不宣传精准预测未来。
- 确认截图和描述不包含恐吓式、绝对化、医疗、投资、婚姻确定性承诺。

## 5. 无服务端说明

当前状态：

- V1 产品规划和隐私政策都说明无服务端。
- 当前阶段未新增网络请求或服务端依赖。

上架前待办：

- 在 App Store 审核备注中可说明：出生信息仅在设备端处理，V1 无账号、无服务端、无数据上传。

## 6. 无在线 AI 说明

当前状态：

- V1 使用本地模板式命理师解读。
- 隐私政策说明不接在线 AI。

上架前待办：

- App Store 元数据避免暗示真实 AI 在线推理。
- 如果使用“AI 命理师”措辞，应明确是本地模板式解读或改为“命理师解读”。

## 7. 数据本地处理说明

当前状态：

- 称骨算命数据来自 App Bundle 内置 CSV。
- 知识库来自 App Bundle 内置 JSON。
- 出生日期和时辰仅用于本地计算。

上架前待办：

- 在隐私政策 URL、App 内隐私页、审核备注中保持一致描述。
- 真机断网测试核心功能是否可用。

## 8. 版权素材检查

当前状态：

- 本阶段未生成图片、未接入第三方素材。
- 当前 AppIcon 缺少真实图片，因此暂不存在图标素材版权结论。

上架前待办：

- 确认 App Icon、Launch Logo、截图背景、任何图形纹样均为原创、已授权或系统资源。
- 不使用来源不明的网络图、未经授权字体、第三方图标或含版权争议的传统纹样素材。
- 本地知识库文案保持原创、简短、通俗，不复制来源不明的大段网络内容。

## 9. 构建 Warning 检查

当前状态：

- 近期构建出现既有 warning：

```text
ld: warning: search path '/Users/bytedance/repo/lark/DestinyScope/DestinyScope/Lib' not found
```

- 工程配置中 `LIBRARY_SEARCH_PATHS` 包含 `$(PROJECT_DIR)/DestinyScope/Lib`。

上架前待办：

- 在后续工程清理阶段确认 `DestinyScope/Lib` 是否应该存在。
- 如果不需要该路径，移除无效 search path。
- 上架前至少跑一次 Release 构建，确保无阻断性 warning 或 error。

## 10. TestFlight 前真机检查

待办：

- 真机安装后检查 App Icon 是否清晰。
- 检查 Launch Screen 是否与首页视觉一致，且在 iPhone/iPad 上居中显示。
- 检查浅色/深色模式可读性。
- 检查首页输入、结果页、知识库、关于页、隐私政策、免责声明完整链路。
- 断网启动并完成一次计算，确认无网络依赖。
- 检查 App 不请求定位、相机、相册、通讯录、麦克风等权限。
- 检查 App Store 截图和描述不包含绝对预测、恐吓式内容、医疗/投资/婚姻确定性承诺。
- 检查版本号、构建号、Bundle ID、签名 Team 是否正确。

## 11. 当前缺失资源汇总

- 真实 App Icon PNG。
- 可选 dark/tinted App Icon 资源。
- 配置后的 AccentColor 资产颜色值。
- Launch Screen 真机截图确认。
- App Store Connect 可访问的隐私政策 URL。
- 上架截图、描述、关键词、审核备注。
