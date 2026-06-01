//
//  ResultShareTextBuilder.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct ResultShareTextBuilder {
    func build(
        result: LifeWeightResult,
        interpretation: FortuneInterpretation,
        insight: LifeWeightInsight
    ) -> String {
        [
            "DestinyScope",
            "",
            "称骨结果摘要",
            "命格：\(result.title)",
            "总重量：\(result.totalWeightText)",
            "",
            "命格诗文：",
            result.poem,
            "",
            "简要解读：",
            interpretation.summary,
            "",
            "行动建议：",
            insight.actionSuggestion,
            "",
            "以上内容仅供娱乐、自我探索和传统文化学习参考。"
        ].joined(separator: "\n")
    }
}
