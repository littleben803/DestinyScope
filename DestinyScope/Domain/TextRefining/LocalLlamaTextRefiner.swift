//
//  LocalLlamaTextRefiner.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct LocalLlamaTextRefiner: TextRefining {
    private let config: LocalModelDebugConfig

    init(config: LocalModelDebugConfig = .current) {
        self.config = config
    }

    func refine(_ input: TextRefiningInput) async throws -> TextRefiningOutput {
        guard !input.sourceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TextRefiningError.emptyInput
        }

        _ = config
        throw TextRefiningError.localModelNotAvailable
    }
}
