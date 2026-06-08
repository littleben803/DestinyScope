//
//  DestinyInterpretationService.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/8.
//

import Foundation

struct DestinyInterpretationService {
    private let repository: KnowledgeRepository
    private let queryBuilder: KnowledgeQueryBuilder
    private let ragContextBuilder: RAGContextBuilder
    private let promptBuilder: DestinyPromptBuilder
    private let safetyPolicy: DestinySafetyPolicy
    private let modelGenerator: DestinyModelGenerating
    private let timeoutSeconds: TimeInterval
    private let decoder = JSONDecoder()

    init(
        repository: KnowledgeRepository = KnowledgeRepository(),
        queryBuilder: KnowledgeQueryBuilder = KnowledgeQueryBuilder(),
        ragContextBuilder: RAGContextBuilder = RAGContextBuilder(),
        promptBuilder: DestinyPromptBuilder = DestinyPromptBuilder(),
        safetyPolicy: DestinySafetyPolicy = DestinySafetyPolicy(),
        modelGenerator: DestinyModelGenerating = LocalDestinyModelGenerator(),
        timeoutSeconds: TimeInterval = 12
    ) {
        self.repository = repository
        self.queryBuilder = queryBuilder
        self.ragContextBuilder = ragContextBuilder
        self.promptBuilder = promptBuilder
        self.safetyPolicy = safetyPolicy
        self.modelGenerator = modelGenerator
        self.timeoutSeconds = timeoutSeconds
    }

    func generateHomeDestinyDetail(context: DestinyContext) async -> HomeDestinyDetailResult {
        let scene = KnowledgeScene.homeDestinyDetail
        let keywords = queryBuilder.buildHomeDestinyDetailQuery(context)
        let chunks = loadChunks(keywords: keywords, scene: scene, topK: 6)
        let ragContext = ragContextBuilder.buildContext(from: chunks)
        let prompt = promptBuilder.buildHomeDestinyDetailPrompt(context: context, ragContext: ragContext)

        do {
            let generation = try await generate(prompt: prompt, maxTokens: 420)
            var result = try decode(HomeDestinyDetailResult.self, from: generation.text)
            guard !safetyPolicy.containsUnsafeOutputTerms(generation.text) else {
                throw DestinyInterpretationError.unsafeModelOutput
            }

            result.isFallback = false
            result.fallbackReason = nil
            result.chunkIDs = chunks.map(\.id)
            debugLog(
                scene: scene,
                keywords: keywords,
                chunks: chunks,
                promptLength: prompt.count,
                modelDuration: generation.duration,
                jsonParseResult: "success",
                fallbackTriggered: false
            )
            return result
        } catch {
            let result = fallbackHome(context: context, chunks: chunks, reason: error.localizedDescription)
            debugLog(
                scene: scene,
                keywords: keywords,
                chunks: chunks,
                promptLength: prompt.count,
                modelDuration: nil,
                jsonParseResult: "failed: \(error.localizedDescription)",
                fallbackTriggered: true
            )
            return result
        }
    }

    func generateWuxingBalance(context: DestinyContext) async -> WuxingBalanceInterpretationResult {
        let scene = KnowledgeScene.wuxingBalance
        let keywords = queryBuilder.buildWuxingBalanceQuery(context)
        let chunks = loadChunks(keywords: keywords, scene: scene, topK: 6)
        let ragContext = ragContextBuilder.buildContext(from: chunks)
        let prompt = promptBuilder.buildWuxingBalancePrompt(context: context, ragContext: ragContext)

        do {
            let generation = try await generate(prompt: prompt, maxTokens: 420)
            var result = try decode(WuxingBalanceInterpretationResult.self, from: generation.text)
            guard !safetyPolicy.containsUnsafeOutputTerms(generation.text) else {
                throw DestinyInterpretationError.unsafeModelOutput
            }

            result.isFallback = false
            result.fallbackReason = nil
            result.chunkIDs = chunks.map(\.id)
            debugLog(
                scene: scene,
                keywords: keywords,
                chunks: chunks,
                promptLength: prompt.count,
                modelDuration: generation.duration,
                jsonParseResult: "success",
                fallbackTriggered: false
            )
            return result
        } catch {
            let result = fallbackWuxing(context: context, chunks: chunks, reason: error.localizedDescription)
            debugLog(
                scene: scene,
                keywords: keywords,
                chunks: chunks,
                promptLength: prompt.count,
                modelDuration: nil,
                jsonParseResult: "failed: \(error.localizedDescription)",
                fallbackTriggered: true
            )
            return result
        }
    }

