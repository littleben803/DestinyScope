# DestinyScope App Review Notes

更新日期：2026-06-08

## 中文版本

```text
您好，DestinyScope 是一款完全 Native、本地优先的传统命理文化与自我探索 App。

测试账号：无需账号，无需登录。

核心功能：
1. 用户在首页选择出生日期和出生时辰。
2. App 使用内置称骨命理 CSV 数据在设备端完成本地计算。
3. 结果页展示称骨重量、命格诗文、年/月/日/时权重明细和命格详解。
4. 知识库页面展示内置传统文化与命理基础文章。
5. 关于页提供隐私政策、免责声明和开源许可入口。

数据处理说明：
出生日期和出生时辰仅用于设备端本地计算。DestinyScope 不创建账号，不登录，不上传出生信息，不上传命理结果，不上传历史记录，不接服务端。

网络说明：
当前版本无服务端，核心功能不依赖网络。命理数据和知识库来自 App Bundle 内置资源。

权限说明：
当前版本不申请定位、相机、相册、通讯录、麦克风等敏感系统权限，不接入广告追踪、分析 SDK、支付订阅、CloudKit 或 iCloud 同步。

免责声明：
App 内容基于传统命理文化和本地模板生成，仅供娱乐、自我探索和传统文化学习参考，不构成医疗、法律、财务、投资、婚恋或职业决策建议，也不提供健康、寿命、疾病、投资收益、婚姻结果、改命、化解、避灾或转运承诺。

建议测试步骤：
1. 打开 App。
2. 在首页选择出生日期和出生时辰。
3. 点击“查询”。
4. 查看结果页中的称骨结果、命格诗文、权重明细和命格详解。
5. 打开“知识库”，进入任意文章详情。
6. 打开“关于”，查看隐私政策、免责声明和开源许可。
```

## English Version

```text
Hello, DestinyScope is a fully native, local-first iOS app for traditional culture learning and self-exploration.

Test account: No account is required. No login is required.

Core features:
1. The user selects a birth date and birth hour on the Home screen.
2. The app uses bundled local CSV data to calculate a traditional life-weight result on device.
3. The Result screen shows the total weight, traditional poem, year/month/day/hour breakdown, and a detailed local reading.
4. The Knowledge tab shows bundled introductory articles about traditional culture and metaphysics concepts.
5. The About page provides access to Privacy Policy, Disclaimer, and Open Source Licenses.

Data processing:
Birth date and birth hour are used only for on-device calculation. DestinyScope does not create accounts, does not require login, does not upload birth information, fortune results, or history records, and does not use a backend server.

Network:
The current version has no backend server. Core features do not depend on network access. Fortune data and knowledge resources are bundled in the app.

Permissions:
The current version does not request Location, Camera, Photos, Contacts, Microphone, or other sensitive permissions. It does not include ad tracking, analytics SDKs, paid subscriptions, CloudKit, or iCloud sync.

Disclaimer:
The content is based on traditional culture references and local templates. It is for entertainment, self-exploration, and traditional culture learning only. It is not medical, legal, financial, investment, relationship, or career advice. It does not provide deterministic predictions or promises about health, lifespan, illness, investment returns, relationship outcomes, fate changes, remedy, disaster avoidance, or guaranteed luck.

Suggested review steps:
1. Open the app.
2. Select a birth date and birth hour on the Home screen.
3. Tap “查询”.
4. Review the Result screen, including the poem, breakdown, and detailed reading.
5. Open the Knowledge tab and view any article detail page.
6. Open the About page and review Privacy Policy, Disclaimer, and Open Source Licenses.
```

## Manual Notes

- 不需要测试账号。
- 上线前需要确认 `PrivacyInfo.xcprivacy` 已进入最终包。
