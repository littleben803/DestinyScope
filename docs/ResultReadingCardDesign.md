# Result Reading Card Design

## Card

- Name: 命格详解
- Subtitle: 基于称骨结果的传统文化解读
- Purpose: merge the previous insight, interpretation, and preset question areas into one local reading card.

## Data Source

- Primary data source: `DestinyScope/Resources/Readings/life_weight_readings.json`.
- The resource is bundled with the app and read locally from `Bundle`.
- No network request, server call, account, sync, or user-data upload is involved.

## Gender Rule

- Home query keeps a local `BirthGender` value.
- `male` reads the `male` variant first.
- `female` reads the `female` variant first.
- If the selected gender variant is missing, fallback to `general`.
- If `general` is also missing, the result page falls back to existing local template content so the card is not blank.
- Old saved profiles and history records without `gender` decode as the default local value `male`.

## Weight Key Mapping

- `LifeWeightResult.readingWeightKey` is the stable lookup key.
- It first normalizes existing display text such as `三兩八錢` or `三两八钱` to `三兩八`.
- If display text is unavailable, it maps `totalWeight` numerically:
  - `2.1` -> `二兩一`
  - `3.8` -> `三兩八`
  - `6.0` -> `六兩`
  - `6.6` -> `六兩六`
- This does not change the weight calculation value or the original calculation engine.

## Field Mapping

- `title`: top title inside the card.
- `insight`: primary summary text.
- `keywords`: shown as tag labels near the top of the card.
- `detail`: optional full reading, collapsed by default.
- `personality` and `career`: 性情与事业.
- `wealth` and `relationship`: 财帛与关系.
- `children_family` and `health_blessing`: 家庭与福泽.
- `advice`: 行动建议.
- `original_poem`, `original_note`, and `rewrite_notes`: internal reference fields only; they are not shown in the UI.

## Questions

The card includes local chips that reveal answers inside the same card:

- 整体怎么看？ -> `insight`
- 性格重点？ -> `personality`
- 事业适合什么？ -> `career`
- 财运要注意什么？ -> `wealth`
- 感情关系怎么看？ -> `relationship`
- 家庭晚辈怎么看？ -> `children_family`
- 身心福泽怎么看？ -> `health_blessing`
- 现在该怎么做？ -> `advice`

Empty answers are hidden to avoid blank rows.

## AI Refinement

- The local refinement card is not displayed in the result page in this stage.
- The result page does not automatically call the local model.
- `TextRefinerFactory.makeDefaultRefiner()` returns `TemplateTextRefiner`.
- Model files and `llama.xcframework` are kept for future work, but the current result page uses local JSON content as the main reading source.
