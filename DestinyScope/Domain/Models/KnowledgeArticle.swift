//
//  KnowledgeArticle.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import Foundation

struct KnowledgeArticle: Codable, Identifiable, Equatable {
    let id: String
    let category: String
    let title: String
    let summary: String
    let body: String
    let tags: [String]
    let source: String?
    let version: String
}
