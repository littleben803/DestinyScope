//
//  HistoryRecordStore.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct HistoryRecordStore {
    private let fileName = "history_records.json"
    private let maxRecordCount = 50
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func load() throws -> [HistoryRecord] {
        let url = try storageURL()

        guard fileManager.fileExists(atPath: url.path) else {
            return []
        }

        let data = try Data(contentsOf: url)
        let records = try JSONDecoder.historyDecoder.decode([HistoryRecord].self, from: data)
        return records.sorted { $0.createdAt > $1.createdAt }
    }

    func save(_ records: [HistoryRecord]) throws {
        let url = try storageURL()
        let sortedRecords = records
            .sorted { $0.createdAt > $1.createdAt }
            .prefix(maxRecordCount)
        let data = try JSONEncoder.historyEncoder.encode(Array(sortedRecords))
        try data.write(to: url, options: [.atomic])
    }

    func add(_ record: HistoryRecord) throws {
        var records = try load()
        records.removeAll { $0.id == record.id }
        records.insert(record, at: 0)
        try save(records)
    }

    func delete(id: UUID) throws {
        var records = try load()
        records.removeAll { $0.id == id }
        try save(records)
    }

    func deleteAll() throws {
        try save([])
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
    static var historyDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

private extension JSONEncoder {
    static var historyEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }
}
