# DestinyScope 当前项目状态

## 当前方向

当前暂不准备：

- 上传 TestFlight
- 上架 App Store
- 默认启用本地模型
- 将本地模型接入默认结果页
- 增加服务端
- 增加在线 AI
- 增加登录
- 增加支付订阅

当前重点：

- 继续产品功能打磨
- 保持默认主流程稳定
- 保持本地优先
- 保持隐私友好
- 保持本地模型实验受控、默认关闭、失败回退

## 已完成版本

### V1.0

Native 基线版本：

- 本地称骨计算引擎
- 模板式命理解读
- 本地知识库
- 隐私政策
- 免责声明
- App Icon
- Launch Screen
- GitHub Pages 隐私页
- App Store 元数据草案

### V1.1

离线体验增强：

- LifeWeightInsight 命格洞察
- 本地模板命理问答
- 29 篇知识库文章
- rag_chunks 预留
- 本地历史记录
- TextRefining 接口预留

### V1.2

本地小模型 PoC：

- llama.cpp + Qwen2.5-0.5B Q4 GGUF Debug PoC 跑通
- TextRefining PoC 跑通
- SafetyChecker 和 fallback 生效
- 结论：技术可行，但不进入生产

### V1.3

本地模型生产化方案设计：

- 设备分级策略
- TestFlight 实验开关设计
- 本地润色入口设计
- 隐私和审核材料草案
- license / notice 初步审计
- 结论：Conditional Go for limited TestFlight，不进入正式 App Store

### V1.4

TestFlight 本地模型内测实现准备：

- 实验开关
- 设备 tier 检测
- 模型文件可用性检测
- 本地润色预览卡片
- 超时、低电量、过热和失败回退
- 开源许可页面
- 隐私政策更新
- TestFlight readiness 决策
- 当前不上传 TestFlight

### V1.5

产品体验优化：

- source-control 修复
- UI / UX 全量审计
- 结果页阅读体验优化
- 知识库浏览体验优化
- 历史记录体验优化
- 设置 / 关于 / Legal / 开源许可体验优化
- 可访问性、深色模式、小屏适配 QA 规划
- V1.5 自测和 readiness 决策
- 结论：继续产品打磨，不上传 TestFlight，不上架 App Store

## 当前推荐下一版本

V1.6：核心产品功能打磨。

候选方向：

- 首次使用说明 / Onboarding
- 常用出生资料 / 本地 Profile
- 结果页复制与纯文本分享
- 知识库收藏与最近阅读
- 历史记录收藏 / 置顶 / 快速复查
- 首页信息架构优化
- 本地数据管理入口

## 当前硬边界

- 不接服务端
- 不做登录
- 不接在线 AI
- 不加分析或追踪
- 不做付费订阅
- 不做模型下载
- 不默认启用本地模型
- 不把本地模型输出作为命理结论
- 不把本地模型润色结果写入历史记录
- 不做 TestFlight 上传
- 不准备 App Store 上架

## 已知非阻断问题

- Release 日志可能仍出现 `Embed Debug llama.xcframework` script phase dependency analysis 相关提示。
- 这不是当前功能阻塞项。
- 不要在非工程卫生阶段主动修改 Xcode 工程脚本。

## 当前工作建议

后续继续阶段化推进：

1. 先写 docs 规划
2. 再做小范围实现
3. 每阶段跑 Debug / Release build
4. 每阶段检查模型文件和 framework 是否进入仓库
5. 每阶段确认 `makeDefaultRefiner()` 默认仍是 `TemplateTextRefiner`