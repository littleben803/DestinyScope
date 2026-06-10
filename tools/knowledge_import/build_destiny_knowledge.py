#!/usr/bin/env python3
"""Build DestinyScope-ready knowledge and local RAG artifacts.

This builder consumes only the cleaned wuxingbagua artifacts that were already
produced by the prior import pass. It deliberately does not read raw rows,
review queues, reject queues, or Complex_CoT.
"""

from __future__ import annotations

import argparse
import collections
import datetime as dt
import json
import pathlib
import re
import sqlite3
import sys
from typing import Any

from curated_knowledge_supplement import SOURCE_REFS, curated_supplement_articles


BUILD_DIR = pathlib.Path(".build/knowledge_import")
INPUT_CLEANED = BUILD_DIR / "wuxingbagua_cleaned.jsonl"
INPUT_ARTICLES = BUILD_DIR / "wuxingbagua_knowledge_articles_candidate.json"
INPUT_CHUNKS = BUILD_DIR / "wuxingbagua_rag_chunks_candidate.json"
INPUT_CLEANING_SUMMARY = BUILD_DIR / "wuxingbagua_cleaning_summary.json"
INPUT_AUDIT_SUMMARY = BUILD_DIR / "wuxingbagua_audit_summary.json"

OUTPUT_DIR = pathlib.Path("DestinyScope/Resources/Knowledge")
OUTPUT_ARTICLES = OUTPUT_DIR / "destiny_knowledge_articles.json"
OUTPUT_CHUNKS = OUTPUT_DIR / "destiny_rag_chunks.json"
OFFICIAL_ARTICLES = OUTPUT_ARTICLES
OFFICIAL_CHUNKS = OUTPUT_CHUNKS
OUTPUT_RESERVED_NAMING = BUILD_DIR / "reserved_future_naming.json"
OUTPUT_MANIFEST = BUILD_DIR / "destiny_knowledge_manifest.json"
OUTPUT_SQLITE = BUILD_DIR / "destiny_knowledge.sqlite"
OUTPUT_REPORT = pathlib.Path("docs/destiny_knowledge_build_report.md")

SOURCE_VERSION = "destiny-knowledge-2026-06-03"
QUALITY_THRESHOLD = 70
RISK_LEVEL_SAFE = "safe"
BOUNDARY_TEXT = "使用边界：本条内容仅用于传统文化学习与自我探索参考，不构成现实决策或专业建议。"

PREFIX_RE = re.compile(r"这个问题是新知识\s*[,，]\s*请记住它以便将来使用\s*[。.]?\s*")
WHITESPACE_RE = re.compile(r"[ \t\r\f\v]+")

CORE_CATEGORIES = ("五行", "阴阳", "天干地支", "八卦", "易学基础")
ALLOWED_CATEGORIES = (*CORE_CATEGORIES, "传统文化", "使用边界")

CATEGORY_TERMS: dict[str, tuple[str, ...]] = {
    "五行": (
        "五行",
        "木火土金水",
        "金木水火土",
        "相生",
        "相克",
        "生克",
        "木气",
        "火气",
        "土气",
        "金气",
        "水气",
    ),
    "阴阳": ("阴阳", "阳气", "阴气", "阴阳平衡", "阴阳变化"),
    "天干地支": (
        "天干",
        "地支",
        "干支",
        "甲乙丙丁",
        "戊己庚辛",
        "壬癸",
        "子丑寅卯",
        "辰巳午未",
        "申酉戌亥",
    ),
    "八卦": ("八卦", "乾卦", "坤卦", "震卦", "巽卦", "坎卦", "离卦", "艮卦", "兑卦"),
    "易学基础": ("易经", "周易", "易学", "卦象", "爻辞", "太极", "两仪", "四象"),
    "使用边界": ("使用边界", "理性看待", "参考", "自我探索", "专业建议"),
    "传统文化": ("传统文化", "民俗", "象征", "天道", "地道", "人性", "古人", "文化解释"),
}

SCENE_RULES: tuple[tuple[str, tuple[str, ...]], ...] = (
    ("wuxing_foundation", CATEGORY_TERMS["五行"]),
    ("yinyang_foundation", CATEGORY_TERMS["阴阳"]),
    ("ganzhi_foundation", CATEGORY_TERMS["天干地支"]),
    ("bagua_foundation", CATEGORY_TERMS["八卦"]),
    ("yixue_foundation", CATEGORY_TERMS["易学基础"]),
    ("usage_boundary", CATEGORY_TERMS["使用边界"]),
    ("traditional_culture", CATEGORY_TERMS["传统文化"]),
)

NAMING_TERMS = ("取名", "起名", "名字", "姓名学", "姓名", "改名")

