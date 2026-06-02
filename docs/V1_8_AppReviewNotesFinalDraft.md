# V1.8 App Review Notes Final Draft

更新日期：2026-06-02

最终提交 App Review Notes 时，优先使用 `docs/AppReviewNotes.md` 的 English Version，并保留测试账号说明：

```text
No account is required. No login is required.
```

## Key Review Claims

- Fully native and local-first.
- No account, login, backend server, online AI, model download, analytics SDK, ad tracking, paid subscription, CloudKit, or iCloud sync.
- Birth date and birth hour are used only for on-device calculation.
- Local model input and output are not uploaded.
- Local model only rewrites existing template text and does not create new fortune conclusions.
- Failure, timeout, battery, thermal, device eligibility, model availability, and safety check issues fall back to local template text.

## Manual Submit Checklist

- Confirm the final build includes `PrivacyInfo.xcprivacy`.
- Confirm Review Notes do not say the app has no real local LLM.
- Confirm screenshots do not imply deterministic prediction or professional advice.
- Confirm open-source model and llama.cpp license records are ready.
