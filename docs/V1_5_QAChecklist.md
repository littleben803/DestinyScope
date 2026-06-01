# DestinyScope V1.5 QA Checklist

## 1. 构建检查

- [ ] Debug build 通过。
- [ ] Release build 通过。
- [ ] 仓库内无 `.gguf`。
- [ ] 仓库内无 `.bin`。
- [ ] 仓库内无 `.safetensors`。
- [ ] 仓库内无 `.mlmodel` / `.mlmodelc`。
- [ ] 仓库内无 `.xcframework`。
- [ ] `makeDefaultRefiner()` 默认仍返回 `TemplateTextRefiner`。
- [ ] Release 不展示本地模型实验入口，除非未来另有正式决策。

建议命令：

```bash
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Debug -destination 'generic/platform=iOS Simulator' build
```

```bash
xcodebuild -workspace DestinyScope.xcworkspace -scheme DestinyScope -configuration Release -destination 'generic/platform=iOS Simulator' build
```

```bash
find . \( -iname "*.gguf" -o -iname "*.bin" -o -iname "*.safetensors" -o -iname "*.mlmodel" -o -iname "*.mlmodelc" -o -iname "*.xcframework" \) -print
```

## 2. 主流程检查

首页：

- [ ] App 启动后首页可进入。
- [ ] 出生日期选择可用。
- [ ] 时辰选择可用。
- [ ] 点击查询后能生成结果。
- [ ] 查询失败时显示错误，不展示旧结果。

结果页：

- [ ] 显示命格标题。
- [ ] 显示农历生日。
- [ ] 显示总重量。
- [ ] 显示称骨诗文。
- [ ] 显示年 / 月 / 日 / 时权重明细。
- [ ] 显示命格洞察。
- [ ] 显示五类解读。
- [ ] 显示命理问答。
- [ ] 显示免责声明或安全提示。
- [ ] 默认主流程不依赖本地模型。

知识库：

- [ ] 列表可加载 29 篇文章。
- [ ] 分类筛选可用。
- [ ] 本地搜索可用。
- [ ] 搜索无结果有空状态。
- [ ] 详情页可完整阅读。

历史记录：

- [ ] 成功查询后保存轻量历史记录。
- [ ] 历史记录仅本地保存说明可见。
- [ ] 历史详情页只展示已保存字段。
- [ ] 删除单条需要确认。
- [ ] 清空全部需要确认。

设置 / Legal：

- [ ] 设置页分区清楚。
- [ ] 关于页可打开。
- [ ] 隐私政策可打开。
- [ ] 免责声明可打开。
- [ ] 开源许可可打开。

## 3. Accessibility 检查

VoiceOver：

- [ ] TabView 顺序合理。
- [ ] 首页输入控件可理解。
- [ ] 查询按钮 label / hint 清楚。
- [ ] 结果页分区按视觉顺序朗读。
- [ ] 命理问答按钮可理解。
- [ ] 本地润色预览按钮说明清楚。
- [ ] 知识库分类和搜索可理解。
- [ ] 历史删除 / 清空 hint 明确说明不可恢复。
- [ ] 设置页 Legal 入口 label / hint 清楚。
- [ ] Legal 长文按摘要、标题、正文顺序朗读。

Dynamic Type：

- [ ] 默认文字大小可用。
- [ ] Large 可用。
- [ ] Extra Large 可用。
- [ ] Accessibility Large 可用。
- [ ] 长按钮不截断。
- [ ] tags / chips 不溢出。
- [ ] Legal 页面仍可滚动阅读。

错误 / 空状态：

- [ ] 首页查询错误可读。
- [ ] 知识库加载失败可读。
- [ ] 知识库搜索无结果可读。
- [ ] 历史为空可读。
- [ ] 本地模型不可用原因可读。

## 4. 深色模式检查

- [ ] 首页可读。
- [ ] 结果页可读。
- [ ] 本地润色预览可读。
- [ ] 知识库列表和详情可读。
- [ ] 历史记录列表和详情可读。
- [ ] 设置 / 关于可读。
- [ ] 隐私政策、免责声明、开源许可长文可读。
- [ ] 本地模型实验设置页可读。
- [ ] 朱砂红按钮对比足够。
- [ ] 暗金色文字 / badge 不过暗。
- [ ] 错误提示和 fallback 状态明显。

## 5. 小屏检查

- [ ] iPhone SE：首页输入区不拥挤。
- [ ] iPhone SE：结果页卡片不截断。
- [ ] iPhone SE：知识库 chips 可横向滚动。
- [ ] iPhone mini：DatePicker / Picker 可操作。
- [ ] iPhone mini：历史记录删除入口不易误触。
- [ ] iPhone Pro Max：内容宽度舒适。
- [ ] iPad：内容不无限拉宽，留白不过大。
- [ ] 开源许可长 URL 可换行。

## 6. 本地模型实验路径检查

- [ ] 实验开关默认关闭。
- [ ] 未接受说明不能开启。
- [ ] 接受说明后才可开启。
- [ ] UserDefaults 保存状态符合预期。
- [ ] Tier A 可用于实验。
- [ ] Tier B 谨慎提示或按策略可用。
- [ ] Tier C 不可用。
- [ ] unknown 设备默认不可用。
- [ ] Simulator 只作为 Debug 测试，不代表真机性能。
- [ ] 模型文件不存在时不可用或回退。
- [ ] App Documents 路径优先。
- [ ] Developer LocalModels 只用于 Debug / Simulator fallback。
- [ ] alias 文件名可识别。
- [ ] `.gguf` 导入只复制到 App Documents。
- [ ] 用户手动点击才调用模型。
- [ ] 失败回退。
- [ ] 安全检查失败回退。
- [ ] 低电量 / 过热 / 超时按策略回退。
- [ ] 润色结果不覆盖原始文本。
- [ ] 润色结果不写入历史记录。
- [ ] Release 隐藏实验入口。

