# DestinyScope V1.6 Feature Backlog

| id | feature | priority | userValue | dataImpact | privacyRisk | implementationRisk | targetStage | decision |
|---|---|---|---|---|---|---|---|---|
| F-001 | Onboarding | P0 | 帮助新用户理解 App 定位、隐私和使用边界 | `UserDefaults` onboarding flag | Low | Low | V1.6 阶段 2 | Implemented |
| F-002 | Local Birth Profile | P0 | 常用出生资料可快速复用，减少重复输入 | Application Support JSON，包含显示名、出生日期和时辰 | High | Medium | V1.6 阶段 3 | Implemented |
| F-003 | Result Text Copy | P0 | 用户可复制结果摘要用于保存或分享 | 无持久化，仅用户点击时写入剪贴板 | Low | Low | V1.6 阶段 4 | Implemented |
| F-004 | Result Share Text | P0 | 用户可用纯文本分享结果摘要 | 分享时临时生成文本，不保存分享记录 | Medium | Medium | V1.6 阶段 4 | Implemented, no image share |
| F-005 | Knowledge Favorite | P0 | 用户可保存感兴趣文章 | Application Support JSON，article id 列表 | Low | Medium | V1.6 阶段 5 | Implemented |
| F-006 | Knowledge Recent Reads | P0 | 用户可回到最近阅读文章 | Application Support JSON，article id + viewedAt | Low | Medium | V1.6 阶段 5 | Implemented |
| F-007 | History Pin / Favorite | P0 | 用户可整理重要历史记录 | Application Support JSON，仅 history record id 集合 | Medium | Medium | V1.6 阶段 6 | Implemented, core history payload unchanged |
| F-008 | History Quick Re-run | P0 | 用户可快速复用历史记录的出生日期和时辰重新查询 | 内存态 HomeInputDraft，使用现有 history record 字段填充首页 | Medium | Medium | V1.6 阶段 6 | Implemented, no auto calculation |
| F-009 | Home Dashboard Recent Record | P1 | 首页可提示最近记录，提高回访效率 | 读取本地 history summary | Medium | Medium | V1.6 阶段 7 | Evaluate |
| F-010 | Local Data Management | P1 | 用户可统一删除历史、收藏、最近阅读和 Profile | 删除本地 JSON / UserDefaults，不新增上传或同步 | Medium | Medium | V1.6 阶段 8 | Implemented |
| F-011 | Related Knowledge From Result | P1 | 从结果页跳到相关知识文章，提升学习体验 | 不新增用户数据，可基于 tags/category | Low | Medium | V1.6 阶段 5 或 7 | Evaluate |
| F-012 | Result Disclosure State Optimization | P1 | 结果页展开折叠更符合阅读习惯 | 可无持久化，或 `UserDefaults` 偏好 | Low | Low | V1.6 阶段 4 或 7 | Evaluate |
| F-013 | Knowledge Beginner Path | P1 | 新用户有入门阅读路径 | 可不持久化，或本地最近进度 | Low | Medium | V1.6 阶段 5 | Evaluate |
| F-014 | Share Template Variants | P1 | 不同分享场景使用不同摘要文本 | `UserDefaults` preference | Low | Low | V1.6 阶段 4 | Evaluate |
| F-015 | Image Share | No | 视觉传播更强，但复杂度和审核风险更高 | 可能生成图片文件 | Medium | High | None | Not in V1.6 |
| F-016 | Cloud Sync | No | 跨设备同步 | 需要账号 / 网络 / 隐私更新 | High | High | None | Not in V1.6 |
| F-017 | Model Download | No | 降低包体并支持模型更新 | 网络、存储、license、隐私复杂 | High | High | None | Not in V1.6 |
| F-018 | Open Chat | No | 互动性强 | 自由输入和模型输出风险高 | High | High | None | Not in V1.6 |
| F-019 | Home Information Architecture | P0 | 首页更清楚地说明产品定位、本地处理、常用资料、历史草稿和查询路径 | 读取本地最近历史摘要，不新增持久化数据 | Low | Low | V1.6 阶段 7 | Implemented |

## P0 排序建议

1. Onboarding。
2. Local Birth Profile。
3. Result Text Copy / Share Text。
4. Knowledge Favorite / Recent Reads。
5. History Pin / Favorite / Quick Re-run。
6. Home Information Architecture。

## 决策原则

- 涉及出生资料的功能必须先有删除能力。
- 涉及分享的功能必须先有安全文案模板。
- 涉及历史记录的功能不能重新计算历史详情。
- 涉及知识库的功能只能读取本地文章。
- 涉及本地模型的功能不得扩大默认路径。

## V1.6 自测后状态

检查日期：2026-06-02

- P0 功能均已完成：Onboarding、Local Birth Profile、Result Text Copy / Share Text、Knowledge Favorite / Recent Reads、History Pin / Favorite / Quick Re-run、Home Information Architecture。
- P1 中 `Local Data Management` 已完成，用于集中查看和清理本机用户数据。
- `Related Knowledge From Result`、`Result Disclosure State Optimization`、`Knowledge Beginner Path`、`Share Template Variants` 仍保留为后续候选。
- 明确不做项保持不变：不做图片分享、Cloud Sync、模型下载、开放聊天、付费订阅或本地模型默认启用。
- V1.6 下一步建议进入 V1.7 多设备人工验收与无障碍修复。
