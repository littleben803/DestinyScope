# V1.8 License Notice Final Checklist

更新日期：2026-06-02

## Status Summary

| Area | Evidence Saved | App Page Updated | Human Reviewed | Result | Remaining Action |
|---|---:|---:|---:|---|---|
| Qwen2.5-0.5B-Instruct | Done | Done | Done | Pass | None |
| Qwen2.5-0.5B-Instruct-GGUF | Done | Done | Done | Pass | None |
| Exact bundled GGUF file | Done | Done | Done | Pass | None |
| llama.cpp | Done | Done | Done | Pass | None |
| ggml / GGUF components | Done | Done | Done | Pass | None |
| App legal copy | Done | Done | Done | Pass | None |

## Evidence Paths

| Item | Evidence Path |
|---|---|
| Local model distribution record | `docs/legal_evidence/LOCAL_MODEL_DISTRIBUTION_RECORD.md` |
| Qwen base model | `docs/legal_evidence/qwen2_5_0_5b_instruct/` |
| Qwen GGUF model | `docs/legal_evidence/qwen2_5_0_5b_instruct_gguf/` |
| llama.cpp | `docs/legal_evidence/llama_cpp/` |
| Human review table | `docs/V1_8_LicenseNoticeHumanReview.md` |
| Distribution hardening report | `docs/V1_8_DistributionHardeningReport.md` |

## Current Bundled Items

| Item | Current Status | Required Action |
|---|---|---|
| `llama.xcframework` | Bundled framework in repo and archive; archive `llama.framework` approx `4.5M`; license human reviewed pass | No remaining license action |
| llama.cpp / ggml / GGUF | Runtime support for local GGUF inference; license human reviewed pass | No remaining license action |
| `qwen2.5-0.5b-instruct-q4_k_m.gguf` | Bundled model, `491,400,032 bytes`; archive size approx `469M`; license human reviewed pass | No remaining license action |
| Qwen2.5-0.5B-Instruct | Base model source; license human reviewed pass | No remaining license action |
| Qwen2.5-0.5B-Instruct-GGUF | Candidate GGUF source; HF metadata lists exact `q4_k_m` filename; license human reviewed pass | No remaining license action |

## Known Hash

```text
qwen2.5-0.5b-instruct-q4_k_m.gguf
SHA-256: 74a4da8c9fdbcd15bd1f6d01d621410d31c6fc00986f5eb687824e7b93d7a9db
Size: 491,400,032 bytes
```

## Saved Metadata

- Qwen base model README / LICENSE / HF API metadata saved.
- Qwen GGUF README / LICENSE / HF API metadata saved.
- llama.cpp README / LICENSE saved.
- Root `NOTICE` file was not found for Qwen base, Qwen GGUF or llama.cpp via direct root-path checks.
- 用户已人工确认 Qwen base、Qwen GGUF、bundled GGUF、llama.cpp、`llama.xcframework` 和 App 内 attribution 当前可接受。

## App In-Product Notice

Updated pages:

- `DestinyScope/UI/Legal/OpenSourceLicensesView.swift`
- `DestinyScope/Domain/Models/OpenSourceLicenseItem.swift`

Current in-app notice records that license / notice status has been human reviewed.

## Remaining Non-License Blocking Items Before App Store Submission

- Save any final license/model-card snapshots used for submission.
- Confirm no model/framework large binary is outside Git LFS.
- Confirm final App Store Connect submission accepts the current package-size tradeoff.
- Distribution signing not completed.
- IPA export not completed.
- App Store Connect not started.
