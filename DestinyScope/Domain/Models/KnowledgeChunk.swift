//
//  KnowledgeChunk.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/8.
//

import Foundation

enum KnowledgeScene: String, CaseIterable, Codable, Equatable {
    case homeDestinyDetail = "home_destiny_detail"
    case wuxingBalance = "wuxing_balance"
    case dailyQi = "daily_qi"
    case qa
    case encyclopedia

    init?(snakeCase: String) {
        let normalized = snakeCase
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "-", with: "_")
            .lowercased()

        switch normalized {
        case "home_destiny_detail", "home":
            self = .homeDestinyDetail
        case "wuxing_balance", "five_elements_balance":
            self = .wuxingBalance
        case "daily_qi", "daily":
            self = .dailyQi
        case "qa", "question_answer":
            self = .qa
        case "encyclopedia", "knowledge_library":
            self = .encyclopedia
        default:
            return nil
        }
    }

    var sceneAliases: Set<String> {
        switch self {
        case .homeDestinyDetail:
            return [
                rawValue,
                "knowledge_library",
                "rag_retrieval",
                "traditional_culture",
                "usage_boundary",
                "wuxing_foundation",
                "yinyang_foundation",
                "ganzhi_foundation",
                "yixue_foundation",
                "bagua_foundation"
            ]
        case .wuxingBalance:
            return [
                rawValue,
                "knowledge_library",
                "rag_retrieval",
                "traditional_culture",
                "usage_boundary",
                "wuxing_foundation",
                "yinyang_foundation"
            ]
        case .dailyQi:
            return [
                rawValue,
                "knowledge_library",
                "rag_retrieval",
                "traditional_culture",
                "usage_boundary",
                "ganzhi_foundation",
                "wuxing_foundation",
                "yinyang_foundation"
            ]
        case .qa:
            return [
                rawValue,
                "knowledge_library",
                "rag_retrieval",
                "traditional_culture",
                "usage_boundary",
                "wuxing_foundation",
                "yinyang_foundation",
                "ganzhi_foundation",
                "yixue_foundation",
                "bagua_foundation"
            ]
        case .encyclopedia:
            return [
                rawValue,
                "knowledge_library",
                "rag_retrieval",
                "traditional_culture",
                "usage_boundary"
            ]
        }
    }

    func matchScore(for rawScenes: [String]) -> Double {
        let normalizedScenes = rawScenes.map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "-", with: "_")
                .lowercased()
        }
        let sceneSet = Set(normalizedScenes)

        if sceneSet.contains(rawValue) {
            return 14
        }

        let matchedAliases = sceneSet.intersection(sceneAliases)
        guard !matchedAliases.isEmpty else {
            return 0
        }

        if matchedAliases.contains("rag_retrieval") || matchedAliases.contains("knowledge_library") {
            return matchedAliases.count > 1 ? 6 : 2
        }

        return 8
    }
}

struct KnowledgeChunk: Codable, Identifiable, Equatable {
    let id: String
    let articleId: String
    let category: String
    let title: String
    let text: String
    let tags: [String]
    let scenes: [String]
    let riskLevel: String
    let qualityScore: Int
    let usageBoundary: String?
    let source: String?
    let version: String?

    var isSafeForRuntimeRAG: Bool {
        riskLevel.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "safe"
            && qualityScore >= 70
    }
}
