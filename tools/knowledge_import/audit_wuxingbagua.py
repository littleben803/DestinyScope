#!/usr/bin/env python3
"""Audit yico1211/wuxingbagua as an offline DestinyScope knowledge source.

This script is intentionally read-only for app resources. It downloads the
source dataset into .build/knowledge_import and writes a Markdown audit report.
"""

from __future__ import annotations

import argparse
import collections
import datetime as dt
import json
import pathlib
import re
import statistics
import sys
import urllib.error
import urllib.request
from typing import Any


DATASET_ID = "yico1211/wuxingbagua"
DEFAULT_REVISION = "887e383daae7e55c75b85326695a26244a1bbc55"
RAW_FILENAME = "data_train.json"
BUILD_DIR = pathlib.Path(".build/knowledge_import")
DEFAULT_RAW_PATH = BUILD_DIR / "wuxingbagua_raw.json"
DEFAULT_SUMMARY_PATH = BUILD_DIR / "wuxingbagua_audit_summary.json"
DEFAULT_REPORT_PATH = pathlib.Path("docs/WuxingBaguaDatasetAudit.md")
EXPECTED_FIELDS = ("Question", "Response", "Complex_CoT")

BLOCK_TERMS = (
    "AI 算命",
    "精准预测",
    "改命",
    "化解",
    "避灾",
    "保证转运",
    "必然发财",
    "寿命预测",
    "疾病预测",
    "投资收益确定",
    "婚姻确定性",
    "大师在线",
    "付费改运",
)

REVIEW_TERMS = (
    "预测",
    "改变命运",
    "决定命运",
    "命运走向",
    "命运的好坏",
    "吉凶",
    "吉兆",
    "凶兆",
    "凶煞",
    "运势",
    "天命",
    "开运",
    "转运",
    "财运",
    "婚姻",
    "寿命",
    "疾病",
    "投资",
    "命主",
    "命盘",
)


def collapse_whitespace(value: Any) -> str:
    if value is None:
        return ""
    return re.sub(r"\s+", " ", str(value)).strip()


def load_records(path: pathlib.Path) -> list[dict[str, Any]]:
    text = path.read_text(encoding="utf-8")
    stripped = text.lstrip()
    if not stripped:
        return []
    if stripped.startswith("["):
        data = json.loads(text)
    else:
        data = [json.loads(line) for line in text.splitlines() if line.strip()]
    if not isinstance(data, list):
        raise ValueError(f"Expected a JSON array or JSONL file: {path}")
    records: list[dict[str, Any]] = []
    for index, item in enumerate(data):
        if not isinstance(item, dict):
            raise ValueError(f"Expected object at row {index}, got {type(item).__name__}")
        records.append(item)
    return records