    func generateDailyQi(context: DestinyContext, dailyStemBranch: String) async -> DailyQiInterpretationResult {
        let scene = KnowledgeScene.dailyQi
        let keywords = queryBuilder.buildDailyQiQuery(context, dailyStemBranch: dailyStemBranch)
        let chunks = loadChunks(keywords: keywords, scene: scene, topK: 6)
        let ragContext = ragContextBuilder.buildContext(from: chunks)
        let prompt = promptBuilder.buildDailyQiPrompt(context: context, dailyStemBranch: dailyStemBranch, ragContext: ragContext)

        do {
            let generation = try await generate(prompt: prompt, maxTokens: 420)
            var result = try decode(DailyQiInterpretationResult.self, from: generation.text)
            guard !safetyPolicy.containsUnsafeOutputTerms(generation.text) else {
                throw DestinyInterpretationError.unsafeModelOutput
            }

            result.isFallback = false
            result.fallbackReason = nil
            result.chunkIDs = chunks.map(\.id)
            debugLog(
                scene: scene,
                keywords: keywords,
                chunks: chunks,
                promptLength: prompt.count,
                modelDuration: generation.duration,
                jsonParseResult: "success",
                fallbackTriggered: false
            )
            return result
        } catch {
            let result = fallbackDailyQi(dailyStemBranch: dailyStemBranch, chunks: chunks, reason: error.localizedDescription)
            debugLog(
                scene: scene,
                keywords: keywords,
                chunks: chunks,
                promptLength: prompt.count,
                modelDuration: nil,
                jsonParseResult: "failed: \(error.localizedDescription)",
                fallbackTriggered: true
            )
            return result
        }
    }

    func answerQuestion(context: DestinyContext, question: String) async -> DestinyQAResult {
        let scene = KnowledgeScene.qa
        let safetyDecision = safetyPolicy.evaluate(question: question)
        guard safetyDecision.isAllowed else {
            if case let .denied(reason, message) = safetyDecision {
                return DestinyQAResult(
                    answer: message,
                    relatedTags: ["使用边界"],
                    suggestedQuestions: [
                        "五行偏旺偏弱可以怎样理解？",
                        "阴阳在传统文化中是什么意思？",
                        "天干地支主要用于表达什么？"
                    ],
                    boundary: DestinySafetyPolicy.boundaryText,
                    isFallback: true,
                    fallbackReason: reason,
                    chunkIDs: []
                )
            }
            return fallbackQA(question: question, chunks: [], reason: "question_denied")
        }

        let keywords = queryBuilder.buildQAQuery(context, question: question)
        let chunks = loadChunks(keywords: keywords, scene: scene, topK: 6)
        let ragContext = ragContextBuilder.buildContext(from: chunks)
        let prompt = promptBuilder.buildQAPrompt(context: context, question: question, ragContext: ragContext)

        do {
            let generation = try await generate(prompt: prompt, maxTokens: 420)
            var result = try decode(DestinyQAResult.self, from: generation.text)
            guard !safetyPolicy.containsUnsafeOutputTerms(generation.text) else {
                throw DestinyInterpretationError.unsafeModelOutput
            }

            result.isFallback = false
            result.fallbackReason = nil
            result.chunkIDs = chunks.map(\.id)
            debugLog(
                scene: scene,
                keywords: keywords,
                chunks: chunks,
                promptLength: prompt.count,
                modelDuration: generation.duration,
                jsonParseResult: "success",
                fallbackTriggered: false
            )
            return result
        } catch {
            let result = fallbackQA(question: question, chunks: chunks, reason: error.localizedDescription)
            debugLog(
                scene: scene,
                keywords: keywords,
                chunks: chunks,
                promptLength: prompt.count,
                modelDuration: nil,
                jsonParseResult: "failed: \(error.localizedDescription)",
                fallbackTriggered: true
            )
            return result
        }
    }
}

private enum DestinyInterpretationError: LocalizedError {
    case missingJSONObject
    case unsafeModelOutput

    var errorDescription: String? {
        switch self {
        case .missingJSONObject:
            return "模型输出中未找到 JSON 对象。"
        case .unsafeModelOutput:
            return "模型输出命中安全风险词。"
        }
    }
}

private extension DestinyInterpretationService {
    func loadChunks(keywords: [String], scene: KnowledgeScene, topK: Int) -> [KnowledgeChunk] {
        (try? repository.searchChunks(keywords: keywords, scene: scene, topK: topK)) ?? []
    }

    func generate(prompt: String, maxTokens: Int) async throws -> DestinyModelGeneration {
        try await withTimeout(seconds: timeoutSeconds) {
            try await modelGenerator.generate(prompt: prompt, maxTokens: maxTokens)
        }
    }

    func decode<T: Decodable>(_ type: T.Type, from rawOutput: String) throws -> T {
        let jsonText = try extractJSONObject(from: rawOutput)
        let data = Data(jsonText.utf8)
        return try decoder.decode(type, from: data)
    }

    func extractJSONObject(from rawOutput: String) throws -> String {
        let trimmed = rawOutput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let start = trimmed.firstIndex(of: "{"),
              let end = trimmed.lastIndex(of: "}"),
              start <= end else {
            throw DestinyInterpretationError.missingJSONObject
        }

        return String(trimmed[start...end])
    }

