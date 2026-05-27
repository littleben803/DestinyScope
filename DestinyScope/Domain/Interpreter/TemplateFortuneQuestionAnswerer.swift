//
//  TemplateFortuneQuestionAnswerer.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct TemplateFortuneQuestionAnswerer {
    private let classifier = QuestionIntentClassifier()
    private let safetyNotice = "以上回答仅供娱乐、自我探索和传统文化学习参考，不构成现实决策建议。"

    func answer(
        question: FortuneQuestion,
        result: LifeWeightResult,
        interpretation: FortuneInterpretation,
        insight: LifeWeightInsight
    ) -> FortuneAnswer {
        answer(
            questionTitle: question.title,
            intent: classifier.classify(question: question),
            result: result,
            interpretation: interpretation,
            insight: insight
        )
    }

    func answer(
        text: String,
        result: LifeWeightResult,
        interpretation: FortuneInterpretation,
        insight: LifeWeightInsight
    ) -> FortuneAnswer {
        let intent = classifier.classify(text: text)
        return answer(
            questionTitle: text,
            intent: intent,
            result: result,
            interpretation: interpretation,
            insight: insight
        )
    }

    private func answer(
        questionTitle: String,
        intent: QuestionIntent,
        result: LifeWeightResult,
        interpretation: FortuneInterpretation,
        insight: LifeWeightInsight
    ) -> FortuneAnswer {
        let answerText: String

        switch intent {
        case .career:
            answerText = careerAnswer(interpretation: interpretation, insight: insight)
        case .wealth:
            answerText = wealthAnswer(interpretation: interpretation, insight: insight)
        case .personality:
            answerText = personalityAnswer(interpretation: interpretation, insight: insight)
        case .relationship:
            answerText = relationshipAnswer(interpretation: interpretation, insight: insight)
        case .dailyAdvice:
            answerText = dailyAdviceAnswer(result: result, insight: insight)
        case .general:
            answerText = generalAnswer(interpretation: interpretation, insight: insight)
        case .unknown:
            answerText = unknownAnswer()
        }

        return FortuneAnswer(
            questionTitle: questionTitle,
            intent: intent,
            answer: answerText,
            safetyNotice: safetyNotice
        )
    }

    private func careerAnswer(interpretation: FortuneInterpretation, insight: LifeWeightInsight) -> String {
        let strengths = insight.strengths.prefix(2).joined(separator: " ")
        return "职业方向可以参考当前报告中的事业解读：\(interpretation.career) 结合洞察中的优势倾向，\(strengths) 建议把它作为职业选择和阶段规划的自我观察材料，优先关注可持续、可复盘的方向。"
    }

    private func wealthAnswer(interpretation: FortuneInterpretation, insight: LifeWeightInsight) -> String {
        let cautions = insight.cautions.prefix(2).joined(separator: " ")
        return "财务风格只适合作为传统文化参考：\(interpretation.wealth) 同时可以关注这些提醒：\(cautions) 涉及现实财务安排时，建议以预算、风险边界和专业意见为准。"
    }

    private func personalityAnswer(interpretation: FortuneInterpretation, insight: LifeWeightInsight) -> String {
        let tags = insight.tags.joined(separator: "、")
        return "性格倾向可以结合标签“\(tags)”来观察。\(interpretation.personality) 这些内容更适合作为自我理解的线索，可以帮助你观察自己的节奏、表达方式和长期习惯。"
    }

    private func relationshipAnswer(interpretation: FortuneInterpretation, insight: LifeWeightInsight) -> String {
        let cautions = insight.cautions.prefix(2).joined(separator: " ")
        return "关系沟通方面可以参考：\(interpretation.relationship) 同时留意：\(cautions) 建议把重点放在沟通方式、边界感和情绪表达上，不把命理结果当作关系结论。"
    }

    private func dailyAdviceAnswer(result: LifeWeightResult, insight: LifeWeightInsight) -> String {
        "今天可以把“\(result.title)”当作一个自我观察主题。\(insight.actionSuggestion) 若时间有限，只做一个小行动，并在晚上简单记录感受和变化。"
    }

    private func generalAnswer(interpretation: FortuneInterpretation, insight: LifeWeightInsight) -> String {
        "整体来看，\(interpretation.summary) \(insight.focusDescription) 可以把这份报告当作温和的观察框架，选择其中一两个对当下有帮助的提醒去实践。"
    }

    private func unknownAnswer() -> String {
        "当前问答仅支持围绕本次命理结果的预设问题。可以先从职业方向、财运特点、性格倾向、关系沟通或今日建议中选择一个问题查看参考回答。"
    }
}
