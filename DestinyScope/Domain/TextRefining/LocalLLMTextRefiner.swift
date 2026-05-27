//
//  LocalLLMTextRefiner.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct LocalLLMTextRefiner: TextRefining {
    func refine(_ input: TextRefiningInput) async throws -> TextRefiningOutput {
        guard !input.sourceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TextRefiningError.emptyInput
        }

        // TODO: V1.1 second stage may connect an on-device small model here.
        // The model must only polish wording and must not generate fortune conclusions.
        throw TextRefiningError.localModelNotAvailable
    }
}
