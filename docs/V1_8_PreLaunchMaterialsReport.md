# V1.8 Pre-Launch Materials Report

更新日期：2026-06-02

## Scope

阶段 2 处理上线前材料与合规文案，不修改业务逻辑、本地模型接入、称骨计算、历史记录、知识库数据、工程签名、Bundle ID、Version 或 Build。

## Completed Materials

- App Store metadata updated for V1.8 production candidate.
- App Review Notes updated to describe real bundled local model behavior.
- Privacy Nutrition Label draft added.
- `PrivacyInfo.xcprivacy` added with UserDefaults and FileTimestamp required reason declarations.
- App Privacy Policy / Disclaimer / Open Source Licenses copy updated.
- GitHub Pages privacy Markdown and HTML synchronized.
- Screenshot and copy plan updated for V1.8.
- License / notice final checklist added.

## PrivacyInfo Summary

Declared:

- `NSPrivacyAccessedAPICategoryUserDefaults` / `CA92.1`
- `NSPrivacyAccessedAPICategoryFileTimestamp` / `C617.1`

Declared no collected data and no tracking domains.

## App Size Explanation Draft

V1.8 生产候选包内置本地 GGUF 模型和 llama.cpp 推理框架，因此包体明显增大。该设计用于保持本地优先：模型文件随 App 分发，在设备端读取，不提供模型下载，不上传出生信息、模型输入或模型输出。设备不满足条件、低电量、过热、模型不可用、超时或安全检查失败时，App 会回退到本地模板文本。

## Remaining Manual Items

- Verify GitHub Pages privacy URL is publicly accessible after publishing.
- Verify Archive package includes `PrivacyInfo.xcprivacy`.
- Qwen / GGUF / llama.cpp license notice: Human reviewed / Pass.
- Confirm App Store Connect category, age rating and keyword length.
- Capture final screenshots on approved device sizes.
- Run final Archive / App Store Connect upload validation in the next phase.

## Stage 7 License / Notice Evidence Update

更新日期：2026-06-02

Completed:

- Created `docs/legal_evidence/` evidence folders.
- Saved Qwen base model README / LICENSE / HF API metadata.
- Saved Qwen GGUF README / LICENSE / HF API metadata.
- Saved llama.cpp README / LICENSE.
- Created `docs/legal_evidence/LOCAL_MODEL_DISTRIBUTION_RECORD.md`.
- Created `docs/V1_8_LicenseNoticeHumanReview.md`.
- Created `docs/V1_8_DistributionHardeningReport.md`.
- Updated `docs/V1_8_LicenseNoticeFinalChecklist.md`.

Current status:

- No model weight file was downloaded during evidence collection.
- No `.gguf`, `.bin`, `.safetensors`, `.mlmodel`, `.mlmodelc` or `.xcframework` was added under `docs/legal_evidence`.
- Qwen base model license evidence: saved, Human reviewed / Pass.
- Qwen GGUF license evidence: saved, Human reviewed / Pass.
- llama.cpp license evidence: saved, Human reviewed / Pass.
- Remaining license blocker: none.
- Distribution signing remains not completed.
- IPA export remains not completed.
- App Store Connect upload remains not started.
