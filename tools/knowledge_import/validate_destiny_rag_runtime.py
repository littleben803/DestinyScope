#!/usr/bin/env python3
"""Validate DestinyScope runtime RAG data and source wiring.

This script is intentionally lightweight: it does not load the GGUF model and
does not require a simulator. It verifies the JSON-backed retrieval contract,
prompt source requirements, safety terms, and fallback wiring expected by the
runtime Swift implementation.
"""

from __future__ import annotations

import json
import pathlib
import re
import sys
from typing import Any


ROOT = pathlib.Path(__file__).resolve().parents[2]
KNOWLEDGE_DIR = ROOT / "DestinyScope/Resources/Knowledge"
DOMAIN_DIR = ROOT / "DestinyScope/Domain/Knowledge"


def load_chunks() -> list[dict[str, Any]]:
    return json.loads((KNOWLEDGE_DIR / "rag_chunks.json").read_text(encoding="utf-8"))


def score_chunk(chunk: dict[str, Any], keywords: list[str], scene_aliases: set[str]) -> float:
    if chunk.get("riskLevel", "").strip().lower() != "safe":
        return 0
    if int(chunk.get("qualityScore", 0)) < 70:
        return 0

    scenes = {scene.strip().lower().replace("-", "_") for scene in chunk.get("scenes", [])}
    score = 6 if scenes.intersection(scene_aliases) else 0

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
    aliases = {"wuxing_balance", "knowledge_library", "rag_retrieval", "traditional_culture", "wuxing_foundation", "yinyang_foundation"}
    scored = [(score_chunk(chunk, keywords, aliases), chunk) for chunk in chunks]
    scored = [(score, chunk) for score, chunk in scored if score > 0]
    scored.sort(key=lambda item: (-item[0], -int(item[1].get("qualityScore", 0)), item[1].get("id", "")))

    seen_article_ids: set[str] = set()
    output: list[dict[str, Any]] = []
    for _, chunk in scored:
        article_id = chunk.get("articleId")
        if article_id in seen_article_ids:
            continue
        seen_article_ids.add(article_id)
        output.append(chunk)
        if len(output) >= top_k:
            break
    return output


def build_rag_context(chunks: list[dict[str, Any]]) -> str:
    lines = ["【知识片段】"]
    for chunk in chunks:
        text = re.sub(r"\s+", " ", chunk.get("text", "").replace("参考解读：", "")).strip()
        if len(text) > 180:
            text = text[:180] + "…"
        candidate = "\n".join(lines + [f"{len(lines)}. {text}"])
        if len(candidate) > 900:
            break
        lines.append(f"{len(lines)}. {text}")
    return "\n".join(lines)


def assert_true(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def main() -> int:
    chunks = load_chunks()
    assert_true(len(chunks) == 306, f"expected 306 rag chunks, got {len(chunks)}")

    hits = search_chunks(chunks, ["五行"], 5)
    assert_true(bool(hits), "searchChunks 五行 should return non-empty results")
    assert_true(all(hit["riskLevel"] == "safe" for hit in hits), "unsafe chunks returned")
    assert_true(all(hit["qualityScore"] >= 70 for hit in hits), "low quality chunks returned")

    rejected_fixture = [
        dict(hits[0], id="unsafe_fixture", articleId="unsafe_fixture", riskLevel="review"),
        dict(hits[0], id="low_quality_fixture", articleId="low_quality_fixture", qualityScore=69),
    ]
    fixture_hits = search_chunks(rejected_fixture, ["五行"], 5)
    assert_true(not fixture_hits, "riskLevel != safe or qualityScore < 70 fixtures should be rejected")

    rag_context = build_rag_context(hits)
    assert_true(len(rag_context) <= 900, f"RAG context too long: {len(rag_context)}")

    prompt_source = (DOMAIN_DIR / "DestinyPromptBuilder.swift").read_text(encoding="utf-8")
    assert_true("只输出一个 JSON 对象" in prompt_source, "PromptBuilder missing JSON-only instruction")
    assert_true('"overview"' in prompt_source and '"answer"' in prompt_source, "PromptBuilder missing required JSON schemas")

    safety_source = (DOMAIN_DIR / "DestinySafetyPolicy.swift").read_text(encoding="utf-8")
    for question_term in ["发财", "离婚", "有没有病", "化解", "取名"]:
        assert_true(question_term in safety_source, f"SafetyPolicy missing term: {question_term}")
    assert_true("当前版本暂未开放取名功能" in safety_source, "SafetyPolicy missing naming fallback message")

    service_source = (DOMAIN_DIR / "DestinyInterpretationService.swift").read_text(encoding="utf-8")
    assert_true("fallbackTriggered: true" in service_source, "InterpretationService missing fallback log path")
    assert_true("extractJSONObject" in service_source, "InterpretationService missing JSON extraction")

    print(json.dumps({
        "ragChunks": len(chunks),
        "wuxingHits": len(hits),
        "ragContextLength": len(rag_context),
        "validation": "pass",
    }, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as error:
        print(f"validation failed: {error}", file=sys.stderr)
        raise SystemExit(1)
