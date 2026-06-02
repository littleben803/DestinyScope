# V1.8 Distribution Hardening Report

更新日期：2026-06-02

## Archive Status

| Field | Value |
|---|---|
| Archive path | `/tmp/DestinyScope-V1_8-Phase3-20260602.xcarchive` |
| Archive status | Succeeded in prior Archive check |
| Archive size | `549M` |
| App size | `493M` |
| GGUF size | `469M` in archive app bundle |
| llama.framework size | `4.5M` in archive app bundle |
| Signing type | Apple Development |
| Distribution signing status | Not completed |
| IPA export status | Not completed |
| App Store Connect upload status | Not started |

## Bundle Contents

| Item | Status |
|---|---|
| `PrivacyInfo.xcprivacy` | Present in archive app bundle and previously passed `plutil` |
| `qwen2.5-0.5b-instruct-q4_k_m.gguf` | Present in archive app bundle |
| GGUF SHA-256 | `74a4da8c9fdbcd15bd1f6d01d621410d31c6fc00986f5eb687824e7b93d7a9db` |
| `llama.framework/llama` | Present in archive app bundle |
| Runtime dependency | `@rpath/llama.framework/llama` confirmed in prior archive check |

## License Review Status

| Item | Status | Result |
|---|---|---|
| License / notice human review | 用户已人工确认 | Pass |
| Qwen model license | README, LICENSE and HF API metadata saved; human reviewed | Pass |
| Qwen GGUF license | README, LICENSE and HF API metadata saved; human reviewed | Pass |
| Exact GGUF file | SHA-256 recorded; HF metadata lists exact filename; human reviewed | Pass |
| llama.cpp license | README and LICENSE saved; human reviewed | Pass |
| App legal copy | Existing Swift Legal pages include model/framework/license status | Pass |

## Remaining Blockers

- Distribution signing is not completed; current archive uses Apple Development signing.
- IPA export is not completed.
- App Store Connect upload is not started.
- Final privacy URL public access is still a manual check.
- Final screenshot set and metadata field lengths still require manual App Store Connect check.

## Recommended Next Action

Do not enter App Store Connect submission yet. Recommended next stage:

1. Confirm distribution signing identity and provisioning.
2. Export IPA from archive or regenerate a distribution archive.
3. Record IPA size and upload validation result.
4. Confirm privacy URL, screenshots and App Store metadata fields.
5. Only then decide whether to proceed to TestFlight or App Store Connect manual submission.
