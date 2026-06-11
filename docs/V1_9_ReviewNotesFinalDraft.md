# V1.9 Review Notes Final Draft

更新日期：2026-06-11

本文件用于 App Review Notes 手工填写前复核。当前阶段只准备文本，不上传 TestFlight，不创建 App Store Connect 记录，不修改代码、签名或版本号。

## 中文版本

```text
您好，八字命镜是一款完全 Native、本地优先的传统文化、自我探索和娱乐参考 App。英文 / 内部品牌名为 DestinyScope。

测试账号：无需账号，无需登录。

核心功能：
1. 用户在首页选择出生日期、出生时辰和性别。
2. App 使用内置称骨 CSV 数据、本地规则和 life_weight_readings.json 在设备端完成计算与展示。
3. 结果页展示称骨结果、命格、称骨诗、年/月/日/时权重明细和命格详解。
4. 知识库页面展示内置传统文化与命理基础文章。
5. 历史记录、知识库收藏和最近阅读仅保存在本地设备，方便用户回看和继续阅读。
6. 设置 / 关于页面提供隐私政策、免责声明、开源许可和本地数据管理入口。

数据处理说明：
出生日期、出生时辰和性别仅用于本地计算和本地展示。八字命镜不创建账号，不要求登录，不接服务端，不使用在线 AI，不接入广告追踪，不提供订阅。历史记录、知识库收藏和最近阅读仅本地保存，用户可在本地数据管理中删除。

内容来源说明：
称骨和命格解读来自 App Bundle 内置本地规则、CSV 数据和 life_weight_readings.json。本版本当前已移除结果页 AI 润色展示。若最终构建包仍包含本地模型文件，该文件也不作为结果页展示入口；后续版本可能仅用于设备端文本润色，不用于生成新的命理结论。

App 内隐私政策路径：关于/设置 Tab -> 隐私与安全 -> 隐私政策。

网络说明：
当前版本无服务端，核心功能不依赖网络。命理数据和知识库来自 App Bundle 内置资源。

权限说明：
当前版本不申请定位、相机、相册、通讯录、麦克风等敏感系统权限，不接入广告追踪、分析 SDK、支付订阅、CloudKit 或 iCloud 同步。

免责声明：
App 内容仅供娱乐、自我探索和传统文化学习参考，不提供医疗、法律、财务、投资、婚恋、职业等专业建议；不提供改命、化解、避灾、转运承诺；也不应作为重大现实决策依据。

建议测试步骤：
1. 打开 App。
2. 在首页选择出生日期、出生时辰和性别。
3. 点击“查询”。
4. 查看结果页中的称骨结果、命格、称骨诗、权重明细和命格详解。
5. 打开“知识库”，进入任意文章详情。
6. 打开历史记录，确认本地回看和历史详情分享体验。
7. 打开“关于/设置”，查看隐私政策、免责声明、开源许可和本地数据管理。
```

## English Version

```text
Hello, 八字命镜 is a fully native, local-first iOS app for traditional culture learning, self-exploration, and entertainment reference. The English / internal brand name is DestinyScope.

Test account: No account is required. No login is required.

Core features:
1. The user selects a birth date, birth hour, and gender on the Home screen.
2. The app uses bundled local CSV data, local rules, and life_weight_readings.json to calculate and display results on device.
3. The Result screen shows a life-weight result, destiny category, traditional poem, year/month/day/hour breakdown, and detailed local reading.
4. The Knowledge tab shows bundled introductory articles about traditional culture and related concepts.
5. History records, knowledge favorites, and recent reads are stored only on the local device for review and continued reading.
6. The Settings / About area provides Privacy Policy, Disclaimer, Open Source Licenses, and local data management.

Data processing:
Birth date, birth hour, and gender are used only for on-device calculation and local display. The app does not create accounts, does not require login, does not use a backend server, does not use online AI, does not include ad tracking, and does not provide subscriptions. History records, knowledge favorites, and recent reads are stored locally only, and users can delete them in local data management.

Content source:
The life-weight result and readings come from bundled local rules, CSV data, and life_weight_readings.json. The current version has removed AI-polished result display from the Result screen. If the final build still contains a local model file, it is not used as a Result screen display entry point; a future version may use it only for on-device text polishing, not for creating new destiny conclusions.

In-app Privacy Policy path: About/Settings tab -> Privacy and Safety -> Privacy Policy.

Network:
The current version has no backend server. Core features do not depend on network access. Life-weight data and knowledge resources are bundled in the app.

Permissions:
The current version does not request Location, Camera, Photos, Contacts, Microphone, or other sensitive permissions. It does not include ad tracking, analytics SDKs, paid subscriptions, CloudKit, or iCloud sync.

Disclaimer:
The app content is for entertainment, self-exploration, and traditional culture learning only. It is not medical, legal, financial, investment, relationship, career, or other professional advice. It does not provide promises about changing fate, remedies, disaster avoidance, or guaranteed luck, and it should not be used as the basis for major real-world decisions.

Suggested review steps:
1. Open the app.
2. Select a birth date, birth hour, and gender on the Home screen.
3. Tap “查询”.
4. Review the Result screen, including the life-weight result, destiny category, poem, breakdown, and detailed reading.
5. Open the Knowledge tab and view any article detail page.
6. Open History to confirm local review and history detail sharing.
7. Open Settings / About and review Privacy Policy, Disclaimer, Open Source Licenses, and local data management.
```

## Manual Submit Checklist

- 确认最终构建的实际功能仍为无账号、无登录、无服务端、无在线 AI、无广告追踪、无订阅。
- 确认结果页没有恢复 AI 润色展示入口。
- 确认 `PrivacyInfo.xcprivacy` 已进入最终 Archive / IPA。
- 确认 App Store Connect Review contact 使用真实可联系信息。
