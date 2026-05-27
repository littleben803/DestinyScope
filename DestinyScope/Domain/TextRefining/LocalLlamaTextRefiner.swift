//
//  LocalLlamaTextRefiner.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct LocalLlamaTextRefiner: TextRefining {
    private let config: LocalModelDebugConfig
    private let promptBuilder: TextRefiningPromptBuilder
    private let safetyChecker: TextRefiningSafetyChecker
    private let testPrompt = "请用一句温和的话说明：命理结果只适合作为自我探索参考。"

    init(
        config: LocalModelDebugConfig = .current,
        promptBuilder: TextRefiningPromptBuilder = TextRefiningPromptBuilder(),
        safetyChecker: TextRefiningSafetyChecker = TextRefiningSafetyChecker()
    ) {
        self.config = config
        self.promptBuilder = promptBuilder
        self.safetyChecker = safetyChecker
    }

    func refine(_ input: TextRefiningInput) async throws -> TextRefiningOutput {
        guard !input.sourceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TextRefiningError.emptyInput
        }

        #if DEBUG
        let prompt = try promptBuilder.buildPrompt(from: input)
        let result = try runDebugGeneration(prompt: prompt, maxTokens: 96)
        let refinedText = cleanRefinedText(result.output, fallback: input.sourceText)
        let safetyResult = safetyChecker.check(refinedText, sourceText: input.sourceText)

        guard safetyResult.isPassed else {
            return fallbackOutput(
                sourceText: input.sourceText,
                reason: safetyResult.reasonText
            )
        }

        return TextRefiningOutput(
            text: refinedText,
            wasRefined: true,
            engine: "llama.cpp-qwen2.5-0.5b-q4-debug",
            safetyNotice: TextRefiningSafetyRules.safetyNotice
        )
        #else
        throw TextRefiningError.localModelNotAvailable
        #endif
    }

    #if DEBUG
    func runDebugGeneration() throws -> LlamaCppGenerationResult {
        try runDebugGeneration(prompt: testPrompt, maxTokens: 96)
    }

    func runDebugGeneration(prompt: String, maxTokens: Int) throws -> LlamaCppGenerationResult {
        guard let modelPath = config.existingModelPath() else {
            throw LlamaCppSessionError.modelFileMissing(config.modelPathCandidates.map(config.expandedPath))
        }

        let session = LlamaCppSession()
        defer {
            session.unload()
        }

        let loadTime = try session.loadModel(path: modelPath)
        let generated = try session.generate(prompt: prompt, maxTokens: maxTokens)

        return LlamaCppGenerationResult(
            modelInfo: LlamaCppModelInfo(path: modelPath),
            output: generated.text,
            loadTime: loadTime,
            generateTime: generated.duration
        )
    }

    private func cleanRefinedText(_ text: String, fallback: String) -> String {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let seedText = trimmedText.isEmpty ? fallback : trimmedText
        let normalizedText = seedText
            .replacingOccurrences(of: "\r", with: "\n")
            .replacingOccurrences(of: "\n\n", with: "\n")

        let separators = CharacterSet(charactersIn: "。！？!?；;\n")
        let fragments = normalizedText
            .components(separatedBy: separators)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        var seen = Set<String>()
        var kept: [String] = []

        for fragment in fragments {
            guard !seen.contains(fragment) else {
                continue
            }

            seen.insert(fragment)
            kept.append(fragment)

            if kept.joined(separator: "。").count >= 120 {
                break
            }
        }

        var output = kept.isEmpty ? fallback : kept.joined(separator: "。") + "。"
        if !output.contains(TextRefiningSafetyRules.safetyNotice) {
            output += TextRefiningSafetyRules.safetyNotice
        }

        return output
    }

    private func fallbackOutput(sourceText: String, reason: String) -> TextRefiningOutput {
        TextRefiningOutput(
            text: sourceText,
            wasRefined: false,
            engine: "llama.cpp-qwen2.5-0.5b-q4-debug-fallback",
            safetyNotice: "模型输出未通过安全检查，已回退到本地模板文本。原因：\(reason)"
        )
    }
    #endif
}
