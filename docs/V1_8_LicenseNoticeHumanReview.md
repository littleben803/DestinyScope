# V1.8 License Notice Human Review

更新日期：2026-06-02

本文件记录 V1.8 生产候选包上线前 license / notice 证据和人工复核状态。Codex 只保存证据和记录用户确认结论，不提供法律意见。

## Evidence Summary

| Item | Evidence Saved | NOTICE File | Result |
|---|---:|---:|---|
| Qwen2.5-0.5B-Instruct | Yes | Not found at repo root | Pass |
| Qwen2.5-0.5B-Instruct-GGUF | Yes | Not found at repo root | Pass |
| llama.cpp / ggml | Yes | Not found at repo root | Pass |
| App integration copy | Yes | N/A | Pass |

## Human Confirmation Record

| Field | Status |
|---|---|
| Confirmation source | 用户人工确认 |
| Confirmation date | 2026-06-02 |
| Confirmation scope | Qwen base model, Qwen GGUF model, bundled `qwen2.5-0.5b-instruct-q4_k_m.gguf`, llama.cpp, `llama.xcframework`, App 内开源许可展示 |
| Remaining license blocker | None |
| Remaining non-license blockers | Distribution signing not completed; IPA export not completed; App Store Connect not started |

## Qwen2.5-0.5B-Instruct

| Field | Status |
|---|---|
| Repo | `https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct` |
| License metadata | `license: apache-2.0` in README front matter and HF API metadata |
| LICENSE file present | Yes: `docs/legal_evidence/qwen2_5_0_5b_instruct/LICENSE` |
| NOTICE file present | No root `NOTICE` found; HTTP 404 |
| Commercial use | Human reviewed pass |
| App redistribution | Human reviewed pass |
| Evidence path | `docs/legal_evidence/qwen2_5_0_5b_instruct/` |
| Result | Pass |
| Notes | 用户已人工确认 Qwen2.5-0.5B-Instruct 分发 license 无问题。 |

## Qwen2.5-0.5B-Instruct-GGUF

| Field | Status |
|---|---|
| Repo | `https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF` |
| Bundled file | `qwen2.5-0.5b-instruct-q4_k_m.gguf` |
| SHA-256 | `74a4da8c9fdbcd15bd1f6d01d621410d31c6fc00986f5eb687824e7b93d7a9db` |
| License metadata | `license: apache-2.0` in README front matter and HF API metadata |
| LICENSE file present | Yes: `docs/legal_evidence/qwen2_5_0_5b_instruct_gguf/LICENSE` |
| NOTICE file present | No root `NOTICE` found; HTTP 404 |
| GGUF source confirmed | Human reviewed pass |
| App redistribution | Human reviewed pass |
| Evidence path | `docs/legal_evidence/qwen2_5_0_5b_instruct_gguf/` |
| Result | Pass |
| Notes | 用户已人工确认 `qwen2.5-0.5b-instruct-q4_k_m.gguf` 可随 App Bundle 分发。Codex 没有在证据阶段下载任何 GGUF 文件。 |

## llama.cpp / ggml

| Field | Status |
|---|---|
| Repo | `https://github.com/ggml-org/llama.cpp` |
| License | MIT License |
| LICENSE file present | Yes: `docs/legal_evidence/llama_cpp/LICENSE` |
| NOTICE file present | No root `NOTICE` found; HTTP 404 |
| Framework redistribution | Human reviewed pass |
| Evidence path | `docs/legal_evidence/llama_cpp/` |
| Result | Pass |
| Notes | 用户已人工确认 llama.cpp / `llama.xcframework` 分发 license 无问题。 |

## App Integration

| Check | Status |
|---|---|
| `OpenSourceLicensesView` includes Qwen | Yes |
| `OpenSourceLicensesView` includes Qwen GGUF | Yes |
| `OpenSourceLicensesView` includes exact GGUF file and SHA-256 | Yes |
| `OpenSourceLicensesView` includes llama.cpp | Yes |
| `OpenSourceLicensesView` includes ggml / GGUF | Yes |
| `PrivacyPolicyView` explains local model processing | Yes |
| `DisclaimerView` explains local model only refines expression | Yes |
| `AppReviewNotes` mention bundled local model | Yes |
| Result | Pass |

## Remaining Items

- Remaining license blocker: none.
- Remaining non-license blockers: distribution signing not completed, IPA export not completed, App Store Connect not started.
- Final App Store Connect submission still needs final release checklist, metadata fields, screenshots and privacy URL checks.