    func withTimeout<T>(
        seconds: TimeInterval,
        operation: @escaping () async throws -> T
    ) async throws -> T {
        try await withThrowingTaskGroup(of: T.self) { group in
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

    func fallbackHome(context: DestinyContext, chunks: [KnowledgeChunk], reason: String) -> HomeDestinyDetailResult {
        HomeDestinyDetailResult(
            overview: "当前先使用本地模板解释：命格解读以 App 已计算出的称骨结果为基础，适合作为传统文化角度的自我观察。",
            wuxingQi: elementFallback(context: context),
            personality: "可以把相关描述理解为一种性情倾向的比喻，不代表固定性格或现实结论。",
            career: "事业与行动建议仅宜作为自我管理参考，仍应以现实能力、环境和专业判断为准。",
            suggestion: "保持稳定作息、审慎规划和持续学习，比追求确定性预测更有实际意义。",
            boundary: DestinySafetyPolicy.boundaryText,
            isFallback: true,
            fallbackReason: reason,
            chunkIDs: chunks.map(\.id)
        )
    }

    func fallbackWuxing(context: DestinyContext, chunks: [KnowledgeChunk], reason: String) -> WuxingBalanceInterpretationResult {
        WuxingBalanceInterpretationResult(
            summary: "当前先使用本地模板解释五行关系。五行可理解为木、火、土、金、水五类气象的互相生克与流转。",
            elementInterpretation: elementFallback(context: context),
            personalityTendency: "偏旺或偏弱只适合描述观察角度，不代表能力高低或命运定论。",
            balanceSuggestion: "可从节奏、习惯和情绪管理上做温和调整，避免把五行解释当作现实决策依据。",
            boundary: DestinySafetyPolicy.boundaryText,
            isFallback: true,
            fallbackReason: reason,
            chunkIDs: chunks.map(\.id)
        )
    }

    func fallbackDailyQi(dailyStemBranch: String, chunks: [KnowledgeChunk], reason: String) -> DailyQiInterpretationResult {
        DailyQiInterpretationResult(
            theme: dailyStemBranch.isEmpty ? "今日气象" : "\(dailyStemBranch)气象",
            summary: "今日气象解释暂以本地模板呈现，可从阴阳、五行和时令节奏角度做轻量观察。",
            suitable: ["整理计划", "保持节奏", "复盘近期状态"],
            mindful: ["避免冲动判断", "避免把气象解释当作确定吉凶", "重要事项仍以现实信息为准"],
            shortAdvice: "把今日气象当作提醒自己调整节奏的文化参考即可。",
            boundary: DestinySafetyPolicy.boundaryText,
            isFallback: true,
            fallbackReason: reason,
            chunkIDs: chunks.map(\.id)
        )
    }

    func fallbackQA(question: String, chunks: [KnowledgeChunk], reason: String) -> DestinyQAResult {
        DestinyQAResult(
            answer: "当前先使用本地模板回答。你可以把“\(question)”放在传统文化学习语境中理解，优先关注五行、阴阳、天干地支或八卦的基础含义，避免把解释当作现实决策依据。",
            relatedTags: relatedTags(from: chunks),
            suggestedQuestions: [
                "五行相生相克是什么意思？",
                "阴阳平衡可以怎样理解？",
                "天干地支和时间节律有什么关系？"
            ],
            boundary: DestinySafetyPolicy.boundaryText,
            isFallback: true,
            fallbackReason: reason,
            chunkIDs: chunks.map(\.id)
        )
    }

    func elementFallback(context: DestinyContext) -> String {
        let dominant = context.dominantElements.isEmpty ? "暂无明确偏旺元素" : "偏旺元素：\(context.dominantElements.joined(separator: "、"))"
        let weak = context.weakElements.isEmpty ? "暂无明确偏弱元素" : "偏弱元素：\(context.weakElements.joined(separator: "、"))"
        return "\(dominant)；\(weak)。这些信息只用于描述五行气象的相对观察角度。"
    }

    func relatedTags(from chunks: [KnowledgeChunk]) -> [String] {
        var seen = Set<String>()
        var tags: [String] = []

        for tag in chunks.flatMap(\.tags) {
            guard !seen.contains(tag) else {
                continue
            }
            seen.insert(tag)
            tags.append(tag)
            if tags.count >= 5 {
                break
            }
        }

        return tags.isEmpty ? ["传统文化", "使用边界"] : tags
    }

    func debugLog(
        scene: KnowledgeScene,
        keywords: [String],
        chunks: [KnowledgeChunk],
        promptLength: Int,
        modelDuration: TimeInterval?,
        jsonParseResult: String,
        fallbackTriggered: Bool
    ) {
        #if DEBUG
        let ids = chunks.map(\.id).joined(separator: ", ")
        let titles = chunks.map(\.title).joined(separator: " | ")
        let durationText = modelDuration.map { String(format: "%.3fs", $0) } ?? "n/a"
        print("[DestinyRAG] scene=\(scene.rawValue)")
        print("[DestinyRAG] query keywords=\(keywords.joined(separator: ", "))")
        print("[DestinyRAG] hit chunk ids=\(ids)")
        print("[DestinyRAG] hit chunk titles=\(titles)")
        print("[DestinyRAG] prompt length=\(promptLength)")
        print("[DestinyRAG] model duration=\(durationText)")
        print("[DestinyRAG] json parse result=\(jsonParseResult)")
        print("[DestinyRAG] fallback triggered=\(fallbackTriggered)")
        #endif
    }
}