FORBIDDEN_GROUPS: dict[str, tuple[str, ...]] = {
    "tarot_or_divination": ("塔罗", "tarot", "英文占卜"),
    "face_reading": ("面相", "face reading"),
    "book_metadata": ("isbn", "出版社", "出版工作", "版权页", "印刷", "印数", "开本", "书稿"),
    "book_or_source_specific": (
        "作者",
        "文中",
        "该书",
        "本书",
        "书中",
        "书籍",
        "论证",
        "质疑",
        "提到",
        "记载",
        "引用",
        "原文",
        "根据文本",
        "文本分析",
        "证据支持",
        "第十章",
        "该章节",
        "后人补充",
    ),
    "investment": ("投资", "收益确定"),
    "health": ("疾病", "疾病预测"),
    "marriage": ("婚姻决策", "结婚", "婚姻", "嫁娶"),
    "ritual_or_remedy": ("化解", "开光", "符咒", "改命", "避灾", "保证转运", "付费改运"),
    "military_or_conflict": ("战争", "用兵", "军队", "兵家"),
    "behavior_or_ethics_advice": ("禁欲", "欲望", "价值观", "自我毁灭", "暴力威慑", "利益驱动"),
    "governance_or_ethics_case": (
        "政治",
        "治理",
        "社会结构",
        "等级不能废除",
        "礼仪",
        "君子",
        "小人",
        "恶积",
        "不可掩",
    ),
    "personal_consultation": (
        "帮我",
        "我是",
        "出生的",
        "八字简析",
        "八字四柱",
        "公历日期",
        "缺时辰",
        "请提供具体卦象",
        "事业",
        "感情",
        "健康",
        "专业解读",
        "解卦需结合",
        "测算",
        "算一下",
        "看看八字",
    ),
    "advanced_yijing_exegesis": (
        "爻辞",
        "初九",
        "九二",
        "九三",
        "九四",
        "九五",
        "上九",
        "初六",
        "六二",
        "六三",
        "六四",
        "六五",
        "上六",
        "爻位",
        "变爻",
        "卦序",
        "序卦传",
        "杂卦传",
        "象传解释",
        "屯卦",
        "蒙卦",
        "需卦",
        "讼卦",
        "师卦",
        "比卦",
        "小畜卦",
        "履卦",
        "泰卦",
        "否卦",
        "同人卦",
        "大有卦",
        "谦卦",
        "豫卦",
        "随卦",
        "蛊卦",
        "临卦",
        "观卦",
        "噬嗑卦",
        "贲卦",
        "剥卦",
        "复卦",
        "无妄卦",
        "大畜卦",
        "颐卦",
        "大过卦",
        "咸卦",
        "恒卦",
        "遯卦",
        "大壮卦",
        "晋卦",
        "明夷卦",
        "家人卦",
        "睽卦",
        "蹇卦",
        "解卦",
        "损卦",
        "益卦",
        "夬卦",
        "姤卦",
        "萃卦",
        "升卦",
        "困卦",
        "井卦",
        "革卦",
        "鼎卦",
        "渐卦",
        "归妹卦",
        "丰卦",
        "旅卦",
        "涣卦",
        "节卦",
        "中孚卦",
        "小过卦",
        "既济卦",
        "未济卦",
    ),
}

REVIEW_RISK_TERMS = (
    "精准预测",
    "预测",
    "决定着",
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
    "寿命",
    "命主",
    "命盘",
)

CATEGORY_SEARCH_TERMS: dict[str, tuple[str, ...]] = {
    "五行": ("五行", "金", "木", "水", "火", "土", "相生", "相克"),
    "阴阳": ("阴阳", "阴", "阳"),
    "天干地支": ("天干", "地支", "干支", "甲乙丙丁", "子丑寅卯"),
    "天干": ("天干", "十干", "甲乙丙丁", "戊己庚辛", "壬癸"),
    "地支": ("地支", "十二支", "子丑寅卯", "辰巳午未", "申酉戌亥"),
    "八卦": ("八卦", "乾", "坤", "震", "巽", "坎", "离", "艮", "兑"),
    "易学基础": ("易学", "易经", "周易", "卦", "爻"),
    "传统文化": ("传统文化", "民俗", "象征"),
    "使用边界": ("使用边界", "参考", "自我探索"),
}


