# Destiny Knowledge QA Report

## 结论

- 阶段 2 补充后技术验收：Pass。
- 五行、天干、地支覆盖缺口已补齐到每类 50 篇以上。
- 正式产物结构、风险字段、使用边界、SQLite 完整性和 FTS5 检索均通过。
- 已接入 App 默认 JSON 读取路径，`destiny_knowledge_articles.json` / `destiny_rag_chunks.json` 为 306 篇 / 306 chunks。
- 文章 `body`、RAG `text`、SQLite `body/text` 已去掉重复的标题问题前缀和内联使用边界；使用边界只保留在 `usageBoundary` 字段。

## 联网资料与分析依据

本次补充优先采用经典文本和词典定义，再用现代整理资料交叉校验：

| 来源 | 用途 |
| --- | --- |
| 《尚书·洪范》 | 五行名称、次序和润下 / 炎上 / 曲直 / 从革 / 稼穑属性 |
| 《礼记·月令》 | 四时、日干、五音、五味等传统对应 |
| 《淮南子·天文训》 | 五方、五行、五音、五星、日干系统对应 |
| 汉典：天干 | 十天干定义、列表、与地支配合纪时 |
| 汉典：地支 | 十二地支定义、列表、与天干配合纪年纪月纪日纪时 |
| 维基百科：天干 | 天干作为循环计序符号和现代整理校验 |
| 维基百科：地支 | 地支、十二辰、时辰、方位、阴阳五行配属校验 |

处理原则：

- 只编入基础概念、符号顺序、五行配属、季节方位、使用边界。
- 不编入个人八字、合婚、择日、解卦、确定性判断或现实建议。
- 不使用“精准预测”“化解”“开光”“取名”等风险口径。
- 每条正式内容均带 `riskLevel=safe`、`qualityScore>=70`、`scenes` 和统一使用边界。

## 本阶段修改

- 新增 `tools/knowledge_import/curated_knowledge_supplement.py`：
  - 生成高质量五行、天干、地支基础条目。
  - 每条补充内容包含来源摘要和 `sourceRefs`。
- 更新 `tools/knowledge_import/build_destiny_knowledge.py`：
  - 合并 wuxingbagua 严格清洗结果与 curated supplement。
  - Manifest 区分 `wuxingbaguaArticles` 和 `curatedSupplementArticles`。
  - FTS 关键词对天干 / 地支做类目命中和单字命中区分。
  - 新增 `--publish-official-resources`，仅在自检通过后同步 App 默认 JSON 资源。
- 重建 `destiny_*` 产物，并将 App 默认读取路径切换到 `destiny_knowledge_articles.json` / `destiny_rag_chunks.json`。

## 最终数量

| 项目 | 数量 |
| --- | ---: |
| 正式 articles | 306 |
| 正式 chunks | 306 |
| wuxingbagua 正式保留 | 124 |
| curated supplement 正式保留 | 182 |
| reserved_future_naming | 1 |
| wuxingbagua 删除或未入库 | 1192 |
| 清理标题前缀 | 1268 |

## 分类分布

| 分类 | 数量 |
| --- | ---: |
| 阴阳 | 79 |
| 五行 | 64 |
| 天干 | 62 |
| 地支 | 60 |
| 八卦 | 28 |
| 易学基础 | 13 |

## 补充条目分布

| 分类 | 补充数量 |
| --- | ---: |
| 五行 | 60 |
| 天干 | 62 |
| 地支 | 60 |

## SQLite / FTS5

| 检查项 | 结果 |
| --- | --- |
| `PRAGMA integrity_check` | ok |
| `PRAGMA foreign_key_check` | Pass |
| `articles` rows | 306 |
| `rag_chunks` rows | 306 |
| `rag_chunks_fts` rows | 306 |

| 关键词 | FTS chunks |
| --- | ---: |
| 五行 | 122 |
| 阴阳 | 137 |
| 天干 | 62 |
| 地支 | 60 |
| 八卦 | 68 |
| 易学 | 95 |

单字检索抽查：

| 关键词 | FTS chunks |
| --- | ---: |
| 甲 | 5 |
| 乙 | 6 |
| 丙 | 6 |
| 丁 | 6 |
| 戊 | 6 |
| 己 | 6 |
| 庚 | 6 |
| 辛 | 6 |
| 壬 | 6 |
| 癸 | 5 |
| 子 | 4 |
| 丑 | 5 |
| 寅 | 5 |
| 卯 | 5 |
| 辰 | 5 |
| 巳 | 5 |
| 午 | 5 |
| 未 | 5 |
| 申 | 5 |
| 酉 | 5 |
| 戌 | 5 |
| 亥 | 4 |

## 风险扫描

| 检查项 | 结果 |
| --- | --- |
| 不含“这个问题是新知识”前缀 | Pass |
| 不含 tarot / face reading / ISBN / 出版社 / 印刷 / 开本 | Pass |
| 不含 投资 / 疾病 / 婚姻决策 / 结婚 | Pass |
| 不含 化解 / 开光 / 符咒 / 改命 / 转运 | Pass |
| 不含 取名 / 起名 / 名字 / 姓名学 | Pass |
| 不含个人咨询式八字 / 解卦内容 | Pass |
| 不含强确定性风险词 | Pass |
| 所有 chunk 均有 scenes / riskLevel / qualityScore | Pass |
| article / chunk 均保留 usageBoundary 字段 | Pass |
| article body 不内联使用边界 | Pass |
| chunk text 不内联使用边界 | Pass |
| article body 不含问题前缀 | Pass |
| chunk text 不含问题前缀 | Pass |

## 决策建议

1. 可以进入用户人工 check。
2. 用户确认内容质量后，再进入下一阶段：替换旧知识库或接入 SQLite 读取路径。
3. 进入下一阶段前仍建议保留旧 29 篇库作为可回滚资源。
