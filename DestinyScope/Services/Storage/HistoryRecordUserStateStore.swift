//
//  HistoryRecordUserStateStore.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct HistoryRecordUserStateStore {
    private let fileName = "history_record_user_state.json"
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func load() throws -> HistoryRecordUserState {
        let url = try storageURL()

        guard fileManager.fileExists(atPath: url.path) else {
            return .empty
        }

        let data = try Data(contentsOf: url)
        let state = try JSONDecoder.historyUserStateDecoder.decode(HistoryRecordUserState.self, from: data)
        return normalized(state)
    }

    func save(_ state: HistoryRecordUserState) throws {
        let url = try storageURL()
        let data = try JSONEncoder.historyUserStateEncoder.encode(normalized(state))
        try data.write(to: url, options: [.atomic])
    }

    func isFavorite(id: UUID) -> Bool {
        (try? load().favoriteRecordIDs.contains(id)) ?? false
    }

    func toggleFavorite(id: UUID) throws {
        var state = try load()
        if state.favoriteRecordIDs.contains(id) {
            state.favoriteRecordIDs.removeAll { $0 == id }
        } else {
            state.favoriteRecordIDs.insert(id, at: 0)
        }
        state.updatedAt = Date()
        try save(state)
    }

    func isPinned(id: UUID) -> Bool {
        (try? load().pinnedRecordIDs.contains(id)) ?? false
    }

    func togglePinned(id: UUID) throws {
        var state = try load()
        if state.pinnedRecordIDs.contains(id) {
            state.pinnedRecordIDs.removeAll { $0 == id }
        } else {
            state.pinnedRecordIDs.insert(id, at: 0)
        }
        state.updatedAt = Date()
        try save(state)
    }

    func remove(id: UUID) throws {
        var state = try load()
        state.favoriteRecordIDs.removeAll { $0 == id }
        state.pinnedRecordIDs.removeAll { $0 == id }
        state.updatedAt = Date()
        try save(state)
    }

    func clearAll() throws {
        try save(HistoryRecordUserState(favoriteRecordIDs: [], pinnedRecordIDs: [], updatedAt: Date()))
    }

    private func normalized(_ state: HistoryRecordUserState) -> HistoryRecordUserState {
        var seenFavorites = Set<UUID>()
        let favoriteIDs = state.favoriteRecordIDs.filter { seenFavorites.insert($0).inserted }

        var seenPinned = Set<UUID>()
        let pinnedIDs = state.pinnedRecordIDs.filter { seenPinned.insert($0).inserted }

        return HistoryRecordUserState(
            favoriteRecordIDs: favoriteIDs,
            pinnedRecordIDs: pinnedIDs,
            updatedAt: state.updatedAt
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
    static var historyUserStateDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

private extension JSONEncoder {
    static var historyUserStateEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }
}
