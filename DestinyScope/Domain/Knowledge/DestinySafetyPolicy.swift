//
//  DestinySafetyPolicy.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/8.
//

import Foundation

enum DestinySafetyDecision: Equatable {
    case allowed
    case denied(reason: String, message: String)

    var isAllowed: Bool {
        if case .allowed = self {
            return true
        }
        return false
    }
}

struct DestinySafetyPolicy {
    static let namingUnavailableMessage = "当前版本暂未开放取名功能，可以先从五行气象和命格解释角度了解传统文化含义。"
    static let boundaryText = "本条内容仅用于传统文化学习、娱乐参考与自我观察，不构成现实决策或专业建议。"

    private let deniedRules: [(reason: String, terms: [String], message: String)] = [
        (
            reason: "naming",
            terms: ["取名", "起名", "名字", "姓名学", "改名"],
            message: Self.namingUnavailableMessage
        ),
        (
            reason: "investment_or_wealth_prediction",
            terms: ["投资", "买卖", "股票", "基金", "币圈", "发财", "暴富", "收益", "赚钱"],
            message: "这个问题涉及投资买卖或财富结果预测，当前只支持传统文化角度的气象和自我观察解释。"
        ),
        (
            reason: "medical",
            terms: ["疾病", "生病", "有没有病", "诊断", "治疗", "用药", "寿命", "身体"],
            message: "这个问题涉及健康或疾病判断，请以正规医疗建议为准；当前版本只能做传统文化术语解释。"
        ),
        (
            reason: "marriage_decision",
            terms: ["该不该离婚", "要不要离婚", "该不该结婚", "要不要结婚", "离婚", "结婚", "合婚"],
            message: "这个问题涉及婚姻重大决策，当前版本不能替你做现实决定，只能提供传统文化层面的自我观察角度。"
        ),
        (
            reason: "legal",
            terms: ["法律", "起诉", "判刑", "合同", "赔偿", "律师"],
            message: "这个问题涉及法律判断，请咨询专业法律人士；当前版本只支持传统文化学习参考。"
        ),
        (
            reason: "ritual_or_disaster",
            terms: ["化解", "灾祸", "避灾", "开光", "符咒", "改命", "转运"],
            message: "当前版本不提供化解灾祸、开光符咒或改运建议，可以改为了解相关传统文化术语的历史含义。"
        ),
        (
            reason: "precise_prediction",
            terms: ["精准预测", "一定会", "必定", "注定", "保证", "什么时候死", "必有"],
            message: "当前版本不做精准预测或绝对化判断，只能提供传统文化娱乐参考和自我观察。"
        ),
        (
            reason: "abuse_or_threat",
            terms: ["诅咒", "报复", "人身攻击", "恐吓"],
            message: "这个问题不适合命理问答。可以改为询问五行、阴阳、天干地支或八卦基础含义。"
        )
    ]

    func evaluate(question: String) -> DestinySafetyDecision {
        let normalized = question
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        guard !normalized.isEmpty else {
            return .denied(reason: "empty", message: "请先输入一个与命格解释、五行、阴阳、天干地支或八卦基础相关的问题。")
        }

        for rule in deniedRules {
            if rule.terms.contains(where: { normalized.contains($0.lowercased()) }) {
                return .denied(reason: rule.reason, message: rule.message)
            }
        }

        return .allowed
    }

    func containsUnsafeOutputTerms(_ text: String) -> Bool {
        let unsafeTerms = [
            "精准预测",
            "一定",
            "必定",
            "注定",
            "保证",
            "化解灾祸",
            "开光",
            "符咒",
            "疾病诊断",
            "投资建议",
            "买入",
            "卖出"
        ]
        return unsafeTerms.contains { text.contains($0) }
    }
}
