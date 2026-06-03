//
//  TextRefinerFactory.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

enum TextRefinerFactory {
    static func makeDefaultRefiner() -> TextRefining {
        TemplateTextRefiner()
    }

    static func makeTemplateRefiner() -> TextRefining {
        TemplateTextRefiner()
    }

    static func makeLocalLLMRefinerPlaceholder() -> TextRefining {
        LocalLLMTextRefiner()
    }

    static func makeDebugLocalLlamaRefiner() -> TextRefining {
        LocalLlamaTextRefiner()
    }

    static func makeLocalExperimentRefiner() -> TextRefining {
        LocalLlamaTextRefiner()
    }
}
