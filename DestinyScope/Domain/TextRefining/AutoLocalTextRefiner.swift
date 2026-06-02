//
//  AutoLocalTextRefiner.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import Foundation

struct AutoLocalTextRefiner: TextRefining {
    private let templateRefiner: TextRefining
    private let localRefiner: TextRefining
    private let availabilityProvider: () -> ProductionLocalAIAvailability

    init(
        templateRefiner: TextRefining = TemplateTextRefiner(),
        localRefiner: TextRefining = LocalLlamaTextRefiner(engineName: "llama.cpp-qwen2.5-0.5b-q4-production"),
        availabilityProvider: @escaping () -> ProductionLocalAIAvailability = { ProductionLocalAIAvailability.current() }
    ) {
        self.templateRefiner = templateRefiner
        self.localRefiner = localRefiner
        self.availabilityProvider = availabilityProvider
    }

    func refine(_ input: TextRefiningInput) async throws -> TextRefiningOutput {
        let availability = availabilityProvider()
        guard availability.shouldAutoRefine, availability.timeoutSeconds > 0 else {
            return try await fallbackOutput(
                input: input,
                reason: availability.fallbackReason ?? "本地模型当前不可用。"
            )
        }

        let loadingState = await LocalModelLoadingManager.shared.currentState()
        guard loadingState.isLoaded else {
            return try await fallbackOutput(input: input, reason: loadingState.fallbackReason)
        }

        do {
            let output = try await withTimeout(
                seconds: availability.timeoutSeconds,
                operation: {
                    try await localRefiner.refine(input)
                }
            )

            guard output.wasRefined else {
                return output
            }

            return output
        } catch {
            return try await fallbackOutput(input: input, reason: error.localizedDescription)
        }
    }

    private func fallbackOutput(input: TextRefiningInput, reason: String) async throws -> TextRefiningOutput {
        let output = try await templateRefiner.refine(input)
        return TextRefiningOutput(
            text: output.text,
            wasRefined: false,
            engine: "template-fallback",
            safetyNotice: "本地润色不可用，已回退到本地模板文本。原因：\(reason)"
        )
    }

    private func withTimeout(
        seconds: TimeInterval,
        operation: @escaping () async throws -> TextRefiningOutput
    ) async throws -> TextRefiningOutput {
        try await withThrowingTaskGroup(of: TextRefiningOutput.self) { group in
            group.addTask {
                try await operation()
            }

            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
                throw LocalModelRuntimeError.timeout
            }

            guard let result = try await group.next() else {
                throw LocalModelRuntimeError.generationFailed("empty result")
            }

            group.cancelAll()
            return result
        }
    }
}
