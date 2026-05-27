//
//  QuestionIntentClassifier.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct QuestionIntentClassifier {
    func classify(question: FortuneQuestion) -> QuestionIntent {
        question.intent
    }

    func classify(text: String) -> QuestionIntent {
        let normalized = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if containsAny(normalized, keywords: ["职业", "事业", "工作", "方向", "发展"]) {
            return .career
        }

        if containsAny(normalized, keywords: ["财运", "财富", "金钱", "收入", "理财"]) {
            return .wealth
        }

        if containsAny(normalized, keywords: ["性格", "个性", "特点", "倾向", "脾气"]) {
            return .personality
        }

        if containsAny(normalized, keywords: ["关系", "感情", "沟通", "相处", "人际"]) {
            return .relationship
        }

        if containsAny(normalized, keywords: ["今日", "今天", "建议", "提醒"]) {
            return .dailyAdvice
        }

        if containsAny(normalized, keywords: ["总体", "整体", "总评", "怎么看", "解读"]) {
            return .general
        }

        return .unknown
    }

    private func containsAny(_ text: String, keywords: [String]) -> Bool {
        keywords.contains { text.contains($0) }
    }
}
