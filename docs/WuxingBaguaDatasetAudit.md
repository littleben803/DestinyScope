# WuxingBagua 数据集字段审计报告

生成时间：2026-06-03 17:05:48 +0800

## 阶段边界

本报告属于 DestinyScope 阶段 1：离线审计 + 清洗/转换脚本。当前阶段只处理外部数据源审计和候选转换，不修改正式 App 资源，不接入本地检索或 RAG，不写入 `DestinyScope/Resources/Knowledge/knowledge_articles.json` 或 `DestinyScope/Resources/Knowledge/rag_chunks.json`。

## 数据源

- Hugging Face Dataset：[yico1211/wuxingbagua](https://huggingface.co/datasets/yico1211/wuxingbagua)
- 用途描述：用于微调模型，增加模型的命理知识
- 拉取文件：`data_train.json`
- 拉取地址：`https://huggingface.co/datasets/yico1211/wuxingbagua/resolve/887e383daae7e55c75b85326695a26244a1bbc55/data_train.json`
- 审计 revision：`887e383daae7e55c75b85326695a26244a1bbc55`
- Last modified：`2025-11-04T01:55:22.000Z`
- License：未声明
- 文件列表：`.gitattributes`, `README.md`, `data_train.json`

## 结论摘要

- 数据集共 `2240` 行，结构为 `Question`、`Response`、`Complex_CoT` 三个字段。
- `Complex_CoT` 存在 `335` 条空值；该字段疑似训练过程解释链，清洗脚本默认丢弃，不进入知识库候选输出。
- 精确重复问答行 `274` 条，重复率约 `12.23%`，必须去重后再考虑使用。
- 命中合规复核词的行 `808` 条，占比约 `36.07%`；这些行默认进入 review queue，不进入 dry-run 知识库候选。
- License 未在 Hub API 和 README 中明确声明，正式入库前需要人工确认授权边界。

## 字段审计

| 字段 | 空值 | 缺失 | 最短 | 最长 | 均值 | 中位数 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `Question` | 0 | 0 | 6 | 135 | 37.62 | 41.0 |
| `Response` | 7 | 0 | 0 | 2621 | 392.8 | 389.0 |
| `Complex_CoT` | 335 | 35 | 0 | 2616 | 452.25 | 490.0 |

## 数据质量问题

- 空问题或空回答行：7。
- 过短回答行：0。
- 精确重复问答组：26。
- 重复问题组：26。

重复样例：

- `什么是天道？`：12 次
- `解释地道的原理。`：12 次
- `人性在中国命理学中的作用是什么？`：12 次
- `天干与地支的关系是什么？`：12 次
- `阴阳的概念如何解释？`：12 次
- `命理学中的时机概念是什么？`：12 次
- `出生时间对命运的影响是什么？`：12 次
- `环境在命运中的作用是什么？`：12 次

## 合规与产品风险

- 禁止宣传词命中：
  - `化解`：250
  - `改命`：10
  - `避灾`：9
  - `精准预测`：1

- 需人工复核词命中：
  - `吉凶`：210
  - `运势`：164
  - `预测`：99
  - `吉兆`：89
  - `命盘`：79
  - `婚姻`：69
  - `财运`：61
  - `天命`：55
  - `投资`：42
  - `命运走向`：39
  - `命主`：37
  - `凶兆`：34
  - `改变命运`：22
  - `开运`：18
  - `疾病`：15
  - `凶煞`：14

风险样例：

- row 1 `解释地道的原理。`：`吉凶`
- row 3 `天干与地支的关系是什么？`：`决定命运`
- row 7 `环境在命运中的作用是什么？`：`命运的好坏`
- row 9 `天干如何影响人的命运？`：`命运走向`
- row 11 `什么是吉凶兆象？`：`吉凶`, `吉兆`, `凶兆`
- row 12 `命运中的‘运势’如何看待？`：`运势`
- row 14 `‘天命’是什么意思？`：`天命`
- row 16 `‘命格’如何影响人的运势？`：`运势`

## 清洗策略

阶段 1 清洗脚本采用保守策略：

- 标准化空白字符，保留中文原文。
- 删除 `Question` 或 `Response` 为空的行。
- 按 `Question + Response` 精确去重。
- 默认丢弃 `Complex_CoT`，不把解释链或推理字段带入 App 候选知识库。
- 命中禁止宣传词或需人工复核词的行进入 `.build/knowledge_import/wuxingbagua_review_queue.jsonl`。
- 只有无风险词命中的有效唯一行进入 `.build/knowledge_import/wuxingbagua_cleaned.jsonl`。

## 转换策略

转换脚本只生成 dry-run 候选文件：

- `.build/knowledge_import/wuxingbagua_knowledge_articles_candidate.json`
- `.build/knowledge_import/wuxingbagua_rag_chunks_candidate.json`

候选 `KnowledgeArticle` 映射：

- `id`：`wuxingbagua_` 前缀 + 顺序号 + 内容 hash。
- `category`：基于关键词粗分到 `五行`、`阴阳`、`天干地支`、`八卦`、`农历时辰`、`生肖`、`传统命理文化` 等。
- `title`：来自 `Question`。
- `summary`：来自 `Response` 的短摘要。
- `body`：保留问答内容，并追加“传统文化与自我探索参考”边界说明。
- `source`：记录 Hugging Face 数据集、revision 和 license 未声明状态。

## 阻断项

1. License 未声明，不能直接并入正式知识库。
2. 原始数据含大量重复，需要先去重。
3. 原始文本存在预测、运势、改变命运、吉凶等高风险/需复核表达，不能原样进入 App。
4. 当前项目状态仍明确不做 RAG，候选 chunk 只能作为离线评估产物。

## 可复现命令

```bash
python3 tools/knowledge_import/audit_wuxingbagua.py
python3 tools/knowledge_import/clean_wuxingbagua.py
python3 tools/knowledge_import/convert_wuxingbagua_to_knowledge.py
```
