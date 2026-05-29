//
//  LocalRefiningPreviewInputBuilder.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/29.
//

import Foundation

struct LocalRefiningPreviewInputBuilder {
    func build(
        interpretation: FortuneInterpretation,
        insight: LifeWeightInsight
    ) -> TextRefiningInput {
        let sourceText = [
            interpretation.summary,
            insight.actionSuggestion,
            TextRefiningSafetyRules.safetyNotice
        ]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n")

        return TextRefiningInput(
            sourceText: sourceText,
            purpose: .fortuneSummary,
            tone: .calm,
            context: [
                "experiment": "local_result_preview_refining",
                "tone": "calm_traditional_culture",
                "input_scope": "FortuneInterpretation.summary + LifeWeightInsight.actionSuggestion + safetyNotice"
            ],
            safetyRules: TextRefiningSafetyRules.defaultRules
        )
    }
}
