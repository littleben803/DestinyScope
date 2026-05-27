# DestinyScope V1.1 知识库扩充执行计划

更新日期：2026-05-27

本文件用于规划 V1.1 阶段 4B 的 `knowledge_articles.json` 扩充。当前阶段 4A 只做资料来源和文章规划，不修改 App 资源文件。

## 1. 本阶段边界

本阶段只准备文档：

- `docs/knowledge_sources/sources.md`
- `docs/knowledge_sources/raw_notes.md`
- `docs/V1_1_KnowledgeExpansionPlan.md`

本阶段不修改：

- Swift 代码。
- `DestinyScope/Resources/Knowledge/knowledge_articles.json`。
- CSV 文件。
- Xcode 工程配置。
- App 资源。
- 依赖。

JSON 扩充留到 V1.1 阶段 4B。

## 2. 来源使用策略

适合直接作为 reference 的来源：

- 中国哲学书电子化计划 CText：https://ctext.org/zhs
- CText《周易》：https://ctext.org/book-of-changes/zhs
- 维基文库《周易》：https://zh.wikisource.org/wiki/周易
- 维基文库《梅花易数》：https://zh.wikisource.org/zh-hans/梅花易數
- CCTV：生肖的源流、排列与信仰：https://www.cctv.com/geography/news/20021202/25.html
- 中国文艺网：十二生肖与时辰的传说：https://www.cflac.org.cn/wywzt/2014/2014chunjie/chunjie/201401/t20140124_241521.html
- CText 五行生克相关古籍片段：https://ctext.org/wiki.pl?chapter=120081&if=gb&remap=gb

只能谨慎参考的来源：

- 五行百科资料：https://zh.wikipedia.org/wiki/五行
- 民间称骨资料站、称骨 PDF、Scribd 文档、普通算命网站。

谨慎来源使用限制：

- 只用于概念核对或了解流传形态。
- 不直接复制正文。
- 不采用强预测、恐吓、改命、化解、避灾类文案。
- 不作为核心权威来源。

## 3. 计划文章列表

V1.1 阶段 4B 建议扩充为 29 篇文章。当前已有主题可复用并升级 version，不重复创建同名内容。

