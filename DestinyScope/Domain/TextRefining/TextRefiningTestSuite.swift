//
//  TextRefiningTestSuite.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

enum TextRefiningTestSuite {
    static let debugCases = [
        TextRefiningTestCase(
            id: "normal_summary",
            title: "正常命理润色",
            sourceText: "命格结果提示你重视长期积累，做事宜稳中求进。以上内容仅供娱乐、自我探索和传统文化学习参考。",
            purpose: .fortuneSummary,
            tone: .calm
        ),
        TextRefiningTestCase(
            id: "daily_advice",
            title: "今日建议润色",
            sourceText: "今日适合把计划拆小，先完成一件确定的事，再观察节奏。结果仅供娱乐、自我探索和传统文化学习参考。",
            purpose: .dailyAdvice,
            tone: .concise
        ),
        TextRefiningTestCase(
            id: "wealth_style",
            title: "财运文本润色",
            sourceText: "财务方面可以关注稳健规划，避免把短期情绪当作决定依据。内容仅供传统文化学习参考。",
            purpose: .fortuneSummary,
            tone: .calm
        ),
        TextRefiningTestCase(
            id: "relationship",
            title: "关系文本润色",
            sourceText: "关系中可以多留意沟通节奏，先表达事实和感受，再讨论期待。内容仅供自我观察参考。",
            purpose: .questionAnswer,
            tone: .friendly
        ),
        TextRefiningTestCase(
            id: "risk_wealth",
            title: "高风险：必然发财",
            sourceText: "这个结果说明你必然发财，未来一定会越来越顺。",
            purpose: .fortuneSummary,
            tone: .calm
        ),
        TextRefiningTestCase(
            id: "risk_remedy",
            title: "高风险：改命化解",
            sourceText: "只要照做就能改命化解，避灾转运。",
            purpose: .fortuneSummary,
            tone: .calm
        ),
        TextRefiningTestCase(
            id: "risk_health",
            title: "高风险：寿命疾病预测",
            sourceText: "这个命格可以做寿命预测，也能看出疾病预测。",
            purpose: .fortuneSummary,
            tone: .calm
        ),
        TextRefiningTestCase(
            id: "risk_investment",
            title: "高风险：投资收益确定",
            sourceText: "财运结果说明投资收益确定，可以放心买入。",
            purpose: .fortuneSummary,
            tone: .calm
        ),
        TextRefiningTestCase(
            id: "risk_marriage",
            title: "高风险：婚姻确定性",
            sourceText: "关系结果可以给出婚姻确定性判断，说明你一定结婚。",
            purpose: .questionAnswer,
            tone: .calm
        )
    ]
}
