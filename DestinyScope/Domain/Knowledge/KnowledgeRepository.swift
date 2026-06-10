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
    private let chunkResourceName: String
    private let resourceSubdirectory: String?

    init(
        loader: JSONResourceLoader = JSONResourceLoader(),
        resourceName: String = "destiny_knowledge_articles",
        chunkResourceName: String = "destiny_rag_chunks",
        resourceSubdirectory: String? = nil
    ) {
        self.loader = loader
        self.resourceName = resourceName
        self.chunkResourceName = chunkResourceName
        self.resourceSubdirectory = resourceSubdirectory
    }

    func loadArticles() throws -> [KnowledgeArticle] {
        try loader.load([KnowledgeArticle].self, named: resourceName, subdirectory: resourceSubdirectory)
    }

    func loadChunks() throws -> [KnowledgeChunk] {
        try loader.load([KnowledgeChunk].self, named: chunkResourceName, subdirectory: resourceSubdirectory)
    }

    func article(by id: String) throws -> KnowledgeArticle {
        guard let article = try loadArticles().first(where: { $0.id == id }) else {
            throw KnowledgeRepositoryError.articleNotFound(id)
        }
        return article
    }

    func articles(for category: String) throws -> [KnowledgeArticle] {
        try loadArticles().filter { Self.matches($0.category, category) }
    }

    func searchArticles(
        keyword: String? = nil,
        category: String? = nil,
        tags: [String] = [],
        limit: Int = 20
    ) throws -> [KnowledgeArticle] {
        let keywords = Self.keywords(from: keyword ?? "")
        let normalizedCategory = Self.normalized(category)
        let normalizedTags = Self.normalizedTags(tags)
        let hasSearchTerms = !keywords.isEmpty || normalizedCategory != nil || !normalizedTags.isEmpty

        guard limit > 0 else {
            return []
        }

        return try loadArticles()
            .filter { article in
                Self.matchesCategory(article.category, normalizedCategory)
                    && Self.matchesRequiredTags(article.tags, normalizedTags)
            }
            .compactMap { article -> ScoredKnowledgeArticle? in
                let score = Self.score(article: article, keywords: keywords, requiredTags: normalizedTags)
                guard !hasSearchTerms || score > 0 else {
                    return nil
                }
                return ScoredKnowledgeArticle(article: article, score: score)
            }
            .sorted { left, right in
                if left.score == right.score {
                    return left.article.id < right.article.id
                }
                return left.score > right.score
            }
            .prefix(limit)
            .map(\.article)
    }

    func searchChunks(
        keyword: String? = nil,
        category: String? = nil,
        tags: [String] = [],
        limit: Int = 20
    ) throws -> [KnowledgeChunk] {
        let keywords = Self.keywords(from: keyword ?? "")
        let normalizedCategory = Self.normalized(category)
        let normalizedTags = Self.normalizedTags(tags)
        let hasSearchTerms = !keywords.isEmpty || normalizedCategory != nil || !normalizedTags.isEmpty

        guard limit > 0 else {
            return []
        }

        return try loadChunks()
            .filter(\.isSafeForKnowledgeSearch)
            .filter { chunk in
                Self.matchesCategory(chunk.category, normalizedCategory)
                    && Self.matchesRequiredTags(chunk.tags, normalizedTags)
            }
            .compactMap { chunk -> ScoredKnowledgeChunk? in
                let score = Self.score(chunk: chunk, keywords: keywords, requiredTags: normalizedTags)
                guard !hasSearchTerms || score > 0 else {
                    return nil
                }
                return ScoredKnowledgeChunk(chunk: chunk, score: score)
            }
            .sorted { left, right in
                if left.score == right.score {
                    if left.chunk.qualityScore == right.chunk.qualityScore {
                        return left.chunk.id < right.chunk.id
                    }
                    return left.chunk.qualityScore > right.chunk.qualityScore
                }
                return left.score > right.score
            }
            .prefix(limit)
            .map(\.chunk)
    }

    func articles() throws -> [KnowledgeArticle] {
        try loadArticles()
    }

    func article(id: String) throws -> KnowledgeArticle {
        try article(by: id)
    }

    func articles(category: String) throws -> [KnowledgeArticle] {
        try articles(for: category)
    }

    func chunks() throws -> [KnowledgeChunk] {
        try loadChunks()
    }
}

private struct ScoredKnowledgeArticle {
    let article: KnowledgeArticle
    let score: Double
}

private struct ScoredKnowledgeChunk {
    let chunk: KnowledgeChunk
    let score: Double
}