| 序号 | id 建议 | category | title | source 建议 | 备注 |
| --- | --- | --- | --- | --- | --- |
| 1 | life_weight_intro | 称骨算命 | 称骨算命是什么 | 谨慎参考民间称骨资料；DestinyScope 原创整理 | 当前已有，可检查补强 |
| 2 | life_weight_calculation_method | 称骨算命 | 称骨算命的计算方式 | 谨慎参考民间称骨资料；DestinyScope 原创整理 | 解释年月日时权重与总重量 |
| 3 | life_weight_rational_view | 使用边界 | 称骨结果如何理性看待 | DestinyScope 原创整理 | 强调参考性 |
| 4 | life_weight_poem_interpretation | 称骨算命 | 称骨诗文为什么需要解释 | DestinyScope 原创整理 | 解释诗文语境和现代转译 |
| 5 | lunar_calendar_basics | 农历时辰 | 农历基础 | CText；机构类民俗资料；DestinyScope 原创整理 | 只做入门说明 |
| 6 | twelve_hours | 农历时辰 | 十二时辰 | 中国文艺网；CCTV；DestinyScope 原创整理 | 解释时辰与地支 |
| 7 | heavenly_stems_basics | 天干地支 | 天干基础 | CText；DestinyScope 原创整理 | 解释十天干 |
| 8 | earthly_branches_basics | 天干地支 | 地支基础 | CText；生肖民俗资料；DestinyScope 原创整理 | 解释十二地支 |
| 9 | stems_branches_combination | 天干地支 | 天干地支组合 | CText；DestinyScope 原创整理 | 解释组合思路 |
| 10 | sexagenary_cycle_intro | 天干地支 | 六十甲子入门 | CText；DestinyScope 原创整理 | 解释六十循环 |
| 11 | zodiac_basics | 生肖 | 十二生肖基础 | CCTV；中国文艺网；DestinyScope 原创整理 | 当前已有，可补强 |
| 12 | zodiac_earthly_branches | 生肖 | 生肖与地支的关系 | CCTV；中国文艺网；DestinyScope 原创整理 | 民俗和时间表达 |
| 13 | five_elements_basics | 五行 | 五行基础 | 五行百科资料；CText；DestinyScope 原创整理 | 当前已有，可补强 |
| 14 | five_elements_generating | 五行 | 五行相生 | CText 五行生克片段；五行百科资料 | 解释支持与转化 |
| 15 | five_elements_overcoming | 五行 | 五行相克 | CText 五行生克片段；五行百科资料 | 解释制约与平衡 |
| 16 | five_elements_self_observation | 五行 | 五行与自我观察 | DestinyScope 原创整理 | 转为现代自我观察 |
| 17 | bagua_basics | 八卦周易 | 八卦基础 | CText《周易》；维基文库《周易》 | 八卦入门 |
| 18 | qian_hexagram_self_strengthening | 八卦周易 | 乾卦：刚健与自强 | CText《周易》；维基文库《周易》 | 象征角度，不做断语 |
| 19 | kun_hexagram_receptive | 八卦周易 | 坤卦：承载与包容 | CText《周易》；维基文库《周易》 | 象征角度 |
| 20 | zhen_hexagram_action | 八卦周易 | 震卦：行动与启动 | CText《周易》；维基文库《周易》 | 象征角度 |
| 21 | xun_hexagram_communication | 八卦周易 | 巽卦：入微与沟通 | CText《周易》；维基文库《周易》 | 象征角度 |
| 22 | kan_hexagram_risk | 八卦周易 | 坎卦：风险与深思 | CText《周易》；维基文库《周易》 | 避免恐吓 |
| 23 | li_hexagram_expression | 八卦周易 | 离卦：光明与表达 | CText《周易》；维基文库《周易》 | 象征角度 |
| 24 | gen_hexagram_boundary | 八卦周易 | 艮卦：停止与边界 | CText《周易》；维基文库《周易》 | 象征角度 |
| 25 | dui_hexagram_exchange | 八卦周易 | 兑卦：悦纳与交流 | CText《周易》；维基文库《周易》 | 象征角度 |
| 26 | zhouyi_intro | 八卦周易 | 周易入门 | CText《周易》；维基文库《周易》 | 介绍文化背景 |
| 27 | meihua_yishu_intro | 梅花易数 | 梅花易数入门 | 维基文库《梅花易数》 | 只介绍，不实现起卦 |
| 28 | metaphysics_self_exploration | 使用边界 | 命理与自我探索 | DestinyScope 原创整理 | 连接产品定位 |
| 29 | rational_use_boundary | 使用边界 | 命理结果的使用边界 | DestinyScope 原创整理 | 当前已有，可补强 |

## 4. 文章写作要求

每篇文章必须：

- 原创改写。
- 通俗、简短、适合 App 内阅读。
- `body` 建议 300 到 600 字。
- 不复制来源不明的大段文字。
- 不直接搬运古籍或现代网页。
- 保持传统文化学习和自我探索定位。

每篇文章不得写：

- 精准预测。
- 改命。
- 化解。
- 避灾。
- 必然发财。
- 寿命疾病预测。
- 投资确定性。
- 婚姻确定性。
- 恐吓式大凶结论。
- 引导购买课程、咨询、法物或服务。

## 5. JSON 与未来 RAG 字段建议

V1.1 阶段 4B 写入 `knowledge_articles.json` 时，建议继续使用并扩展以下字段：

```json
{
  "id": "stable_snake_case_id",
  "category": "文章分类",
  "title": "文章标题",
  "summary": "30 到 80 字摘要",
  "body": "300 到 600 字原创改写正文",
  "tags": ["标签1", "标签2"],
  "source": "来源说明",
  "version": "1.1",
  "chunks": []
}
```

说明：

- `id`：稳定英文 snake_case，供详情页和未来 RAG 关联。
- `category`：用于知识库分类筛选。
- `title`：面向用户展示。
- `summary`：列表页摘要。
- `body`：App V1.1 展示正文。
- `tags`：2 到 5 个标签。
- `source`：记录原创整理和参考来源，不写“网络资料”。
- `version`：V1.1 新增或重写内容使用 `1.1`。
- `chunks`：未来 RAG 预留，V1.1 可以为空数组或暂不写入，具体在 4B 执行时决定。

## 6. 4B 执行顺序建议

1. 先读取现有 `knowledge_articles.json`，确认已有 5 篇的 id 和字段结构。
2. 保留已有文章，必要时补强正文和 source/version。
3. 新增文章到至少 20 篇，优先完成本计划中的前 20 到 24 篇。
4. 校验 JSON 可解析。
5. 静态扫描高风险词。
6. 运行 Debug 构建确认资源加载正常。
7. 手动检查知识库列表和详情页展示。
