//
//  DestinyPromptBuilder.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/8.
//

import Foundation

struct DestinyPromptBuilder {
    private let maxPromptLength: Int

    init(maxPromptLength: Int = 1800) {
        self.maxPromptLength = maxPromptLength
    }

    func buildHomeDestinyDetailPrompt(context: DestinyContext, ragContext: String) -> String {
        buildPrompt(
            sceneTitle: "首页命格详解",
            context: context,
            ragContext: ragContext,
            task: "请结合已给出的称骨结果、五行与知识片段，输出温和、结构化的命格解释。不要重新计算八字、五行或称骨。",
            jsonSchema: """
            {
              "overview": "",
              "wuxingQi": "",
              "personality": "",
              "career": "",
              "suggestion": "",
              "boundary": ""
            }
            """
        )
    }

    func buildWuxingBalancePrompt(context: DestinyContext, ragContext: String) -> String {
        buildPrompt(
            sceneTitle: "五行平衡",
            context: context,
            ragContext: ragContext,
            task: "请只解释 App 已提供的五行偏旺、偏弱和气象关系，给出适合自我观察的平衡建议。不要生成新的命盘结论。",
            jsonSchema: """
            {
              "summary": "",
              "elementInterpretation": "",
              "personalityTendency": "",
              "balanceSuggestion": "",
              "boundary": ""
            }
            """
        )
    }

    func buildDailyQiPrompt(context: DestinyContext, dailyStemBranch: String, ragContext: String) -> String {
        let contextWithDaily = appending("今日干支：\(dailyStemBranch)", to: context.promptSummary)
        return buildPrompt(
            sceneTitle: "今日气象",
            contextSummary: contextWithDaily,
            ragContext: ragContext,
            task: "请根据今日干支、五行阴阳知识片段，输出传统文化气象参考。不要做吉凶承诺，不要替用户决定现实事项。",
            jsonSchema: """
            {
              "theme": "",
              "summary": "",
              "suitable": [],
              "mindful": [],
              "shortAdvice": "",
              "boundary": ""
            }
            """
        )
    }

    func buildQAPrompt(context: DestinyContext, question: String, ragContext: String) -> String {
        let contextWithQuestion = appending("用户问题：\(question)", to: context.promptSummary)
        return buildPrompt(
            sceneTitle: "命理问答",
            contextSummary: contextWithQuestion,
            ragContext: ragContext,
            task: "请根据用户问题、App 已提供的命盘上下文和知识片段回答。只解释传统文化含义，不做现实决策建议。",
            jsonSchema: """
            {
              "answer": "",
              "relatedTags": [],
              "suggestedQuestions": [],
              "boundary": ""
            }
            """
        )
    }
}

private extension DestinyPromptBuilder {
    func buildPrompt(
        sceneTitle: String,
        context: DestinyContext,
        ragContext: String,
        task: String,
        jsonSchema: String
    ) -> String {
        buildPrompt(
            sceneTitle: sceneTitle,
            contextSummary: context.promptSummary,
            ragContext: ragContext,
            task: task,
            jsonSchema: jsonSchema
        )
    }

    func buildPrompt(
        sceneTitle: String,
        contextSummary: String,
        ragContext: String,
        task: String,
        jsonSchema: String
    ) -> String {
        let prompt = """
        <|im_start|>system
        你是 DestinyScope 的传统文化解读助手。请以专业、温和、略有命理师风格的语气表达，但不要过度神秘化。
        统一安全边界：
        - 只能根据 App 已给出的算法结果和知识片段回答。
        - 不要编造没有提供的信息，不要自行计算八字、五行、称骨、大运或流年。
        - 不做医疗、投资、法律、婚姻等现实决策建议。
        - 不使用“必定、一定、注定、保证、化解灾祸、精准预测”等绝对化表达。
        - 定位为传统文化娱乐参考和自我观察。
        - 只输出一个 JSON 对象，不要输出 Markdown、标题、解释过程或多余文本。
        <|im_end|>
        <|im_start|>user
        场景：\(sceneTitle)
        任务：\(task)

        【App 已提供的上下文】
        \(contextSummary)

        \(ragContext)

        请严格按以下 JSON 字段输出，字段必须完整，所有字符串请使用自然中文：
        \(jsonSchema)
        boundary 字段固定表达为：\(DestinySafetyPolicy.boundaryText)
        <|im_end|>
        <|im_start|>assistant
        """

        return clippedPrompt(prompt)
    }

    func clippedPrompt(_ prompt: String) -> String {
        guard prompt.count > maxPromptLength else {
            return prompt
        }

        return String(prompt.prefix(maxPromptLength)) + "\n<|im_start|>assistant\n"
    }

    func appending(_ line: String, to summary: String) -> String {
        let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedLine.isEmpty else {
            return summary
        }

        return summary + "\n" + trimmedLine
    }
}