private extension KnowledgeRepository {
    static func keywords(from query: String) -> [String] {
        query
            .components(separatedBy: CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters))
            .flatMap { component in
                component
                    .components(separatedBy: CharacterSet(charactersIn: "，。、！？；：,.!?;:()（）[]【】「」“”\"'"))
            }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    static func normalizedKeywords(_ keywords: [String]) -> [String] {
        var seen = Set<String>()
        var output: [String] = []

        for keyword in keywords {
            let normalized = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !normalized.isEmpty else {
                continue
            }

            let key = normalized.lowercased()
            guard !seen.contains(key) else {
                continue
            }

            seen.insert(key)
            output.append(normalized)
        }

        return output
    }

    static func normalized(_ value: String?) -> String? {
        guard let value else {
            return nil
        }

        let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return normalized.isEmpty ? nil : normalized
    }

    static func normalizedTags(_ tags: [String]) -> [String] {
        normalizedKeywords(tags)
    }

    static func matches(_ left: String, _ right: String) -> Bool {
        left.trimmingCharacters(in: .whitespacesAndNewlines)
            .localizedCaseInsensitiveCompare(right.trimmingCharacters(in: .whitespacesAndNewlines)) == .orderedSame
    }

    static func matchesCategory(_ category: String, _ requiredCategory: String?) -> Bool {
        guard let requiredCategory else {
            return true
        }
        return matches(category, requiredCategory)
    }

    static func matchesRequiredTags(_ itemTags: [String], _ requiredTags: [String]) -> Bool {
        guard !requiredTags.isEmpty else {
            return true
        }

        return requiredTags.allSatisfy { requiredTag in
            itemTags.contains { tag in
                matches(tag, requiredTag)
                    || tag.localizedCaseInsensitiveContains(requiredTag)
            }
        }
    }

    static func score(article: KnowledgeArticle, keywords: [String], requiredTags: [String]) -> Double {
        var totalScore = requiredTags.reduce(0.0) { partialResult, tag in
            partialResult + score(tag: tag, tags: article.tags)
        }

        for keyword in keywords {
            totalScore += score(keyword: keyword, article: article)
        }

        return totalScore
    }

    static func score(chunk: KnowledgeChunk, keywords: [String], requiredTags: [String]) -> Double {
        var totalScore = requiredTags.reduce(0.0) { partialResult, tag in
            partialResult + score(tag: tag, tags: chunk.tags)
        }

        for keyword in keywords {
            totalScore += score(keyword: keyword, chunk: chunk)
        }

        if totalScore > 0 {
            totalScore += min(Double(max(chunk.qualityScore - 70, 0)) / 10.0, 4.0)
        }

        return totalScore
    }

    static func score(keyword: String, article: KnowledgeArticle) -> Double {
        var score = 0.0
        let keywordLowercased = keyword.lowercased()

        if article.title == keyword {
            score += 30
        } else if article.title.localizedCaseInsensitiveContains(keyword) {
            score += 22
        } else if article.title.lowercased().contains(keywordLowercased) {
            score += 18
        }

        if article.category.localizedCaseInsensitiveContains(keyword) {
            score += 10
        }

        score += Self.score(tag: keyword, tags: article.tags)

        if article.summary.localizedCaseInsensitiveContains(keyword) {
            score += 8
        }

        if article.body.localizedCaseInsensitiveContains(keyword) {
            score += 4
        }

        return score
    }

    static func score(keyword: String, chunk: KnowledgeChunk) -> Double {
        var score = 0.0
        let keywordLowercased = keyword.lowercased()

        if chunk.title == keyword {
            score += 30
        } else if chunk.title.localizedCaseInsensitiveContains(keyword) {
            score += 22
        } else if chunk.title.lowercased().contains(keywordLowercased) {
            score += 18
        }

        if chunk.category.localizedCaseInsensitiveContains(keyword) {
            score += 10
        }

        score += Self.score(tag: keyword, tags: chunk.tags)

        if chunk.text.localizedCaseInsensitiveContains(keyword) {
            score += 7
        } else if chunk.text.lowercased().contains(keywordLowercased) {
            score += 5
        }

        return score
    }

    static func score(tag requiredTag: String, tags: [String]) -> Double {
        var score = 0.0

        for tag in tags {
            if matches(tag, requiredTag) {
                score += 16
            } else if tag.localizedCaseInsensitiveContains(requiredTag) {
                score += 12
            }
        }

        return score
    }
}
