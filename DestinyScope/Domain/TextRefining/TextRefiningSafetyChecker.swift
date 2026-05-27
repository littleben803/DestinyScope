//
//  TextRefiningSafetyChecker.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

enum TextRefiningSafetyError: LocalizedError, Equatable {
    case safetyCheckFailed([String])

    var errorDescription: String? {
        switch self {
        case .safetyCheckFailed(let reasons):
            return "模型输出未通过安全检查：\(reasons.joined(separator: "；"))"
        }
    }
}

struct TextRefiningSafetyCheckResult: Equatable {
    let isPassed: Bool
    let reasons: [String]
    let matchedTerms: [String]

    var reasonText: String {
        reasons.isEmpty ? "通过" : reasons.joined(separator: "；")
    }
}

struct TextRefiningSafetyChecker {
    private let maxOutputLength = 220

    private let highRiskTerms = [
        "精准预测",
        "改命",
        "化解",
        "避灾",
        "必然发财",
        "保证转运",
        "必有灾祸",
        "寿命预测",
        "疾病预测",
        "投资收益确定",
        "婚姻确定性",
        "大师在线"
    ]

    private let unsupportedGeneratedTerms = [
        "八字",
        "五行",
        "十神",
        "大运",
        "流年",
        "四柱"
    ]

    private let absoluteTerms = [
        "必须",
        "一定",
        "注定",
        "保证",
        "必然"
    ]

    private let decisionAdviceTerms = [
        "诊断",
        "治疗",
        "用药",
        "买入",
        "卖出",
        "收益确定",
        "必定结婚",
        "必定离婚",
        "一定离婚",
        "一定结婚"
    ]

    private let promptLeakageTerms = [
        "严格限制",
        "安全规则",
        "待润色文本",
        "请只输出",
        "<|im_start|>",
        "<|im_end|>",
        "不能新增命理结论",
        "不能编造"
    ]

    func check(_ text: String, sourceText: String = "") -> TextRefiningSafetyCheckResult {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let source = sourceText.trimmingCharacters(in: .whitespacesAndNewlines)
        var reasons: [String] = []
        var matchedTerms: [String] = []

        if trimmedText.isEmpty {
            reasons.append("输出为空")
        }

        if trimmedText.count > maxOutputLength {
            reasons.append("输出过长：\(trimmedText.count) 字")
        }

        let highRiskMatches = highRiskTerms.filter { trimmedText.contains($0) }
        if !highRiskMatches.isEmpty {
            matchedTerms.append(contentsOf: highRiskMatches)
            reasons.append("命中高风险词：\(highRiskMatches.joined(separator: "、"))")
        }

        let promptLeakageMatches = promptLeakageTerms.filter { trimmedText.contains($0) }
        if !promptLeakageMatches.isEmpty {
            matchedTerms.append(contentsOf: promptLeakageMatches)
            reasons.append("疑似提示词泄露：\(promptLeakageMatches.joined(separator: "、"))")
        }

        let unsupportedMatches = unsupportedGeneratedTerms.filter {
            trimmedText.contains($0) && !source.contains($0)
        }
        if !unsupportedMatches.isEmpty {
            matchedTerms.append(contentsOf: unsupportedMatches)
            reasons.append("出现输入中没有的命理术语：\(unsupportedMatches.joined(separator: "、"))")
        }

        let absoluteMatches = absoluteTerms.filter { trimmedText.contains($0) }
        if !absoluteMatches.isEmpty {
            matchedTerms.append(contentsOf: absoluteMatches)
            reasons.append("出现绝对化表达：\(absoluteMatches.joined(separator: "、"))")
        }

        let adviceMatches = decisionAdviceTerms.filter { trimmedText.contains($0) }
        if !adviceMatches.isEmpty {
            matchedTerms.append(contentsOf: adviceMatches)
            reasons.append("出现现实决策建议倾向：\(adviceMatches.joined(separator: "、"))")
        }

        if hasRepeatedSentence(in: trimmedText) {
            reasons.append("存在重复句")
        }

        if safetyNoticeRepeatCount(in: trimmedText) > 1 {
            reasons.append("安全提示重复")
        }

        return TextRefiningSafetyCheckResult(
            isPassed: reasons.isEmpty,
            reasons: reasons,
            matchedTerms: Array(Set(matchedTerms)).sorted()
        )
    }

    func validate(_ text: String, sourceText: String = "") throws {
        let result = check(text, sourceText: sourceText)
        guard result.isPassed else {
            throw TextRefiningSafetyError.safetyCheckFailed(result.reasons)
        }
    }

    private func hasRepeatedSentence(in text: String) -> Bool {
        let fragments = sentenceFragments(from: text)
        guard fragments.count > 1 else {
            return false
        }

        var seen = Set<String>()
        for fragment in fragments {
            let normalized = fragment
                .replacingOccurrences(of: TextRefiningSafetyRules.safetyNotice, with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            guard normalized.count >= 8 else {
                continue
            }

            if seen.contains(normalized) {
                return true
            }

            seen.insert(normalized)
        }

        return false
    }

    private func sentenceFragments(from text: String) -> [String] {
        text
            .components(separatedBy: CharacterSet(charactersIn: "。！？!?；;\n"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    private func safetyNoticeRepeatCount(in text: String) -> Int {
        text.components(separatedBy: TextRefiningSafetyRules.safetyNotice).count - 1
    }
}
