#!/usr/bin/env python3
"""Convert cleaned wuxingbagua rows into DestinyScope knowledge candidates.

The output is a dry-run candidate only. This script must not write to
DestinyScope/Resources/Knowledge directly.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import pathlib
import re
import sys
from typing import Any

from audit_wuxingbagua import BUILD_DIR, DATASET_ID, DEFAULT_REVISION, collapse_whitespace, load_records, write_json
from clean_wuxingbagua import DEFAULT_CLEANED_PATH


DEFAULT_ARTICLES_PATH = BUILD_DIR / "wuxingbagua_knowledge_articles_candidate.json"
DEFAULT_CHUNKS_PATH = BUILD_DIR / "wuxingbagua_rag_chunks_candidate.json"
DEFAULT_SUMMARY_PATH = BUILD_DIR / "wuxingbagua_conversion_summary.json"

CATEGORY_RULES: tuple[tuple[str, tuple[str, ...]], ...] = (
    ("五行", ("五行", "木", "火", "土", "金", "水", "相生", "相克")),
    ("阴阳", ("阴阳", "阳", "阴")),
    ("天干地支", ("天干", "地支", "甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸", "子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥")),
    ("八卦", ("八卦", "乾", "坤", "震", "巽", "坎", "离", "艮", "兑")),
    ("易学基础", ("易经", "周易", "卦", "爻")),
    ("农历时辰", ("农历", "时辰", "节气", "出生时间")),
    ("生肖", ("生肖", "属相")),
    ("使用边界", ("边界", "理性", "参考", "自我探索")),
)

TAG_RULES: tuple[tuple[str, tuple[str, ...]], ...] = (
    ("五行", ("五行", "木", "火", "土", "金", "水")),
    ("阴阳", ("阴阳",)),
    ("天干", ("天干",)),
    ("地支", ("地支",)),
    ("八卦", ("八卦",)),
    ("易学", ("易经", "周易", "卦")),
    ("时辰", ("时辰", "出生时间")),
    ("传统文化", ("命理", "传统", "天道", "地道")),
    ("自我探索", ("人性", "自我", "选择")),
)


def load_cleaned_rows(path: pathlib.Path) -> list[dict[str, Any]]:
    return load_records(path)


def slug_hash(text: str) -> str:
    return hashlib.sha1(text.encode("utf-8")).hexdigest()[:10]


def truncate_text(text: str, limit: int) -> str:
    normalized = collapse_whitespace(text)
    if len(normalized) <= limit:
        return normalized
    return normalized[: limit - 1].rstrip("，。；、 ") + "…"


def title_from_question(question: str) -> str:
    title = collapse_whitespace(question)
    title = re.sub(r"[？?。.\s]+$", "", title)
    return truncate_text(title, 34) or "传统文化问答"


def infer_category(question: str, response: str) -> str:
    text = f"{question} {response}"
    for category, terms in CATEGORY_RULES:
        if any(term in text for term in terms):
            return category
    return "传统命理文化"


def infer_tags(question: str, response: str, category: str) -> list[str]:
    text = f"{question} {response}"
    tags: list[str] = [category]
    for tag, terms in TAG_RULES:
        if tag not in tags and any(term in text for term in terms):
            tags.append(tag)
    if "传统文化" not in tags:
        tags.append("传统文化")
    return tags[:5]


def article_from_row(index: int, row: dict[str, Any], revision: str, source_version: str) -> dict[str, Any]:
    question = collapse_whitespace(row.get("question") or row.get("Question"))
    response = collapse_whitespace(row.get("response") or row.get("Response"))
    identity = f"{question}\n{response}"
    category = infer_category(question, response)
    title = title_from_question(question)
    body = (
        f"问题：{question}\n\n"
        f"参考解读：{response}\n\n"
        "使用边界：以上内容来自外部数据集清洗后的候选文本，"
        "仅适合作为传统文化与自我探索参考，不构成现实决策建议。"
    )
    return {
        "id": f"wuxingbagua_{index + 1:04d}_{slug_hash(identity)}",
        "category": category,
        "title": title,
        "summary": truncate_text(response, 86),
        "body": body,
        "tags": infer_tags(question, response, category),
        "source": f"Hugging Face dataset {DATASET_ID}, revision {revision}; license not declared; dry-run candidate",
        "version": source_version,
    }


def chunk_from_article(article: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": f"{article['id']}_chunk_001",
        "articleId": article["id"],
        "category": article["category"],
        "title": article["title"],
        "text": truncate_text(article["summary"] + " " + article["body"], 280),
        "tags": article["tags"],
        "source": article["source"],
        "version": article["version"],
    }


def convert_rows(
    rows: list[dict[str, Any]],
    revision: str,
    source_version: str,
    max_articles: int | None,
) -> tuple[list[dict[str, Any]], list[dict[str, Any]], dict[str, Any]]:
    if max_articles is not None:
        rows = rows[:max_articles]
    articles = [article_from_row(index, row, revision, source_version) for index, row in enumerate(rows)]
    chunks = [chunk_from_article(article) for article in articles]
    categories: dict[str, int] = {}
    for article in articles:
        categories[article["category"]] = categories.get(article["category"], 0) + 1
    summary = {
        "inputRows": len(rows),
        "articles": len(articles),
        "chunks": len(chunks),
        "categories": categories,
        "policy": "dry-run candidate only; official knowledge resources are not modified",
    }
    return articles, chunks, summary


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=pathlib.Path, default=DEFAULT_CLEANED_PATH)
    parser.add_argument("--revision", default=DEFAULT_REVISION)
    parser.add_argument("--source-version", default="wuxingbagua-dry-run-2026-06-03")
    parser.add_argument("--articles-output", type=pathlib.Path, default=DEFAULT_ARTICLES_PATH)
    parser.add_argument("--chunks-output", type=pathlib.Path, default=DEFAULT_CHUNKS_PATH)
    parser.add_argument("--summary-json", type=pathlib.Path, default=DEFAULT_SUMMARY_PATH)
    parser.add_argument("--max-articles", type=int, default=None)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if not args.input.exists():
        print(f"Input not found: {args.input}. Run clean_wuxingbagua.py first.", file=sys.stderr)
        return 2
    rows = load_cleaned_rows(args.input)
    articles, chunks, summary = convert_rows(
        rows,
        revision=args.revision,
        source_version=args.source_version,
        max_articles=args.max_articles,
    )
    write_json(args.articles_output, articles)
    write_json(args.chunks_output, chunks)
    write_json(args.summary_json, summary)
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
