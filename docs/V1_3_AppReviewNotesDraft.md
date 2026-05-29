# DestinyScope V1.3 App Review Notes Draft

更新日期：2026-05-29

## 1. TestFlight 审核备注草案

```text
DestinyScope is an app for traditional Chinese culture learning and self-exploration. Its fortune-related content is generated locally from bundled data and rule-based templates, and is provided only for entertainment, self-exploration, and traditional culture learning.

In this TestFlight build, a local text-refining experiment may be available on supported devices. This feature uses an on-device local model only to polish already generated template text. It does not generate new fortune conclusions, does not replace the life-weight calculation, and does not change the rule-based result.

The app does not upload birth information, fortune results, local model input, local model output, or history records. The local model experiment does not use cloud AI or third-party online model services.

The app does not provide medical, legal, investment, marriage, career, or other deterministic real-world advice. If the local model fails, times out, or does not pass safety checks, the app falls back to local template text.
```

中文说明：

- DestinyScope 是传统文化和自我探索类 App。
- 结果仅供娱乐、自我探索和传统文化学习参考。
- 本地模型实验只做文本润色。
- 本地模型不生成新的命理结论。
- 本地模型不替代称骨计算和模板规则。
- App 不提供医疗、法律、投资、婚恋、职业确定性建议。
- App 不上传用户数据。
- 模型失败、安全检查失败、超时会回退本地模板文本。

## 2. App Store 正式审核备注草案

### 当前如果不开放本地模型

```text
DestinyScope processes birth date and birth hour locally on device. The app does not require an account, does not use a server, does not use online AI, and does not upload birth information.

All fortune-related content is generated from local bundled data and local rule/template logic. Results are for entertainment, self-exploration, and traditional culture learning only, and do not constitute medical, legal, financial, investment, marriage, or career advice.
```

当前正式版本如果不开放本地模型，不应在审核备注中描述本地模型生产功能。

### 未来如果开放本地模型

```text
This version includes an optional on-device text-refining feature on supported devices. It is disabled by default and only polishes already generated template text. It does not generate new fortune conclusions and does not replace the local rule-based calculation.

The feature runs on device. The app does not upload birth information, fortune results, model input, model output, or history records. If the model fails, times out, or fails safety checks, the app falls back to local template text.
```

正式开放前，需要同步更新隐私政策、App 内说明、GitHub Pages 隐私页、App Store 元数据和 license / notice。

## 3. 审核风险点

- 算命类 App 容易被认为夸大或误导。
- AI / 模型能力不能宣传为精准预测。
- 不得出现改命、化解、避灾、保证转运等承诺。
- 不得提供医疗、投资、法律、婚姻确定性建议。
- 若内置大模型文件，需要解释包体、用途、license 和 notice。
- 若下载模型，需要说明网络请求、文件校验、存储位置和隐私处理。
- 若使用“AI”字样，需要明确其只做文本表达润色，不生成命理结论。

## 4. 审核测试建议

如果 TestFlight 开放本地模型实验，建议说明：

1. 打开 App。
2. 完成本地命理计算。
3. 查看结果页原始模板结果。
4. 在支持设备上打开本地文本润色实验开关。
5. 点击“本地润色预览”中的“生成润色版”。
6. 确认原始结果仍保留。
7. 关闭开关后确认回退模板。
8. 在模型不可用或安全检查失败时确认 fallback 生效。
