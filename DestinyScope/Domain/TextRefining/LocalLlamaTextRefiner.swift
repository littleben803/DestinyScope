//
//  LocalLlamaTextRefiner.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct LocalLlamaTextRefiner: TextRefining {
    private let config: LocalModelDebugConfig
    private let testPrompt = "请用一句温和的话说明：命理结果只适合作为自我探索参考。"

    init(config: LocalModelDebugConfig = .current) {
        self.config = config
    }

    func refine(_ input: TextRefiningInput) async throws -> TextRefiningOutput {
        guard !input.sourceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TextRefiningError.emptyInput
        }

        #if DEBUG
        let result = try runDebugGeneration()
        return TextRefiningOutput(
            text: result.output,
            wasRefined: true,
            engine: "llama.cpp-debug",
            safetyNotice: input.safetyRules.first
        )
        #else
        throw TextRefiningError.localModelNotAvailable
        #endif
    }

    #if DEBUG
    func runDebugGeneration() throws -> LlamaCppGenerationResult {
        guard let modelPath = config.existingModelPath() else {
            throw LlamaCppSessionError.modelFileMissing(config.modelPathCandidates.map(config.expandedPath))
        }

        let session = LlamaCppSession()
        defer {
            session.unload()
        }

        let loadTime = try session.loadModel(path: modelPath)
        let generated = try session.generate(prompt: testPrompt, maxTokens: 96)

        return LlamaCppGenerationResult(
            modelInfo: LlamaCppModelInfo(path: modelPath),
            output: generated.text,
            loadTime: loadTime,
            generateTime: generated.duration
        )
    }
    #endif
}
