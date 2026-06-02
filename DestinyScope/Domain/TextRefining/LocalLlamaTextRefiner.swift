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
    private let modelResolver: BundledLocalModelResolver
    private let engineName: String
    private let testPrompt = "请用一句温和的话说明：命理结果只适合作为自我探索参考。"

    init(
        config: LocalModelDebugConfig = .current,
        promptBuilder: TextRefiningPromptBuilder = TextRefiningPromptBuilder(),
        safetyChecker: TextRefiningSafetyChecker = TextRefiningSafetyChecker(),
        modelResolver: BundledLocalModelResolver = BundledLocalModelResolver(),
        engineName: String = "llama.cpp-qwen2.5-0.5b-q4-debug"
    ) {
        self.config = config
        self.promptBuilder = promptBuilder
        self.safetyChecker = safetyChecker
        self.modelResolver = modelResolver
        self.engineName = engineName
    }

    func refine(_ input: TextRefiningInput) async throws -> TextRefiningOutput {
        guard !input.sourceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TextRefiningError.emptyInput
        }

        let prompt = try promptBuilder.buildPrompt(from: input)
        let result = try await runManagedGeneration(prompt: prompt, maxTokens: 96)
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
            engine: engineName,
            safetyNotice: TextRefiningSafetyRules.safetyNotice
        )
    }

    struct DebugRefiningResult {
        let output: TextRefiningOutput
        let loadTime: TimeInterval
        let generationTime: TimeInterval
    }

    func runDebugGeneration() throws -> LlamaCppGenerationResult {
        try runDebugGeneration(prompt: testPrompt, maxTokens: 96)
    }

    func refineWithDebugMetrics(_ input: TextRefiningInput) async throws -> DebugRefiningResult {
        guard !input.sourceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TextRefiningError.emptyInput
        }

        let prompt = try promptBuilder.buildPrompt(from: input)
        let result = try await runManagedGeneration(prompt: prompt, maxTokens: 96)
        let refinedText = cleanRefinedText(result.output, fallback: input.sourceText)
        let safetyResult = safetyChecker.check(refinedText, sourceText: input.sourceText)

        let output: TextRefiningOutput
        if safetyResult.isPassed {
            output = TextRefiningOutput(
                text: refinedText,
                wasRefined: true,
                engine: engineName,
                safetyNotice: TextRefiningSafetyRules.safetyNotice
            )
        } else {
            output = fallbackOutput(
                sourceText: input.sourceText,
                reason: safetyResult.reasonText
            )
        }

        return DebugRefiningResult(
            output: output,
            loadTime: result.loadTime,
            generationTime: result.generateTime
        )
    }

    func runDebugGeneration(prompt: String, maxTokens: Int) throws -> LlamaCppGenerationResult {
        try runGeneration(prompt: prompt, maxTokens: maxTokens)
    }

    private func runManagedGeneration(prompt: String, maxTokens: Int) async throws -> LlamaCppGenerationResult {
        try await LocalModelLoadingManager.shared.generate(prompt: prompt, maxTokens: maxTokens)
    }

    func runGeneration(prompt: String, maxTokens: Int) throws -> LlamaCppGenerationResult {
        let modelStatus = modelResolver.resolveModelFileStatus()
        guard let modelPath = modelStatus.resolvedURL?.path, modelStatus.isUsable else {
            let candidates = modelResolver.candidateStatuses().compactMap { $0.resolvedURL?.path }
            throw LlamaCppSessionError.modelFileMissing(candidates.isEmpty ? config.modelPathCandidates.map(config.expandedPath) : candidates)
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
            engine: "\(engineName)-fallback",
            safetyNotice: "模型输出未通过安全检查，已回退到本地模板文本。原因：\(reason)"
        )
    }
}
