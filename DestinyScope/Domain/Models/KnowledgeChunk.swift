//
//  KnowledgeChunk.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/8.
//

import Foundation

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

    var isSafeForKnowledgeSearch: Bool {
        riskLevel.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "safe"
            && qualityScore >= 70
    }
}
