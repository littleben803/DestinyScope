//
//  KnowledgeLibraryStateStore.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct KnowledgeLibraryState: Codable, Equatable {
    var favoriteArticleIDs: [String]
    var recentReads: [KnowledgeReadingRecord]

    static let empty = KnowledgeLibraryState(favoriteArticleIDs: [], recentReads: [])
}

struct KnowledgeLibraryStateStore {
    private let fileName = "knowledge_library_state.json"
    private let maxFavoriteCount = 100
    private let maxRecentReadCount = 20
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func load() throws -> KnowledgeLibraryState {
        let url = try storageURL()

        guard fileManager.fileExists(atPath: url.path) else {
            return .empty
        }

        let data = try Data(contentsOf: url)
        let state = try JSONDecoder.knowledgeLibraryDecoder.decode(KnowledgeLibraryState.self, from: data)
        return normalized(state)
    }

    func save(_ state: KnowledgeLibraryState) throws {
        let url = try storageURL()
        let data = try JSONEncoder.knowledgeLibraryEncoder.encode(normalized(state))
        try data.write(to: url, options: [.atomic])
    }

    func isFavorite(articleId: String) -> Bool {
        (try? load().favoriteArticleIDs.contains(articleId)) ?? false
    }

    func toggleFavorite(articleId: String) throws {
        var state = try load()
        if state.favoriteArticleIDs.contains(articleId) {
            state.favoriteArticleIDs.removeAll { $0 == articleId }
        } else {
            state.favoriteArticleIDs.insert(articleId, at: 0)
        }
        try save(state)
    }

    func addRecentRead(articleId: String) throws {
        var state = try load()
        state.recentReads.removeAll { $0.articleId == articleId }
        state.recentReads.insert(KnowledgeReadingRecord(articleId: articleId, viewedAt: Date()), at: 0)
        try save(state)
    }

    func clearRecentReads() throws {
        var state = try load()
        state.recentReads = []
        try save(state)
    }

    func clearFavorites() throws {
        var state = try load()
        state.favoriteArticleIDs = []
        try save(state)
    }

    func deleteFavorite(articleId: String) throws {
        var state = try load()
        state.favoriteArticleIDs.removeAll { $0 == articleId }
        try save(state)
    }

    private func normalized(_ state: KnowledgeLibraryState) -> KnowledgeLibraryState {
        var seenFavorites = Set<String>()
        let favorites = state.favoriteArticleIDs
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .filter { seenFavorites.insert($0).inserted }
            .prefix(maxFavoriteCount)

        var seenRecentReads = Set<String>()
        let recentReads = state.recentReads
            .sorted { $0.viewedAt > $1.viewedAt }
            .filter { !$0.articleId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .filter { seenRecentReads.insert($0.articleId).inserted }
            .prefix(maxRecentReadCount)

        return KnowledgeLibraryState(
            favoriteArticleIDs: Array(favorites),
            recentReads: Array(recentReads)
        )
    }

    private func storageURL() throws -> URL {
        let directory = try fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("DestinyScope", isDirectory: true)

        if !fileManager.fileExists(atPath: directory.path) {
            try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        }

        return directory.appendingPathComponent(fileName)
    }
}

private extension JSONDecoder {
    static var knowledgeLibraryDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

private extension JSONEncoder {
    static var knowledgeLibraryEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }
}
