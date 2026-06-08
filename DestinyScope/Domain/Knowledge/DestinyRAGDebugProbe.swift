//
//  DestinyRAGDebugProbe.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/8.
//

#if DEBUG
import Foundation

struct DestinyRAGDebugProbeReport: Equatable {
    let summary: String
    let didPass: Bool
}

struct DestinyRAGDebugProbe {
    func run() async -> DestinyRAGDebugProbeReport {
        var checks: [String] = []
        var didPass = true

        let repository = KnowledgeRepository()
        let sampleContext = DestinyContext(
            gender: .male,
            totalQian: 42,
            boneWeightTitle: "称骨命格示例",
            baziPillars: ["甲子", "丙寅", "戊辰", "庚申"],
            wuxingCounts: ["木": 2, "火": 1, "土": 2, "金": 1, "水": 0],
            dominantElements: ["木", "土"],
            weakElements: ["水"]
        )

        do {
            let chunks = try repository.chunks()
            checks.append("rag_chunks=\(chunks.count)")
            didPass = didPass && chunks.count == 306

            let hits = try repository.searchChunks(query: "五行", scene: .wuxingBalance, topK: 5)
            checks.append("search(五行)=\(hits.count)")
            didPass = didPass && !hits.isEmpty

            let unsafeReturned = hits.contains { !$0.isSafeForRuntimeRAG }
            checks.append("safe_filter=\(!unsafeReturned)")
            didPass = didPass && !unsafeReturned

            let ragContext = RAGContextBuilder().buildContext(from: hits)
            checks.append("rag_context_length=\(ragContext.count)")
            didPass = didPass && ragContext.count <= 900

            let prompt = DestinyPromptBuilder().buildWuxingBalancePrompt(context: sampleContext, ragContext: ragContext)
            let promptHasJSON = prompt.contains("\"summary\"") && prompt.contains("只输出一个 JSON 对象")
            checks.append("prompt_json_schema=\(promptHasJSON)")
            didPass = didPass && promptHasJSON

            let safetyPolicy = DestinySafetyPolicy()
            let deniedQuestions = [
                "我今年能不能发财？",
                "我该不该离婚？",
                "我身体有没有病？",
                "怎么化解灾祸？",
                "帮我取个名字。"
            ]
            let deniedCount = deniedQuestions.filter { !safetyPolicy.evaluate(question: $0).isAllowed }.count
            checks.append("safety_denied=\(deniedCount)/\(deniedQuestions.count)")
            didPass = didPass && deniedCount == deniedQuestions.count

            let invalidService = DestinyInterpretationService(
                modelGenerator: DebugDestinyModelGenerator(output: "not json"),
                timeoutSeconds: 2
            )
            let fallbackResult = await invalidService.generateHomeDestinyDetail(context: sampleContext)
            checks.append("json_parse_fallback=\(fallbackResult.isFallback)")
            didPass = didPass && fallbackResult.isFallback
        } catch {
            checks.append("error=\(error.localizedDescription)")
            didPass = false
        }

        return DestinyRAGDebugProbeReport(
            summary: checks.joined(separator: "\n"),
            didPass: didPass
        )
    }
}

private struct DebugDestinyModelGenerator: DestinyModelGenerating {
    let output: String

    func generate(prompt: String, maxTokens: Int) async throws -> DestinyModelGeneration {
        DestinyModelGeneration(text: output, duration: 0.001, engine: "debug-mock")
    }
}
#endif
