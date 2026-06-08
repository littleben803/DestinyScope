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
        resourceName: String = "knowledge_articles",
        chunkResourceName: String = "rag_chunks",
        resourceSubdirectory: String? = nil
    ) {
        self.loader = loader
        self.resourceName = resourceName
        self.chunkResourceName = chunkResourceName
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

    func chunks() throws -> [KnowledgeChunk] {
        try loader.load([KnowledgeChunk].self, named: chunkResourceName, subdirectory: resourceSubdirectory)
    }

    func searchChunks(query: String, scene: KnowledgeScene, topK: Int) throws -> [KnowledgeChunk] {
        try searchChunks(keywords: Self.keywords(from: query), scene: scene, topK: topK)
    }

    func searchChunks(keywords: [String], scene: KnowledgeScene, topK: Int) throws -> [KnowledgeChunk] {
        let normalizedKeywords = Self.normalizedKeywords(keywords)
        guard topK > 0, !normalizedKeywords.isEmpty else {
            return []
        }

        let scoredChunks = try chunks()
            .filter(\.isSafeForRuntimeRAG)
            .compactMap { chunk -> ScoredKnowledgeChunk? in
                let score = Self.score(chunk: chunk, keywords: normalizedKeywords, scene: scene)
                guard score > 0 else {
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

        var seenArticleIDs = Set<String>()
        var results: [KnowledgeChunk] = []

        for scoredChunk in scoredChunks {
            guard !seenArticleIDs.contains(scoredChunk.chunk.articleId) else {
                continue
            }

            seenArticleIDs.insert(scoredChunk.chunk.articleId)
            results.append(scoredChunk.chunk)

            if results.count >= topK {
                break
            }
        }

        return results
    }
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

    static func score(chunk: KnowledgeChunk, keywords: [String], scene: KnowledgeScene) -> Double {
        var totalScore = scene.matchScore(for: chunk.scenes)

        for keyword in keywords {
            totalScore += score(keyword: keyword, chunk: chunk)
        }

        if totalScore > 0 {
            totalScore += min(Double(max(chunk.qualityScore - 70, 0)) / 10.0, 4.0)
        }

        return totalScore
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

        for tag in chunk.tags {
            if tag == keyword {
                score += 16
            } else if tag.localizedCaseInsensitiveContains(keyword) {
                score += 12
            }
        }

        if chunk.text.localizedCaseInsensitiveContains(keyword) {
            score += 7
        } else if chunk.text.lowercased().contains(keywordLowercased) {
            score += 5
        }

        return score
    }
}
