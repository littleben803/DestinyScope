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
        insight: LifeWeightInsight,
        localizationStore: LocalizationStore
    ) -> String {
        [
            localizationStore.string(.appName),
            "",
            localizationStore.string("result.share.text.title"),
            localizationStore.string("result.share.text.destinyTitle", replacements: ["title": result.title]),
            localizationStore.string("result.share.text.totalWeight", replacements: ["weight": result.totalWeightText]),
            "",
            localizationStore.string("result.share.text.poemTitle"),
            result.poem,
            "",
            localizationStore.string("result.share.text.interpretationTitle"),
            interpretation.summary,
            "",
            localizationStore.string("result.share.text.actionTitle"),
            insight.actionSuggestion,
            "",
            localizationStore.string("result.share.text.safety")
        ].joined(separator: "\n")
    }
}
