//
//  KnowledgeRepository.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import Foundation

enum KnowledgeRepositoryError: LocalizedError {
    case articleNotFound(String)

    var errorDescription: String? {
        switch self {
        case let .articleNotFound(id):
            return "未找到知识库文章：\(id)"
        }
    }
}

struct KnowledgeRepository {
    private let loader: JSONResourceLoader
    private let resourceName: String
    private let resourceSubdirectory: String?

    init(
        loader: JSONResourceLoader = JSONResourceLoader(),
        resourceName: String = "knowledge_articles",
        resourceSubdirectory: String? = nil
    ) {
        self.loader = loader
        self.resourceName = resourceName
        self.resourceSubdirectory = resourceSubdirectory
    }

    func articles() throws -> [KnowledgeArticle] {
        try loader.load([KnowledgeArticle].self, named: resourceName, subdirectory: resourceSubdirectory)
    }

    func article(id: String) throws -> KnowledgeArticle {
        guard let article = try articles().first(where: { $0.id == id }) else {
            throw KnowledgeRepositoryError.articleNotFound(id)
        }
        return article
    }

    func articles(category: String) throws -> [KnowledgeArticle] {
        try articles().filter { $0.category == category }
    }
}
