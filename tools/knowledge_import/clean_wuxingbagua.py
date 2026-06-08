#!/usr/bin/env python3
"""Clean the audited wuxingbagua dataset into conservative dry-run files."""

from __future__ import annotations

import argparse
import json
import pathlib
import sys
from typing import Any

from audit_wuxingbagua import (
    DATASET_ID,
    DEFAULT_RAW_PATH,
    DEFAULT_REVISION,
    BUILD_DIR,
    classify_risk_terms,
    collapse_whitespace,
    load_records,
    write_json,
    write_jsonl,
)


DEFAULT_CLEANED_PATH = BUILD_DIR / "wuxingbagua_cleaned.jsonl"
DEFAULT_REVIEW_PATH = BUILD_DIR / "wuxingbagua_review_queue.jsonl"
DEFAULT_REJECTS_PATH = BUILD_DIR / "wuxingbagua_rejects.jsonl"
DEFAULT_SUMMARY_PATH = BUILD_DIR / "wuxingbagua_cleaning_summary.json"


def stable_row_id(index: int, question: str, response: str) -> str:
    import hashlib

    digest = hashlib.sha1(f"{question}\n{response}".encode("utf-8")).hexdigest()[:10]
    return f"wuxingbagua_row_{index:04d}_{digest}"


def cleaned_row(index: int, record: dict[str, Any], revision: str) -> dict[str, Any]:
    question = collapse_whitespace(record.get("Question"))
    response = collapse_whitespace(record.get("Response"))
    cot = collapse_whitespace(record.get("Complex_CoT"))
    hits = classify_risk_terms(" ".join((question, response, cot)))
    return {
        "id": stable_row_id(index, question, response),
        "sourceRow": index,
        "question": question,
        "response": response,
        "riskTerms": hits["all"],
        "blockTerms": hits["block"],
        "reviewTerms": hits["review"],
        "sourceDataset": DATASET_ID,
        "sourceRevision": revision,
    }


def clean_records(
    records: list[dict[str, Any]],
    revision: str,
    include_review_risk: bool,
    include_block_risk: bool,
) -> tuple[list[dict[str, Any]], list[dict[str, Any]], list[dict[str, Any]], dict[str, Any]]:
    cleaned: list[dict[str, Any]] = []
    review_queue: list[dict[str, Any]] = []
    rejects: list[dict[str, Any]] = []
    seen_pairs: set[tuple[str, str]] = set()

    for index, record in enumerate(records):
        row = cleaned_row(index, record, revision)
        question = row["question"]
        response = row["response"]
        pair = (question, response)

        if not question or not response:
            rejects.append({**row, "rejectReason": "blank_question_or_response"})
            continue
        if pair in seen_pairs:
            rejects.append({**row, "rejectReason": "duplicate_question_response"})
            continue
        seen_pairs.add(pair)

        has_block_risk = bool(row["blockTerms"])
        has_review_risk = bool(row["reviewTerms"])
        if has_block_risk and not include_block_risk:
            review_queue.append({**row, "reviewReason": "block_term"})
            continue
        if has_review_risk and not include_review_risk:
            review_queue.append({**row, "reviewReason": "review_term"})
            continue

        cleaned.append(row)

    summary = {
        "sourceRows": len(records),
        "cleanedRows": len(cleaned),
        "reviewQueueRows": len(review_queue),
        "rejectedRows": len(rejects),
        "includeReviewRisk": include_review_risk,
        "includeBlockRisk": include_block_risk,
        "outputPolicy": "cleaned output excludes risk terms by default; review rows require manual editing before app import",
    }
    return cleaned, review_queue, rejects, summary


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=pathlib.Path, default=DEFAULT_RAW_PATH)
    parser.add_argument("--revision", default=DEFAULT_REVISION)
    parser.add_argument("--cleaned-output", type=pathlib.Path, default=DEFAULT_CLEANED_PATH)
    parser.add_argument("--review-output", type=pathlib.Path, default=DEFAULT_REVIEW_PATH)
    parser.add_argument("--rejects-output", type=pathlib.Path, default=DEFAULT_REJECTS_PATH)
    parser.add_argument("--summary-json", type=pathlib.Path, default=DEFAULT_SUMMARY_PATH)
    parser.add_argument(
        "--include-review-risk",
        action="store_true",
        help="Keep rows with review terms in cleaned output. Default keeps them in review queue.",
    )
    parser.add_argument(
        "--include-block-risk",
        action="store_true",
        help="Keep rows with blocked terms in cleaned output. Default keeps them in review queue.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if not args.input.exists():
        print(f"Input not found: {args.input}. Run audit_wuxingbagua.py first.", file=sys.stderr)
        return 2
    records = load_records(args.input)
    cleaned, review_queue, rejects, summary = clean_records(
        records,
        revision=args.revision,
        include_review_risk=args.include_review_risk,
        include_block_risk=args.include_block_risk,
    )
    write_jsonl(args.cleaned_output, cleaned)
    write_jsonl(args.review_output, review_queue)
    write_jsonl(args.rejects_output, rejects)
    write_json(args.summary_json, summary)
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
