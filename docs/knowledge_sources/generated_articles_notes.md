# DestinyScope V1.1 阶段 4B 生成文章记录

更新日期：2026-05-27

## 本阶段变更

- 将 `DestinyScope/Resources/Knowledge/knowledge_articles.json` 扩充到 29 篇。
- 新增 `DestinyScope/Resources/Knowledge/rag_chunks.json`，共 29 个 chunk。
- 未修改 Swift 代码。
- 未修改 `KnowledgeArticle.swift`、`KnowledgeRepository.swift` 或 UI 页面。

## 内容生成原则

- 所有文章均为原创改写。
- 古籍、机构资料和百科资料仅作为 reference 或概念核对。
- 对称骨算命内容，只参考 DestinyScope 内置称骨数据和民间算法流传形态，不把普通算命网站作为高可信来源。
- 文章以传统文化、自我探索、理性参考为主，不写现实结果承诺。

## 使用的主要来源

- 中国哲学书电子化计划 CText：https://ctext.org/zhs
- CText《周易》：https://ctext.org/book-of-changes/zhs
- 维基文库《周易》：https://zh.wikisource.org/wiki/周易
- 维基文库《梅花易数》：https://zh.wikisource.org/zh-hans/梅花易數
- CCTV 生肖资料：https://www.cctv.com/geography/news/20021202/25.html
- 中国文艺网十二生肖与时辰资料：https://www.cflac.org.cn/wywzt/2014/2014chunjie/chunjie/201401/t20140124_241521.html
- 五行资料：https://zh.wikipedia.org/wiki/五行
- CText 五行生克片段：https://ctext.org/wiki.pl?chapter=120081&if=gb&remap=gb

## 后续人工审校建议

- 逐篇检查文字是否符合 App 内显示长度。
- 抽查 source 字段是否满足上架素材说明。
- 后续如果接入本地 RAG，需要确认 `rag_chunks.json` 是否随文章同步更新。
