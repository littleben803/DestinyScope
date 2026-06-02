# Local Model Distribution Record

更新日期：2026-06-02

## Bundled Model

| Field | Value |
|---|---|
| Bundled model file | `qwen2.5-0.5b-instruct-q4_k_m.gguf` |
| Local source path | `DestinyScope/Resources/Models/qwen2.5-0.5b-instruct-q4_k_m.gguf` |
| Archive app bundle path | `/tmp/DestinyScope-V1_8-Phase3-20260602.xcarchive/Products/Applications/DestinyScope.app/qwen2.5-0.5b-instruct-q4_k_m.gguf` |
| Base model repo | `https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct` |
| GGUF repo | `https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF` |
| Format | GGUF |
| Quantization | `q4_K_M` |
| Local SHA-256 | `74a4da8c9fdbcd15bd1f6d01d621410d31c6fc00986f5eb687824e7b93d7a9db` |
| Archive SHA-256 | `74a4da8c9fdbcd15bd1f6d01d621410d31c6fc00986f5eb687824e7b93d7a9db` |
| Local file size | `491,400,032 bytes` |
| Archive `.app` model size | `469M` by `du -sh` |
| Archive path | `/tmp/DestinyScope-V1_8-Phase3-20260602.xcarchive` |
| Archive date | `2026-06-02 07:32:46 +0000` |
| Distribution status | Bundled in V1.8 production candidate archive; not uploaded to TestFlight or App Store |
| Qwen license review status | Human reviewed / Pass |
| Qwen GGUF license review status | Human reviewed / Pass |

## Framework

| Field | Value |
|---|---|
| Framework source path | `DestinyScope/Frameworks/llama.xcframework` |
| Archive app bundle path | `/tmp/DestinyScope-V1_8-Phase3-20260602.xcarchive/Products/Applications/DestinyScope.app/Frameworks/llama.framework` |
| Archive framework size | `4.5M` by `du -sh` |
| Runtime dependency | `@rpath/llama.framework/llama` |
| Framework status | Bundled in V1.8 production candidate archive |
| llama.cpp license review status | Human reviewed / Pass |
| App open-source license page status | Human reviewed / Pass |
| Remaining license blocker | None |

## Evidence Files

| Item | Evidence Path |
|---|---|
| Qwen base model metadata | `docs/legal_evidence/qwen2_5_0_5b_instruct/hf_api_model.json` |
| Qwen base model README | `docs/legal_evidence/qwen2_5_0_5b_instruct/README.md` |
| Qwen base model LICENSE | `docs/legal_evidence/qwen2_5_0_5b_instruct/LICENSE` |
| Qwen GGUF metadata | `docs/legal_evidence/qwen2_5_0_5b_instruct_gguf/hf_api_model.json` |
| Qwen GGUF README | `docs/legal_evidence/qwen2_5_0_5b_instruct_gguf/README.md` |
| Qwen GGUF LICENSE | `docs/legal_evidence/qwen2_5_0_5b_instruct_gguf/LICENSE` |
| llama.cpp LICENSE | `docs/legal_evidence/llama_cpp/LICENSE` |
| llama.cpp README | `docs/legal_evidence/llama_cpp/README.md` |

## Non-Downloaded Artifacts

This evidence folder intentionally does not contain model weight files:

- No `.gguf`
- No `.bin`
- No `.safetensors`
- No `.mlmodel`
- No `.mlmodelc`
- No `.xcframework`

The bundled GGUF and `llama.xcframework` are tracked in their existing production paths and should remain under Git LFS.
