# Destiny Knowledge Build Report

## 构建结论

- 生成时间：2026-06-04T16:01:55+00:00
- 新知识库 JSON：306 articles
- 新 RAG JSON：306 chunks
- 命名类保留：1 records
- SQLite：`DestinyScope/Resources/Knowledge/destiny_knowledge.sqlite`
- App 默认 JSON 资源：已同步到 `DestinyScope/Resources/Knowledge/knowledge_articles.json` / `DestinyScope/Resources/Knowledge/rag_chunks.json`
- 验收自检：Pass

## 输入数量

| 输入 | 数量 |
| --- | ---: |
| sourceRows | 2240 |
| cleanedRows | 1317 |
| candidateArticles | 1317 |
| candidateChunks | 1317 |
| curatedSupplementArticles | 182 |
| curatedSupplementChunks | 182 |
| auditRiskRows | 808 |

## 过滤数量

| 项目 | 数量 |
| --- | ---: |
| 清理标题前缀 | 1268 |
| 命名类保留 | 1 |
| wuxingbagua 删除或未入库 | 1192 |
| wuxingbagua 正式保留 | 124 |
| curated supplement 正式保留 | 182 |
| 正式保留 | 306 |

## 各分类数量

| 项目 | 数量 |
| --- | ---: |
| 阴阳 | 79 |
| 五行 | 64 |
| 天干 | 62 |
| 地支 | 60 |
| 八卦 | 28 |
| 易学基础 | 13 |

## 各场景数量

| 项目 | 数量 |
| --- | ---: |
| knowledge_library | 306 |
| rag_retrieval | 306 |
| usage_boundary | 306 |
| traditional_culture | 258 |
| ganzhi_foundation | 122 |
| yinyang_foundation | 84 |
| yixue_foundation | 74 |
| bagua_foundation | 68 |
| wuxing_foundation | 65 |

## 被删除原因 TopN

| 删除原因 | 数量 |
| --- | ---: |
| deleted:advanced_yijing_exegesis | 983 |
| deleted:governance_or_ethics_case | 464 |
| deleted:book_or_source_specific | 94 |
| deleted:out_of_scope | 61 |
| deleted:personal_consultation | 32 |
| deleted:behavior_or_ethics_advice | 29 |
| deleted:military_or_conflict | 21 |
| deleted:face_reading | 11 |
| deleted:book_metadata | 8 |
| deleted:tarot_or_divination | 5 |
| deleted:review_risk_terms | 2 |
| deleted:review_risk_terms:决定着 | 2 |

## SQLite / FTS5

- 普通表：`metadata`、`articles`、`rag_chunks`
- FTS5 表：`articles_fts`、`rag_chunks_fts`
- 示例检索命中：

| 关键词 | chunks |
| --- | ---: |
| 五行 | 122 |
| 阴阳 | 137 |
| 天干 | 62 |
| 地支 | 60 |
| 八卦 | 68 |
| 易学 | 95 |

## 自检结果

| 检查项 | 结果 |
| --- | --- |
| 不含“这个问题是新知识”前缀 | Pass |
| 不含正式禁用词 | Pass |
| chunk 均有 scenes / riskLevel / qualityScore | Pass |
| article / chunk 均保留 usageBoundary 字段 | Pass |
| article body 不内联使用边界 | Pass |
| chunk text 不内联使用边界 | Pass |
| article body 不含问题前缀 | Pass |
| chunk text 不含问题前缀 | Pass |
| article 均为 safe | Pass |

## 说明

- 默认构建只生成 `destiny_*` 新产物；带 `--publish-official-resources` 运行时，才会将已通过自检的新内容同步到 `knowledge_articles.json` 和 `rag_chunks.json`。
- `reserved_future_naming.json` 仅用于未来命名方向评估，不进入正式知识库和 SQLite。
- 数据源审计记录显示原始数据集 license 未声明；正式分发前仍建议保留人工 license 复核记录。
- 所有正式 article / chunk 均保留 `usageBoundary` 字段；body 与 RAG text 不再内联重复边界。
