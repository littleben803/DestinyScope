//
//  TextRefiningInput.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

enum TextRefiningPurpose: String, Equatable {
    case fortuneSummary
    case questionAnswer
    case dailyAdvice
    case knowledgeExplanation
    case general
}

enum TextRefiningTone: String, Equatable {
    case calm
    case concise
    case classical
    case friendly
}

struct TextRefiningInput: Equatable {
    let sourceText: String
    let purpose: TextRefiningPurpose
    let tone: TextRefiningTone
    let context: [String: String]
    let safetyRules: [String]

    init(
        sourceText: String,
        purpose: TextRefiningPurpose,
        tone: TextRefiningTone = .calm,
        context: [String: String] = [:],
        safetyRules: [String] = TextRefiningInput.defaultSafetyRules
    ) {
        self.sourceText = sourceText
        self.purpose = purpose
        self.tone = tone
        self.context = context
        self.safetyRules = safetyRules
    }

    static let defaultSafetyRules = [
        "不做绝对预测。",
        "不构成医疗、法律、财务、投资、婚恋或职业决策建议。",
        "不写精准预测、改命、化解、避灾、必然发财、寿命疾病预测、投资确定性或婚姻确定性。",
        "未来本地模型只能润色表达，不能生成命理计算结论。"
    ]
}
