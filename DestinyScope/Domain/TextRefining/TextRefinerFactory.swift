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

    #if DEBUG
    static func makeDebugLocalLlamaRefiner() -> TextRefining {
        LocalLlamaTextRefiner()
    }
    #endif
}
