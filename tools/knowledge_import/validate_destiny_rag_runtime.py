#!/usr/bin/env python3
"""Validate DestinyScope local knowledge article and chunk resources.

This script intentionally verifies only JSON-backed local knowledge loading and
search behavior. It does not validate any prompt, model, or generation path.
"""

from __future__ import annotations

import json
import pathlib
import re
import sys
from typing import Any


ROOT = pathlib.Path(__file__).resolve().parents[2]
KNOWLEDGE_DIR = ROOT / "DestinyScope/Resources/Knowledge"
ARTICLES_PATH = KNOWLEDGE_DIR / "destiny_knowledge_articles.json"
CHUNKS_PATH = KNOWLEDGE_DIR / "destiny_rag_chunks.json"

FORBIDDEN_TERMS = (
    "这个问题是新知识",
    "tarot",
    "face reading",
    "ISBN",
    "出版社",
    "印刷",
    "投资",
    "疾病",
    "化解",
    "开光",
    "取名",
)


def load_json(path: pathlib.Path) -> list[dict[str, Any]]:
    return json.loads(path.read_text(encoding="utf-8"))


def assert_true(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def text_fields(record: dict[str, Any], keys: tuple[str, ...]) -> str:
    values: list[str] = []
    for key in keys:
        value = record.get(key)
        if isinstance(value, str):
            values.append(value)
        elif isinstance(value, list):
            values.extend(str(item) for item in value)
    return "\n".join(values)


def score_chunk(chunk: dict[str, Any], keywords: list[str]) -> float:
    if chunk.get("riskLevel", "").strip().lower() != "safe":
        return 0
    if int(chunk.get("qualityScore", 0)) < 70:
        return 0

    score = 0.0
    for keyword in keywords:
        if keyword in chunk.get("title", ""):
            score += 22
        if keyword in chunk.get("category", ""):
            score += 10
        for tag in chunk.get("tags", []):
            if tag == keyword:
                score += 16
            elif keyword in tag:
                score += 12
        if keyword in chunk.get("text", ""):
            score += 7

    if score > 0:
        score += min(max(int(chunk.get("qualityScore", 0)) - 70, 0) / 10, 4)
    return score


def search_chunks(chunks: list[dict[str, Any]], keywords: list[str], top_k: int) -> list[dict[str, Any]]:
    scored = [(score_chunk(chunk, keywords), chunk) for chunk in chunks]
    scored = [(score, chunk) for score, chunk in scored if score > 0]
    scored.sort(key=lambda item: (-item[0], -int(item[1].get("qualityScore", 0)), item[1].get("id", "")))
    return [chunk for _, chunk in scored[:top_k]]


def validate_record_text(records: list[dict[str, Any]], keys: tuple[str, ...], label: str) -> None:
    for record in records:
        content = text_fields(record, keys)
        assert_true("使用边界：" not in content, f"{label} {record.get('id')} contains inline usage boundary")
        assert_true(not re.search(r"(^|\n)\s*问题：", content), f"{label} {record.get('id')} contains duplicated question prefix")
        normalized = content.lower()
        for term in FORBIDDEN_TERMS:
            assert_true(term.lower() not in normalized, f"{label} {record.get('id')} contains forbidden term: {term}")


def main() -> int:
    articles = load_json(ARTICLES_PATH)
    chunks = load_json(CHUNKS_PATH)

    assert_true(len(articles) == 306, f"expected 306 articles, got {len(articles)}")
    assert_true(len(chunks) == 306, f"expected 306 chunks, got {len(chunks)}")

    article_ids = {article.get("id") for article in articles}
    assert_true(len(article_ids) == len(articles), "duplicate article ids found")
    assert_true(len({chunk.get("id") for chunk in chunks}) == len(chunks), "duplicate chunk ids found")

    for article in articles:
        assert_true(article.get("riskLevel") == "safe", f"article {article.get('id')} is not safe")
        assert_true(int(article.get("qualityScore", 0)) >= 70, f"article {article.get('id')} qualityScore < 70")
        assert_true(bool(article.get("usageBoundary")), f"article {article.get('id')} missing usageBoundary")

    for chunk in chunks:
        assert_true(chunk.get("articleId") in article_ids, f"chunk {chunk.get('id')} has unknown articleId")
        assert_true(chunk.get("riskLevel") == "safe", f"chunk {chunk.get('id')} is not safe")
        assert_true(int(chunk.get("qualityScore", 0)) >= 70, f"chunk {chunk.get('id')} qualityScore < 70")
        assert_true(bool(chunk.get("scenes")), f"chunk {chunk.get('id')} missing scenes")
        assert_true(bool(chunk.get("usageBoundary")), f"chunk {chunk.get('id')} missing usageBoundary")

    validate_record_text(articles, ("title", "body", "tags"), "article")
    validate_record_text(chunks, ("title", "text", "tags"), "chunk")

    search_terms = ("五行", "阴阳", "天干", "地支", "八卦", "易学")
    hits_by_term = {term: len(search_chunks(chunks, [term], 5)) for term in search_terms}
    for term, hit_count in hits_by_term.items():
        assert_true(hit_count > 0, f"searchChunks {term} should return non-empty results")

    print(json.dumps({
        "articles": len(articles),
        "chunks": len(chunks),
        "hitsByTerm": hits_by_term,
        "validation": "pass",
    }, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as error:
        print(f"validation failed: {error}", file=sys.stderr)
        raise SystemExit(1)
