# DestinyScope App Review Notes 草案

更新日期：2026-05-26

## 1. 审核备注中文版本

```text
您好，DestinyScope V1 是一款完全 Native、本地运行的东方命理自我探索与传统文化学习 App。

测试账号：无需账号，无需登录。

核心功能：
1. 用户在首页选择出生日期和出生时辰。
2. App 使用内置称骨命理 CSV 数据在设备端完成本地计算。
3. 结果页展示称骨重量、命格诗文、年/月/日/时权重明细，以及总评、性格、事业、财运、关系五类本地模板式解读。
4. 知识库页面展示内置传统命理入门文章。
5. 关于页提供隐私政策和免责声明入口。

数据处理说明：
出生日期和出生时辰仅用于设备本地计算。V1 不创建账号，不登录，不上传出生信息，不接服务端，不接在线 AI，也不使用真实本地 LLM 推理。

网络说明：
V1 无服务端、无在线 AI、无网络请求。命理数据和知识库均来自 App Bundle 内置 CSV/JSON 资源。

权限说明：
V1 不申请定位、相机、相册、通讯录、麦克风等系统权限，不接入广告追踪、分析 SDK 或支付订阅。

免责声明：
App 内容基于传统命理文化和本地模板生成，仅供娱乐、自我探索和传统文化学习参考，不构成医疗、法律、财务、投资、婚恋或职业决策建议，也不提供健康、寿命、疾病、投资收益或婚姻结果的确定性判断。

建议测试步骤：
1. 打开 App。
2. 在首页选择出生日期和出生时辰。
3. 点击“查询”。
4. 查看结果页中的称骨结果、命格诗文、权重明细和五类解读。
5. 打开“知识库”，进入任意文章详情。
6. 打开“关于”，查看关于页、隐私政策和免责声明。
```

## 2. App Review Notes English Version

```text
Hello, DestinyScope V1 is a fully native, local-first iOS app for Eastern metaphysics-inspired self-exploration and traditional culture learning.

Test account: No account is required. No login is required.

Core features:
1. The user selects a birth date and birth hour on the Home screen.
2. The app uses bundled local CSV data to calculate a traditional life-weight result on device.
3. The Result screen shows the total weight, traditional poem, year/month/day/hour breakdown, and five local template-based interpretation sections: summary, personality, career, wealth, and relationships.
4. The Knowledge tab shows bundled introductory articles about traditional metaphysics concepts.
5. The About tab provides access to the privacy policy and disclaimer.

Data processing:
Birth date and birth hour are used only for on-device calculation. V1 does not create accounts, does not require login, does not upload birth information, does not use a backend server, does not use online AI, and does not run a real local LLM.

Network:
V1 has no backend server, no online AI, and no network requests. The fortune data and knowledge articles are bundled in the app as local CSV/JSON resources.

Permissions:
V1 does not request Location, Camera, Photos, Contacts, Microphone, or other sensitive permissions. It does not include ad tracking, analytics SDKs, or paid subscriptions.

Disclaimer:
The content is generated from traditional culture references and local templates. It is for entertainment, self-exploration, and traditional culture learning only. It is not medical, legal, financial, investment, relationship, or career advice. It does not provide deterministic predictions about health, lifespan, illness, investment returns, or relationship outcomes.

Suggested review steps:
1. Open the app.
2. Select a birth date and birth hour on the Home screen.
3. Tap “查询”.
4. Review the Result screen, including the poem, breakdown, and five interpretation sections.
5. Open the Knowledge tab and view any article detail page.
6. Open the About tab and review the About page, Privacy Policy, and Disclaimer.
```

## 3. 测试账号说明

- 测试账号：无需账号。
- 登录：无需登录。
- 付费：V1 不包含付费订阅或内购。
- 网络：V1 不需要网络即可完成核心功能。

## 4. 审核员重点测试路径

1. 打开 App，确认启动页和首页可以正常显示。
2. 在首页选择出生日期。
3. 在首页选择出生时辰。
4. 点击“查询”。
5. 查看结果页是否展示命格标题、农历生日、总重量、诗文、权重明细和五类解读。
6. 返回并打开“知识库”。
7. 点击任意知识库文章，检查正文、标签、source/version。
8. 打开“关于”。
9. 打开“隐私政策”。
10. 打开“免责声明”。

## 5. 审核备注使用注意

- 不要声称 App 可以精准预测未来。
- 不要声称 App 可以改命、化解、避灾。
- 不要声称会产生必然发财、必然婚姻结果、健康寿命判断。
- 不要声称 V1 使用真实在线 AI。
- 如需提到解读能力，使用“local template-based interpretation”或“本地模板式解读”。
