//
//  TemplateTextRefiner.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct TemplateTextRefiner: TextRefining {
    private let safetyNotice = "润色内容仅供娱乐、自我探索和传统文化学习参考，不构成现实决策建议。"

    func refine(_ input: TextRefiningInput) async throws -> TextRefiningOutput {
        let trimmedText = input.sourceText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else {
            throw TextRefiningError.emptyInput
        }

        return TextRefiningOutput(
            text: refinedText(from: trimmedText, input: input),
            wasRefined: false,
            engine: "template",
            safetyNotice: safetyNotice
        )
    }

    private func refinedText(from text: String, input: TextRefiningInput) -> String {
        switch input.tone {
        case .concise:
            return text
        case .classical:
            return text
        case .friendly:
            return text
        case .calm:
            return text
        }
    }
}