def load_json(path: pathlib.Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def load_jsonl(path: pathlib.Path) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        if not line.strip():
            continue
        item = json.loads(line)
        if not isinstance(item, dict):
            raise ValueError(f"Expected object in {path} line {line_number}")
        rows.append(item)
    return rows


def write_json(path: pathlib.Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def collapse_spaces(text: str) -> str:
    return WHITESPACE_RE.sub(" ", text).strip()


def strip_title_prefix(text: Any) -> tuple[str, bool]:
    value = "" if text is None else str(text)
    stripped = PREFIX_RE.sub("", value)
    return stripped.strip(), stripped != value


def clean_text(text: Any, preserve_lines: bool = False) -> tuple[str, bool]:
    value, removed_prefix = strip_title_prefix(text)
    value = value.replace("\u3000", " ")
    value = re.sub(r"#{1,6}\s*", "", value)
    value = re.sub(r"\*{1,3}([^*\n]+)\*{1,3}", r"\1", value)
    value = re.sub(r"\n?\s*-{3,}\s*\n?", "\n", value)
    if preserve_lines:
        lines = [collapse_spaces(line) for line in value.splitlines()]
        value = "\n".join(line for line in lines if line)
    else:
        value = collapse_spaces(value)
    return value.strip(), removed_prefix


def truncate_text(text: str, limit: int) -> str:
    value = collapse_spaces(text)
    if len(value) <= limit:
        return value
    return value[: limit - 1].rstrip("，。；、,. ") + "…"


def normalized_search_text(*parts: Any) -> str:
    return " ".join(collapse_spaces(str(part)).lower() for part in parts if part is not None)


def find_terms(text: str, terms: tuple[str, ...]) -> list[str]:
    text_lower = text.lower()
    matches: list[str] = []
    for term in terms:
        needle = term.lower()
        if needle in text_lower:
            matches.append(term)
    return matches


def find_forbidden_reasons(text: str) -> dict[str, list[str]]:
    reasons: dict[str, list[str]] = {}
    for group, terms in FORBIDDEN_GROUPS.items():
        matches = find_terms(text, terms)
        if matches:
            reasons[group] = matches
    return reasons


def term_hit_count(text: str, terms: tuple[str, ...]) -> int:
    return len(find_terms(text, terms))


def count_contained(text: str, terms: tuple[str, ...]) -> int:
    return sum(1 for term in terms if term in text)


def category_scores(text: str) -> dict[str, int]:
    stems = ("甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸")
    branches = ("子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥")
    elements = ("木", "火", "土", "金", "水")
    trigrams = ("乾", "坤", "震", "巽", "坎", "离", "艮", "兑")

    scores = {
        "五行": 0,
        "阴阳": 0,
        "天干地支": 0,
        "八卦": 0,
        "易学基础": 0,
        "传统文化": 0,
        "使用边界": 0,
    }

    if "五行" in text:
        scores["五行"] += 5
    scores["五行"] += 2 * term_hit_count(text, ("相生", "相克", "生克", "金木水火土", "木火土金水"))
    element_count = count_contained(text, elements)
    if element_count >= 2:
        scores["五行"] += element_count

    if "阴阳" in text:
        scores["阴阳"] += 5
    if "阴" in text and "阳" in text:
        scores["阴阳"] += 2
    scores["阴阳"] += term_hit_count(text, ("阴阳平衡", "阴阳变化", "阳气", "阴气"))

    if any(term in text for term in ("天干", "地支", "干支")):
        scores["天干地支"] += 5
    stem_count = count_contained(text, stems)
    branch_count = count_contained(text, branches)
    if stem_count >= 2:
        scores["天干地支"] += stem_count
    if branch_count >= 2:
        scores["天干地支"] += branch_count

    if "八卦" in text:
        scores["八卦"] += 5
    trigram_count = count_contained(text, trigrams)
    if trigram_count >= 2:
        scores["八卦"] += trigram_count
    scores["八卦"] += term_hit_count(text, ("取象", "卦象"))

    if any(term in text for term in ("易学", "易经", "周易")):
        scores["易学基础"] += 4
    scores["易学基础"] += term_hit_count(text, ("太极", "两仪", "四象", "卦象", "蓍草"))

    if term_hit_count(text, ("使用边界", "仅供参考", "不构成", "理性看待", "自我探索", "参考性")) > 0:
        scores["使用边界"] += 5
    if term_hit_count(text, CATEGORY_TERMS["传统文化"]) > 0:
        scores["传统文化"] += 3

    return scores


def infer_category(candidate_category: str, text: str) -> str | None:
    scores = category_scores(text)
    if candidate_category in scores:
        scores[candidate_category] += 3

    best_category = max(scores, key=scores.get)
    best_score = scores[best_category]
    if best_category in CORE_CATEGORIES and best_score >= 4:
        return best_category
    if best_category == "使用边界" and best_score >= 5:
        return best_category
    if best_category == "传统文化" and best_score >= 4:
        return best_category
    return None


def infer_scenes(category: str, text: str) -> list[str]:
    scenes: list[str] = ["knowledge_library", "rag_retrieval"]
    for scene, terms in SCENE_RULES:
        if scene not in scenes and (category_terms_match(category, scene) or term_hit_count(text, terms) > 0):
            scenes.append(scene)
    if "usage_boundary" not in scenes:
        scenes.append("usage_boundary")
    return scenes


def category_terms_match(category: str, scene: str) -> bool:
    return {
        "五行": "wuxing_foundation",
        "阴阳": "yinyang_foundation",
        "天干地支": "ganzhi_foundation",
        "八卦": "bagua_foundation",
        "易学基础": "yixue_foundation",
        "使用边界": "usage_boundary",
        "传统文化": "traditional_culture",
    }.get(category) == scene


def clean_tags(raw_tags: list[Any], category: str, text: str) -> list[str]:
    tags: list[str] = []
    for raw_tag in raw_tags:
        tag, _ = clean_text(raw_tag)
        if not tag:
            continue
        if find_terms(tag, NAMING_TERMS):
            continue
        if find_forbidden_reasons(tag):
            continue
        if tag not in tags:
            tags.append(tag)

    if category not in tags:
        tags.insert(0, category)
    for tag, terms in CATEGORY_TERMS.items():
        if tag not in tags and term_hit_count(text, terms) > 0:
            tags.append(tag)
    if "传统文化" not in tags:
        tags.append("传统文化")
    return tags[:6]


def quality_score(category: str, question: str, response: str, tags: list[str], scenes: list[str], text: str) -> int:
    score = 45
    if category in CORE_CATEGORIES:
        score += 20
    elif category == "使用边界":
        score += 15
    elif category == "传统文化":
        score += 12

    response_length = len(response)
    if 40 <= response_length <= 700:
        score += 12
    elif 24 <= response_length < 40:
        score += 6
    elif response_length > 700:
        score += 5
    else:
        score -= 18

    if 4 <= len(question) <= 90:
        score += 4
    if len(tags) >= 3:
        score += 4
    if len(scenes) >= 3:
        score += 3
    if any(term_hit_count(text, terms) > 0 for terms in CATEGORY_TERMS.values()):
        score += 5
    if "使用边界" in BOUNDARY_TEXT:
        score += 4

    if response_length > 1000:
        score -= 8
    if "仅供参考" in text or "不构成" in text:
        score += 2

    return max(0, min(95, score))


def sanitized_source(source: Any) -> str:
    value = collapse_spaces("" if source is None else str(source))
    value = value.replace("; dry-run candidate", "; filtered DestinyScope knowledge build")
    return value


def fts_terms(record: dict[str, Any]) -> str:
    terms: list[str] = []
    for value in (
        record.get("category"),
        *(record.get("tags") or []),
        *(record.get("scenes") or []),
        *CATEGORY_SEARCH_TERMS.get(str(record.get("category")), ()),
    ):
        if value and str(value) not in terms:
            terms.append(str(value))
    return " ".join(terms)


def official_article(
    candidate: dict[str, Any],
    category: str,
    title: str,
    question: str,
    response: str,
    tags: list[str],
    scenes: list[str],
    score: int,
) -> dict[str, Any]:
    summary = truncate_text(response, 120)
    body = f"参考解读：{response}"
    return {
        "id": candidate["id"],
        "category": category,
        "title": title,
        "summary": summary,
        "body": body,
        "tags": tags,
        "scenes": scenes,
        "riskLevel": RISK_LEVEL_SAFE,
        "qualityScore": score,
        "usageBoundary": BOUNDARY_TEXT,
        "source": sanitized_source(candidate.get("source")),
        "version": SOURCE_VERSION,
    }


def official_chunk(article: dict[str, Any], question: str, response: str) -> dict[str, Any]:
    core_text = truncate_text(f"参考解读：{response}", 420)
    return {
        "id": f"{article['id']}_chunk_001",
        "articleId": article["id"],
        "category": article["category"],
        "title": article["title"],
        "text": core_text,
        "tags": article["tags"],
        "scenes": article["scenes"],
        "riskLevel": article["riskLevel"],
        "qualityScore": article["qualityScore"],
        "usageBoundary": BOUNDARY_TEXT,
        "source": article["source"],
        "version": article["version"],
    }


def curated_chunk(article: dict[str, Any]) -> dict[str, Any]:
    text = truncate_text(article["body"], 420)
    return {
        "id": f"{article['id']}_chunk_001",
        "articleId": article["id"],
        "category": article["category"],
        "title": article["title"],
        "text": text,
        "tags": article["tags"],
        "scenes": article["scenes"],
        "riskLevel": article["riskLevel"],
        "qualityScore": article["qualityScore"],
        "usageBoundary": article["usageBoundary"],
        "source": article["source"],
        "sourceRefs": article.get("sourceRefs", []),
        "version": article["version"],
    }


def reserved_naming_record(
    candidate: dict[str, Any],
    title: str,
    question: str,
    response: str,
    tags: list[str],
    matched_terms: list[str],
    additional_reasons: dict[str, list[str]],
) -> dict[str, Any]:
    return {
        "id": candidate["id"],
        "category": candidate.get("category", "命名保留"),
        "title": title,
        "summary": truncate_text(response, 120),
        "body": f"参考解读：{response}",
        "tags": tags,
        "riskLevel": "reserved",
        "qualityScore": 0,
        "reservedReason": "future_naming_content",
        "matchedNamingTerms": matched_terms,
        "additionalBlockedReasons": additional_reasons,
        "source": sanitized_source(candidate.get("source")),
        "version": SOURCE_VERSION,
        "excludedFromOfficialKnowledge": True,
    }


def build_records(
    cleaned_rows: list[dict[str, Any]],
    candidate_articles: list[dict[str, Any]],
    candidate_chunks: list[dict[str, Any]],
) -> tuple[list[dict[str, Any]], list[dict[str, Any]], list[dict[str, Any]], dict[str, Any]]:
    if not (len(cleaned_rows) == len(candidate_articles) == len(candidate_chunks)):
        raise ValueError(
            "Input count mismatch: "
            f"cleaned={len(cleaned_rows)}, articles={len(candidate_articles)}, chunks={len(candidate_chunks)}"
        )

    articles: list[dict[str, Any]] = []
    chunks: list[dict[str, Any]] = []
    reserved_naming: list[dict[str, Any]] = []
    counters: collections.Counter[str] = collections.Counter()
    prefix_removed_rows = 0
    seen_pairs: set[tuple[str, str]] = set()

    for row, candidate, _candidate_chunk in zip(cleaned_rows, candidate_articles, candidate_chunks):
        raw_title = candidate.get("title") or row.get("question") or "传统文化问答"
        title, title_prefix_removed = clean_text(raw_title)
        question, question_prefix_removed = clean_text(row.get("question"))
        response, response_prefix_removed = clean_text(row.get("response"), preserve_lines=True)
        response = response.replace("\n", " ")
        response = collapse_spaces(response)

        if title_prefix_removed or question_prefix_removed or response_prefix_removed:
            prefix_removed_rows += 1

        if not title:
            title = truncate_text(question, 34) or "传统文化问答"

        text = normalized_search_text(title, question, response)
        pair = (question, response)

        if not question or not response:
            counters["invalid_blank_question_or_response"] += 1
            continue
        if pair in seen_pairs:
            counters["duplicate_after_prefix_cleanup"] += 1
            continue
        seen_pairs.add(pair)

        naming_terms = find_terms(text, NAMING_TERMS)
        forbidden_reasons = find_forbidden_reasons(text)
        raw_tags = candidate.get("tags") if isinstance(candidate.get("tags"), list) else []

        if naming_terms:
            counters["reserved_future_naming"] += 1
            for term in naming_terms:
                counters[f"reserved_future_naming:{term}"] += 1
            reserved_naming.append(
                reserved_naming_record(
                    candidate,
                    title,
                    question,
                    response,
                    clean_tags(raw_tags, candidate.get("category", "命名保留"), text),
                    naming_terms,
                    forbidden_reasons,
                )
            )
            continue

        if forbidden_reasons:
            for reason in forbidden_reasons:
                counters[f"deleted:{reason}"] += 1
            continue

        review_terms = find_terms(text, REVIEW_RISK_TERMS)
        if review_terms:
            counters["deleted:review_risk_terms"] += 1
            for term in review_terms:
                counters[f"deleted:review_risk_terms:{term}"] += 1
            continue

        category = infer_category(str(candidate.get("category", "")), text)
        if category is None:
            counters["deleted:out_of_scope"] += 1
            continue

        scenes = infer_scenes(category, text)
        tags = clean_tags(raw_tags, category, text)
        score = quality_score(category, question, response, tags, scenes, text)
        if score < QUALITY_THRESHOLD:
            counters["deleted:quality_below_threshold"] += 1
            continue

        article = official_article(candidate, category, title, question, response, tags, scenes, score)
        chunk = official_chunk(article, question, response)
        articles.append(article)
        chunks.append(chunk)

    stats = {
        "prefixRemovedRows": prefix_removed_rows,
        "filterCounters": dict(counters),
        "categoryCounts": dict(collections.Counter(article["category"] for article in articles)),
        "sceneCounts": dict(collections.Counter(scene for article in articles for scene in article["scenes"])),
        "quality": {
            "min": min((article["qualityScore"] for article in articles), default=0),
            "max": max((article["qualityScore"] for article in articles), default=0),
            "average": round(
                sum(article["qualityScore"] for article in articles) / len(articles),
                2,
            )
            if articles
            else 0,
        },
    }
    return articles, chunks, reserved_naming, stats


def merge_curated_supplement(
    articles: list[dict[str, Any]],
    chunks: list[dict[str, Any]],
    stats: dict[str, Any],
) -> tuple[list[dict[str, Any]], list[dict[str, Any]], dict[str, Any]]:
    supplement_articles = curated_supplement_articles(BOUNDARY_TEXT, SOURCE_VERSION)
    existing_ids = {article["id"] for article in articles}
    duplicate_ids = sorted(article["id"] for article in supplement_articles if article["id"] in existing_ids)
    if duplicate_ids:
        raise ValueError(f"Duplicate curated supplement article IDs: {duplicate_ids[:5]}")

    supplement_chunks = [curated_chunk(article) for article in supplement_articles]
    merged_articles = [*articles, *supplement_articles]
    merged_chunks = [*chunks, *supplement_chunks]
    stats = {
        **stats,
        "curatedSupplementArticles": len(supplement_articles),
        "curatedSupplementChunks": len(supplement_chunks),
        "curatedSupplementCategoryCounts": dict(collections.Counter(article["category"] for article in supplement_articles)),
        "curatedSupplementSources": SOURCE_REFS,
        "categoryCounts": dict(collections.Counter(article["category"] for article in merged_articles)),
        "sceneCounts": dict(collections.Counter(scene for article in merged_articles for scene in article["scenes"])),
        "quality": {
            "min": min((article["qualityScore"] for article in merged_articles), default=0),
            "max": max((article["qualityScore"] for article in merged_articles), default=0),
            "average": round(
                sum(article["qualityScore"] for article in merged_articles) / len(merged_articles),
                2,
            )
            if merged_articles
            else 0,
        },
    }
    return merged_articles, merged_chunks, stats


def create_sqlite(path: pathlib.Path, articles: list[dict[str, Any]], chunks: list[dict[str, Any]], manifest: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp_path = path.with_suffix(".sqlite.tmp")
    if tmp_path.exists():
        tmp_path.unlink()

    connection = sqlite3.connect(tmp_path)
    try:
        connection.execute("PRAGMA journal_mode = OFF")
        connection.execute("PRAGMA synchronous = OFF")
        connection.executescript(
            """
            CREATE TABLE metadata (
                key TEXT PRIMARY KEY,
                value TEXT NOT NULL
            );

            CREATE TABLE articles (
                id TEXT PRIMARY KEY,
                category TEXT NOT NULL,
                title TEXT NOT NULL,
                summary TEXT NOT NULL,
                body TEXT NOT NULL,
                tags_json TEXT NOT NULL,
                scenes_json TEXT NOT NULL,
                risk_level TEXT NOT NULL,
                quality_score INTEGER NOT NULL,
                usage_boundary TEXT NOT NULL,
                source TEXT,
                version TEXT NOT NULL
            );

            CREATE TABLE rag_chunks (
                id TEXT PRIMARY KEY,
                article_id TEXT NOT NULL,
                category TEXT NOT NULL,
                title TEXT NOT NULL,
                text TEXT NOT NULL,
                tags_json TEXT NOT NULL,
                scenes_json TEXT NOT NULL,
                risk_level TEXT NOT NULL,
                quality_score INTEGER NOT NULL,
                usage_boundary TEXT NOT NULL,
                source TEXT,
                version TEXT NOT NULL,
                FOREIGN KEY(article_id) REFERENCES articles(id)
            );

            CREATE VIRTUAL TABLE articles_fts USING fts5(
                article_id UNINDEXED,
                category,
                title,
                summary,
                body,
                tags,
                scenes,
                tokenize = 'unicode61'
            );

            CREATE VIRTUAL TABLE rag_chunks_fts USING fts5(
                chunk_id UNINDEXED,
                article_id UNINDEXED,
                category,
                title,
                text,
                tags,
                scenes,
                tokenize = 'unicode61'
            );
            """
        )

        connection.execute("INSERT INTO metadata(key, value) VALUES (?, ?)", ("manifest", json.dumps(manifest, ensure_ascii=False)))

        for article in articles:
            tags = fts_terms(article)
            scenes = " ".join(article["scenes"])
            connection.execute(
                """
                INSERT INTO articles(
                    id, category, title, summary, body, tags_json, scenes_json, risk_level,
                    quality_score, usage_boundary, source, version
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    article["id"],
                    article["category"],
                    article["title"],
                    article["summary"],
                    article["body"],
                    json.dumps(article["tags"], ensure_ascii=False),
                    json.dumps(article["scenes"], ensure_ascii=False),
                    article["riskLevel"],
                    article["qualityScore"],
                    article["usageBoundary"],
                    article["source"],
                    article["version"],
                ),
            )
            connection.execute(
                """
                INSERT INTO articles_fts(article_id, category, title, summary, body, tags, scenes)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """,
                (article["id"], article["category"], article["title"], article["summary"], article["body"], tags, scenes),
            )

        for chunk in chunks:
            tags = fts_terms(chunk)
            scenes = " ".join(chunk["scenes"])
            connection.execute(
                """
                INSERT INTO rag_chunks(
                    id, article_id, category, title, text, tags_json, scenes_json, risk_level,
                    quality_score, usage_boundary, source, version
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    chunk["id"],
                    chunk["articleId"],
                    chunk["category"],
                    chunk["title"],
                    chunk["text"],
                    json.dumps(chunk["tags"], ensure_ascii=False),
                    json.dumps(chunk["scenes"], ensure_ascii=False),
                    chunk["riskLevel"],
                    chunk["qualityScore"],
                    chunk["usageBoundary"],
                    chunk["source"],
                    chunk["version"],
                ),
            )
            connection.execute(
                """
                INSERT INTO rag_chunks_fts(chunk_id, article_id, category, title, text, tags, scenes)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """,
                (chunk["id"], chunk["articleId"], chunk["category"], chunk["title"], chunk["text"], tags, scenes),
            )

        connection.commit()
    finally:
        connection.close()

    if path.exists():
        path.unlink()
    tmp_path.replace(path)


def sqlite_query_counts(path: pathlib.Path, terms: tuple[str, ...]) -> dict[str, int]:
    counts: dict[str, int] = {}
    connection = sqlite3.connect(path)
    try:
        for term in terms:
            counts[term] = connection.execute(
                "SELECT COUNT(*) FROM rag_chunks_fts WHERE rag_chunks_fts MATCH ?",
                (term,),
            ).fetchone()[0]
    finally:
        connection.close()
    return counts


def update_sqlite_manifest(path: pathlib.Path, manifest: dict[str, Any]) -> None:
    connection = sqlite3.connect(path)
    try:
        connection.execute(
            "UPDATE metadata SET value = ? WHERE key = ?",
            (json.dumps(manifest, ensure_ascii=False), "manifest"),
        )
        connection.commit()
    finally:
        connection.close()


def scan_official_outputs(articles: list[dict[str, Any]], chunks: list[dict[str, Any]]) -> dict[str, Any]:
    forbidden_terms = (
        "这个问题是新知识",
        "tarot",
        "face reading",
        "ISBN",
        "isbn",
        "出版社",
        "印刷",
        "投资",
        "疾病",
        "婚姻决策",
        "结婚",
        "化解",
        "开光",
        "取名",
        "起名",
        "名字",
        "姓名学",
    )
    text_payload = json.dumps({"articles": articles, "chunks": chunks}, ensure_ascii=False)
    forbidden_hits = [term for term in forbidden_terms if term in text_payload]
    chunk_metadata_ok = all(
        chunk.get("scenes")
        and chunk.get("riskLevel") == RISK_LEVEL_SAFE
        and isinstance(chunk.get("qualityScore"), int)
        and chunk.get("qualityScore", 0) >= QUALITY_THRESHOLD
        for chunk in chunks
    )
    article_boundary_field_ok = all(article.get("usageBoundary") for article in articles)
    chunk_boundary_field_ok = all(chunk.get("usageBoundary") for chunk in chunks)
    article_body_no_inline_boundary = all("使用边界：" not in article.get("body", "") for article in articles)
    chunk_text_no_inline_boundary = all("使用边界：" not in chunk.get("text", "") for chunk in chunks)
    article_body_no_question_prefix = all("问题：" not in article.get("body", "") for article in articles)
    chunk_text_no_question_prefix = all("问题：" not in chunk.get("text", "") for chunk in chunks)
    chunk_boundary_ok = chunk_boundary_field_ok and chunk_text_no_inline_boundary
    article_risk_ok = all(article.get("riskLevel") == RISK_LEVEL_SAFE for article in articles)
    return {
        "forbiddenHits": forbidden_hits,
        "chunkMetadataOK": chunk_metadata_ok,
        "chunkBoundaryOK": chunk_boundary_ok,
        "articleBoundaryFieldOK": article_boundary_field_ok,
        "chunkBoundaryFieldOK": chunk_boundary_field_ok,
        "articleBodyNoInlineBoundary": article_body_no_inline_boundary,
        "chunkTextNoInlineBoundary": chunk_text_no_inline_boundary,
        "articleBodyNoQuestionPrefix": article_body_no_question_prefix,
        "chunkTextNoQuestionPrefix": chunk_text_no_question_prefix,
        "articleRiskOK": article_risk_ok,
        "passed": (
            not forbidden_hits
            and chunk_metadata_ok
            and article_boundary_field_ok
            and chunk_boundary_ok
            and article_body_no_inline_boundary
            and chunk_text_no_inline_boundary
            and article_body_no_question_prefix
            and chunk_text_no_question_prefix
            and article_risk_ok
        ),
    }


def top_filter_reasons(filter_counters: dict[str, int], limit: int = 12) -> list[dict[str, Any]]:
    rows = [
        {"reason": reason, "count": count}
        for reason, count in filter_counters.items()
        if reason.startswith("deleted:") or reason == "reserved_future_naming"
    ]
    rows.sort(key=lambda item: item["count"], reverse=True)
    return rows[:limit]


def build_report(manifest: dict[str, Any]) -> str:
    def table(counter: dict[str, int]) -> str:
        if not counter:
            return "| 项目 | 数量 |\n| --- | --- |\n"
        lines = ["| 项目 | 数量 |", "| --- | ---: |"]
        for key, value in sorted(counter.items(), key=lambda item: item[1], reverse=True):
            lines.append(f"| {key} | {value} |")
        return "\n".join(lines) + "\n"

    top_reasons = manifest["filters"]["deletedReasonTopN"]
    reason_lines = ["| 删除原因 | 数量 |", "| --- | ---: |"]
    for item in top_reasons:
        reason_lines.append(f"| {item['reason']} | {item['count']} |")

    validation = manifest["validation"]
    sqlite_counts = manifest["sqlite"]["sampleQueryCounts"]

    publication = manifest.get("publication", {})
    official_status = (
        f"已同步到 `{publication.get('officialArticles')}` / `{publication.get('officialChunks')}`"
        if publication.get("publishedOfficialResources")
        else "未覆盖 App 当前默认 JSON 资源"
    )

    return f"""# Destiny Knowledge Build Report

## 构建结论

- 生成时间：{manifest["generatedAt"]}
- 新知识库 JSON：{manifest["outputs"]["articles"]} articles
- 新 RAG JSON：{manifest["outputs"]["chunks"]} chunks
- 命名类保留：{manifest["outputs"]["reservedFutureNaming"]} records
- SQLite：`{manifest["files"]["sqlite"]}`
- App 默认 JSON 资源：{official_status}
- 验收自检：{"Pass" if validation["passed"] else "Fail"}

## 输入数量

| 输入 | 数量 |
| --- | ---: |
| sourceRows | {manifest["inputs"]["sourceRows"]} |
| cleanedRows | {manifest["inputs"]["cleanedRows"]} |
| candidateArticles | {manifest["inputs"]["candidateArticles"]} |
| candidateChunks | {manifest["inputs"]["candidateChunks"]} |
| curatedSupplementArticles | {manifest["inputs"]["curatedSupplementArticles"]} |
| curatedSupplementChunks | {manifest["inputs"]["curatedSupplementChunks"]} |
| auditRiskRows | {manifest["inputs"]["auditRiskRows"]} |

## 过滤数量

| 项目 | 数量 |
| --- | ---: |
| 清理标题前缀 | {manifest["filters"]["prefixRemovedRows"]} |
| 命名类保留 | {manifest["outputs"]["reservedFutureNaming"]} |
| wuxingbagua 删除或未入库 | {manifest["outputs"]["filteredOut"]} |
| wuxingbagua 正式保留 | {manifest["outputs"]["wuxingbaguaArticles"]} |
| curated supplement 正式保留 | {manifest["outputs"]["curatedSupplementArticles"]} |
| 正式保留 | {manifest["outputs"]["articles"]} |

## 各分类数量

{table(manifest["outputs"]["categoryCounts"])}
## 各场景数量

{table(manifest["outputs"]["sceneCounts"])}
## 被删除原因 TopN

{chr(10).join(reason_lines)}

## SQLite / FTS5

- 普通表：`metadata`、`articles`、`rag_chunks`
- FTS5 表：`articles_fts`、`rag_chunks_fts`
- 示例检索命中：

| 关键词 | chunks |
| --- | ---: |
{chr(10).join(f"| {term} | {count} |" for term, count in sqlite_counts.items())}

## 自检结果

| 检查项 | 结果 |
| --- | --- |
| 不含“这个问题是新知识”前缀 | {"Pass" if "这个问题是新知识" not in validation["forbiddenHits"] else "Fail"} |
| 不含正式禁用词 | {"Pass" if not validation["forbiddenHits"] else "Fail"} |
| chunk 均有 scenes / riskLevel / qualityScore | {"Pass" if validation["chunkMetadataOK"] else "Fail"} |
| article / chunk 均保留 usageBoundary 字段 | {"Pass" if validation["articleBoundaryFieldOK"] and validation["chunkBoundaryFieldOK"] else "Fail"} |
| article body 不内联使用边界 | {"Pass" if validation["articleBodyNoInlineBoundary"] else "Fail"} |
| chunk text 不内联使用边界 | {"Pass" if validation["chunkTextNoInlineBoundary"] else "Fail"} |
| article body 不含问题前缀 | {"Pass" if validation["articleBodyNoQuestionPrefix"] else "Fail"} |
| chunk text 不含问题前缀 | {"Pass" if validation["chunkTextNoQuestionPrefix"] else "Fail"} |
| article 均为 safe | {"Pass" if validation["articleRiskOK"] else "Fail"} |

## 说明

- App 默认读取 `destiny_knowledge_articles.json` 和 `destiny_rag_chunks.json`；不再额外生成旧名副本。
- `reserved_future_naming.json` 仅用于未来命名方向评估，默认生成到 `.build/knowledge_import`，不进入 App 资源、正式知识库和 SQLite。
- 数据源审计记录显示原始数据集 license 未声明；正式分发前仍建议保留人工 license 复核记录。
- 所有正式 article / chunk 均保留 `usageBoundary` 字段；body 与 RAG text 不再内联重复边界。
"""


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cleaned", type=pathlib.Path, default=INPUT_CLEANED)
    parser.add_argument("--candidate-articles", type=pathlib.Path, default=INPUT_ARTICLES)
    parser.add_argument("--candidate-chunks", type=pathlib.Path, default=INPUT_CHUNKS)
    parser.add_argument("--cleaning-summary", type=pathlib.Path, default=INPUT_CLEANING_SUMMARY)
    parser.add_argument("--audit-summary", type=pathlib.Path, default=INPUT_AUDIT_SUMMARY)
    parser.add_argument("--articles-output", type=pathlib.Path, default=OUTPUT_ARTICLES)
    parser.add_argument("--chunks-output", type=pathlib.Path, default=OUTPUT_CHUNKS)
    parser.add_argument("--official-articles-output", type=pathlib.Path, default=OFFICIAL_ARTICLES)
    parser.add_argument("--official-chunks-output", type=pathlib.Path, default=OFFICIAL_CHUNKS)
    parser.add_argument("--reserved-naming-output", type=pathlib.Path, default=OUTPUT_RESERVED_NAMING)
    parser.add_argument("--manifest-output", type=pathlib.Path, default=OUTPUT_MANIFEST)
    parser.add_argument("--sqlite-output", type=pathlib.Path, default=OUTPUT_SQLITE)
    parser.add_argument("--report-output", type=pathlib.Path, default=OUTPUT_REPORT)
    parser.add_argument(
        "--publish-official-resources",
        action="store_true",
        help="Keep compatibility with older build commands; App default resources are the destiny_* outputs.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    input_paths = (
        args.cleaned,
        args.candidate_articles,
        args.candidate_chunks,
        args.cleaning_summary,
        args.audit_summary,
    )
    missing = [str(path) for path in input_paths if not path.exists()]
    if missing:
        print(f"Missing input files: {', '.join(missing)}", file=sys.stderr)
        return 2

    cleaned_rows = load_jsonl(args.cleaned)
    candidate_articles = load_json(args.candidate_articles)
    candidate_chunks = load_json(args.candidate_chunks)
    cleaning_summary = load_json(args.cleaning_summary)
    audit_summary = load_json(args.audit_summary)

    articles, chunks, reserved_naming, stats = build_records(cleaned_rows, candidate_articles, candidate_chunks)
    articles, chunks, stats = merge_curated_supplement(articles, chunks, stats)
    validation = scan_official_outputs(articles, chunks)
    wuxingbagua_article_count = len(articles) - stats["curatedSupplementArticles"]

    generated_at = dt.datetime.now(dt.timezone.utc).replace(microsecond=0).isoformat()
    manifest: dict[str, Any] = {
        "generatedAt": generated_at,
        "version": SOURCE_VERSION,
        "qualityThreshold": QUALITY_THRESHOLD,
        "riskPolicy": "Only riskLevel=safe and qualityScore>=70 records enter official outputs.",
        "inputPolicy": {
            "usedFiles": [str(path) for path in input_paths],
            "excludedFiles": [
                str(BUILD_DIR / "wuxingbagua_raw.json"),
                "Complex_CoT",
                str(BUILD_DIR / "wuxingbagua_review_queue.jsonl"),
                str(BUILD_DIR / "wuxingbagua_rejects.jsonl"),
            ],
        },
        "inputs": {
            "sourceRows": cleaning_summary.get("sourceRows", audit_summary.get("rowCount", 0)),
            "cleanedRows": len(cleaned_rows),
            "candidateArticles": len(candidate_articles),
            "candidateChunks": len(candidate_chunks),
            "curatedSupplementArticles": stats["curatedSupplementArticles"],
            "curatedSupplementChunks": stats["curatedSupplementChunks"],
            "auditRiskRows": audit_summary.get("risk", {}).get("rowsWithAnyRiskTerm", 0),
        },
        "outputs": {
            "articles": len(articles),
            "chunks": len(chunks),
            "wuxingbaguaArticles": wuxingbagua_article_count,
            "curatedSupplementArticles": stats["curatedSupplementArticles"],
            "reservedFutureNaming": len(reserved_naming),
            "filteredOut": len(cleaned_rows) - wuxingbagua_article_count - len(reserved_naming),
            "categoryCounts": stats["categoryCounts"],
            "sceneCounts": stats["sceneCounts"],
            "curatedSupplementCategoryCounts": stats["curatedSupplementCategoryCounts"],
            "quality": stats["quality"],
        },
        "filters": {
            "prefixRemovedRows": stats["prefixRemovedRows"],
            "counters": stats["filterCounters"],
            "deletedReasonTopN": top_filter_reasons(stats["filterCounters"]),
        },
        "validation": validation,
        "sqlite": {
            "tables": ["metadata", "articles", "rag_chunks", "articles_fts", "rag_chunks_fts"],
            "sampleQueryCounts": {},
        },
        "files": {
            "articles": str(args.articles_output),
            "chunks": str(args.chunks_output),
            "officialArticles": str(args.official_articles_output),
            "officialChunks": str(args.official_chunks_output),
            "reservedFutureNaming": str(args.reserved_naming_output),
            "manifest": str(args.manifest_output),
            "sqlite": str(args.sqlite_output),
            "report": str(args.report_output),
        },
        "publication": {
            "publishedOfficialResources": args.publish_official_resources,
            "officialArticles": str(args.official_articles_output),
            "officialChunks": str(args.official_chunks_output),
        },
        "source": {
            "dataset": audit_summary.get("dataset"),
            "revision": audit_summary.get("revision"),
            "license": audit_summary.get("license"),
            "curatedSupplementSources": stats["curatedSupplementSources"],
        },
    }

    write_json(args.articles_output, articles)
    write_json(args.chunks_output, chunks)
    write_json(args.reserved_naming_output, reserved_naming)
    if args.publish_official_resources:
        if not manifest["validation"]["passed"]:
            raise RuntimeError("Refusing to publish official resources because validation failed.")
        write_json(args.official_articles_output, articles)
        write_json(args.official_chunks_output, chunks)
    create_sqlite(args.sqlite_output, articles, chunks, manifest)
    manifest["sqlite"]["sampleQueryCounts"] = sqlite_query_counts(args.sqlite_output, ("五行", "阴阳", "天干", "地支", "八卦", "易学"))
    update_sqlite_manifest(args.sqlite_output, manifest)
    write_json(args.manifest_output, manifest)
    args.report_output.parent.mkdir(parents=True, exist_ok=True)
    args.report_output.write_text(build_report(manifest), encoding="utf-8")

    print(json.dumps({
        "articles": len(articles),
        "chunks": len(chunks),
        "reservedFutureNaming": len(reserved_naming),
        "filteredOut": manifest["outputs"]["filteredOut"],
        "validationPassed": manifest["validation"]["passed"],
        "publishedOfficialResources": manifest["publication"]["publishedOfficialResources"],
        "sqlite": str(args.sqlite_output),
    }, ensure_ascii=False, indent=2))
    return 0 if manifest["validation"]["passed"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