def write_json(path: pathlib.Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def write_jsonl(path: pathlib.Path, records: list[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as output:
        for record in records:
            output.write(json.dumps(record, ensure_ascii=False, sort_keys=True))
            output.write("\n")


def fetch_json(url: str, timeout: int = 60) -> dict[str, Any]:
    request = urllib.request.Request(
        url,
        headers={"User-Agent": "DestinyScope knowledge import audit"},
    )
    with urllib.request.urlopen(request, timeout=timeout) as response:
        return json.loads(response.read().decode("utf-8"))


def download_dataset(raw_output: pathlib.Path, dataset_id: str, revision: str) -> str:
    raw_output.parent.mkdir(parents=True, exist_ok=True)
    url = f"https://huggingface.co/datasets/{dataset_id}/resolve/{revision}/{RAW_FILENAME}"
    request = urllib.request.Request(
        url,
        headers={"User-Agent": "DestinyScope knowledge import audit"},
    )
    with urllib.request.urlopen(request, timeout=120) as response:
        raw_output.write_bytes(response.read())
    return url


def fetch_dataset_metadata(dataset_id: str) -> dict[str, Any]:
    url = f"https://huggingface.co/api/datasets/{dataset_id}"
    try:
        return fetch_json(url)
    except (urllib.error.URLError, TimeoutError, json.JSONDecodeError) as error:
        return {"error": str(error)}


def classify_risk_terms(text: str) -> dict[str, list[str]]:
    block = [term for term in BLOCK_TERMS if term in text]
    review = [term for term in REVIEW_TERMS if term in text]
    return {
        "block": block,
        "review": review,
        "all": block + [term for term in review if term not in block],
    }


def length_summary(values: list[int]) -> dict[str, float | int]:
    if not values:
        return {"min": 0, "max": 0, "mean": 0, "median": 0}
    return {
        "min": min(values),
        "max": max(values),
        "mean": round(statistics.fmean(values), 2),
        "median": round(statistics.median(values), 2),
    }


def build_audit(records: list[dict[str, Any]], metadata: dict[str, Any]) -> dict[str, Any]:
    field_lengths: dict[str, list[int]] = {field: [] for field in EXPECTED_FIELDS}
    blank_counts: collections.Counter[str] = collections.Counter()
    missing_counts: collections.Counter[str] = collections.Counter()
    extra_fields: collections.Counter[str] = collections.Counter()
    pair_counts: collections.Counter[tuple[str, str]] = collections.Counter()
    question_counts: collections.Counter[str] = collections.Counter()
    block_counter: collections.Counter[str] = collections.Counter()
    review_counter: collections.Counter[str] = collections.Counter()
    risk_examples: list[dict[str, Any]] = []
    malformed_rows: list[int] = []
    short_response_rows: list[int] = []

    for row_index, record in enumerate(records):
        keys = set(record.keys())
        for field in keys.difference(EXPECTED_FIELDS):
            extra_fields[field] += 1
        for field in EXPECTED_FIELDS:
            if field not in record:
                missing_counts[field] += 1
            normalized = collapse_whitespace(record.get(field))
            field_lengths[field].append(len(normalized))
            if not normalized:
                blank_counts[field] += 1

        question = collapse_whitespace(record.get("Question"))
        response = collapse_whitespace(record.get("Response"))
        cot = collapse_whitespace(record.get("Complex_CoT"))
        if not question or not response:
            malformed_rows.append(row_index)
        if 0 < len(response) < 12:
            short_response_rows.append(row_index)
        pair_counts[(question, response)] += 1
        question_counts[question] += 1

        hits = classify_risk_terms(" ".join((question, response, cot)))
        block_counter.update(hits["block"])
        review_counter.update(hits["review"])
        if hits["all"] and len(risk_examples) < 12:
            risk_examples.append(
                {
                    "row": row_index,
                    "question": question,
                    "terms": hits["all"],
                }
            )

    duplicate_pair_groups = [
        {"question": q, "response": r, "count": count}
        for (q, r), count in pair_counts.items()
        if count > 1 and q and r
    ]
    duplicate_question_groups = [
        {"question": q, "count": count}
        for q, count in question_counts.items()
        if count > 1 and q
    ]

    duplicate_pair_groups.sort(key=lambda item: item["count"], reverse=True)
    duplicate_question_groups.sort(key=lambda item: item["count"], reverse=True)
    duplicate_rows = sum(item["count"] - 1 for item in duplicate_pair_groups)
    rows_with_any_risk = sum(
        1
        for record in records
        if classify_risk_terms(
            " ".join(
                collapse_whitespace(record.get(field))
                for field in EXPECTED_FIELDS
            )
        )["all"]
    )
    rows_with_block_risk = sum(
        1
        for record in records
        if classify_risk_terms(
            " ".join(
                collapse_whitespace(record.get(field))
                for field in EXPECTED_FIELDS
            )
        )["block"]
    )

    return {
        "dataset": DATASET_ID,
        "revision": metadata.get("sha") or DEFAULT_REVISION,
        "license": metadata.get("cardData", {}).get("license") if isinstance(metadata.get("cardData"), dict) else None,
        "lastModified": metadata.get("lastModified"),
        "createdAt": metadata.get("createdAt"),
        "siblings": [item.get("rfilename") for item in metadata.get("siblings", []) if isinstance(item, dict)],
        "rowCount": len(records),
        "expectedFields": list(EXPECTED_FIELDS),
        "extraFields": dict(extra_fields),
        "fieldStats": {
            field: {
                "blank": blank_counts[field],
                "missing": missing_counts[field],
                **length_summary(field_lengths[field]),
            }
            for field in EXPECTED_FIELDS
        },
        "quality": {
            "malformedRows": len(malformed_rows),
            "malformedRowSamples": malformed_rows[:12],
            "shortResponseRows": len(short_response_rows),
            "shortResponseSamples": short_response_rows[:12],
            "duplicateExactPairGroups": len(duplicate_pair_groups),
            "duplicateExactRows": duplicate_rows,
            "duplicateQuestionGroups": len(duplicate_question_groups),
            "duplicatePairSamples": duplicate_pair_groups[:10],
            "duplicateQuestionSamples": duplicate_question_groups[:10],
        },
        "risk": {
            "rowsWithAnyRiskTerm": rows_with_any_risk,
            "rowsWithBlockRiskTerm": rows_with_block_risk,
            "blockTerms": dict(block_counter.most_common()),
            "reviewTerms": dict(review_counter.most_common()),
            "examples": risk_examples,
        },
    }


def format_field_table(summary: dict[str, Any]) -> str:
    rows = [
        "| 字段 | 空值 | 缺失 | 最短 | 最长 | 均值 | 中位数 |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]
    for field in EXPECTED_FIELDS:
        stats = summary["fieldStats"][field]
        rows.append(
            f"| `{field}` | {stats['blank']} | {stats['missing']} | "
            f"{stats['min']} | {stats['max']} | {stats['mean']} | {stats['median']} |"
        )
    return "\n".join(rows)


def format_term_counts(title: str, counts: dict[str, int]) -> str:
    if not counts:
        return f"- {title}：未命中"
    rendered = [f"- {title}："]
    for term, count in list(counts.items())[:16]:
        rendered.append(f"  - `{term}`：{count}")
    return "\n".join(rendered)


def write_markdown_report(path: pathlib.Path, summary: dict[str, Any], raw_url: str) -> None:
    generated_at = dt.datetime.now(dt.timezone.utc).astimezone().strftime("%Y-%m-%d %H:%M:%S %z")
    license_value = summary.get("license") or "未声明"
    duplicate_rate = 0
    if summary["rowCount"]:
        duplicate_rate = round(summary["quality"]["duplicateExactRows"] / summary["rowCount"] * 100, 2)
    risk_rate = 0
    if summary["rowCount"]:
        risk_rate = round(summary["risk"]["rowsWithAnyRiskTerm"] / summary["rowCount"] * 100, 2)

    duplicate_samples = summary["quality"]["duplicatePairSamples"]
    duplicate_lines = ["无"] if not duplicate_samples else [
        f"- `{item['question']}`：{item['count']} 次" for item in duplicate_samples[:8]
    ]

    risk_examples = summary["risk"]["examples"]
    risk_lines = ["无"] if not risk_examples else [
        f"- row {item['row']} `{item['question']}`：{', '.join('`' + term + '`' for term in item['terms'])}"
        for item in risk_examples[:8]
    ]

    report = f"""# WuxingBagua 数据集字段审计报告

生成时间：{generated_at}

## 阶段边界

本报告属于 DestinyScope 阶段 1：离线审计 + 清洗/转换脚本。当前阶段只处理外部数据源审计和候选转换，不修改正式 App 资源，不接入本地检索或 RAG，不写入 `DestinyScope/Resources/Knowledge/destiny_knowledge_articles.json` 或 `DestinyScope/Resources/Knowledge/destiny_rag_chunks.json`。

## 数据源

- Hugging Face Dataset：[yico1211/wuxingbagua](https://huggingface.co/datasets/yico1211/wuxingbagua)
- 用途描述：用于微调模型，增加模型的命理知识
- 拉取文件：`{RAW_FILENAME}`
- 拉取地址：`{raw_url}`
- 审计 revision：`{summary['revision']}`
- Last modified：`{summary.get('lastModified') or '未知'}`
- License：{license_value}
- 文件列表：{', '.join('`' + item + '`' for item in summary.get('siblings', []) if item) or '未知'}

## 结论摘要

- 数据集共 `{summary['rowCount']}` 行，结构为 `Question`、`Response`、`Complex_CoT` 三个字段。
- `Complex_CoT` 存在 `{summary['fieldStats']['Complex_CoT']['blank']}` 条空值；该字段疑似训练过程解释链，清洗脚本默认丢弃，不进入知识库候选输出。
- 精确重复问答行 `{summary['quality']['duplicateExactRows']}` 条，重复率约 `{duplicate_rate}%`，必须去重后再考虑使用。
- 命中合规复核词的行 `{summary['risk']['rowsWithAnyRiskTerm']}` 条，占比约 `{risk_rate}%`；这些行默认进入 review queue，不进入 dry-run 知识库候选。
- License 未在 Hub API 和 README 中明确声明，正式入库前需要人工确认授权边界。

## 字段审计

{format_field_table(summary)}

## 数据质量问题

- 空问题或空回答行：{summary['quality']['malformedRows']}。
- 过短回答行：{summary['quality']['shortResponseRows']}。
- 精确重复问答组：{summary['quality']['duplicateExactPairGroups']}。
- 重复问题组：{summary['quality']['duplicateQuestionGroups']}。

重复样例：

{chr(10).join(duplicate_lines)}

## 合规与产品风险

{format_term_counts('禁止宣传词命中', summary['risk']['blockTerms'])}

{format_term_counts('需人工复核词命中', summary['risk']['reviewTerms'])}

风险样例：

{chr(10).join(risk_lines)}

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
"""
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(report, encoding="utf-8")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dataset-id", default=DATASET_ID)
    parser.add_argument("--revision", default=DEFAULT_REVISION)
    parser.add_argument("--raw-output", type=pathlib.Path, default=DEFAULT_RAW_PATH)
    parser.add_argument("--summary-json", type=pathlib.Path, default=DEFAULT_SUMMARY_PATH)
    parser.add_argument("--report", type=pathlib.Path, default=DEFAULT_REPORT_PATH)
    parser.add_argument("--skip-download", action="store_true", help="Use an existing raw file.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    raw_url = f"https://huggingface.co/datasets/{args.dataset_id}/resolve/{args.revision}/{RAW_FILENAME}"
    if not args.skip_download:
        raw_url = download_dataset(args.raw_output, args.dataset_id, args.revision)
    if not args.raw_output.exists():
        print(f"Raw dataset not found: {args.raw_output}", file=sys.stderr)
        return 2

    records = load_records(args.raw_output)
    metadata = fetch_dataset_metadata(args.dataset_id)
    if "sha" not in metadata:
        metadata["sha"] = args.revision
    summary = build_audit(records, metadata)
    write_json(args.summary_json, summary)
    write_markdown_report(args.report, summary, raw_url)
    print(
        json.dumps(
            {
                "rows": summary["rowCount"],
                "duplicateExactRows": summary["quality"]["duplicateExactRows"],
                "rowsWithAnyRiskTerm": summary["risk"]["rowsWithAnyRiskTerm"],
                "report": str(args.report),
                "summaryJson": str(args.summary_json),
                "rawOutput": str(args.raw_output),
            },
            ensure_ascii=False,
            indent=2,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
