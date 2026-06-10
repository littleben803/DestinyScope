//
//  KnowledgeSearchHistoryStore.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/10.
//

import Foundation

struct KnowledgeSearchHistoryStore {
    private let fileName = "knowledge_search_history.json"
    private let maxHistoryCount = 20
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func load() throws -> [String] {
        let url = try storageURL()

        guard fileManager.fileExists(atPath: url.path) else {
            return []
        }

        let data = try Data(contentsOf: url)
        let terms = try JSONDecoder().decode([String].self, from: data)
        return normalized(terms)
    }

    func save(_ terms: [String]) throws {
        let url = try storageURL()
        let data = try JSONEncoder.knowledgeSearchHistoryEncoder.encode(normalized(terms))
        try data.write(to: url, options: [.atomic])
    }

    func add(_ term: String) throws {
        let normalizedTerm = normalize(term)
        guard !normalizedTerm.isEmpty else {
            return
        }

        var terms = try load()
        terms.removeAll { $0.caseInsensitiveCompare(normalizedTerm) == .orderedSame }
        terms.insert(normalizedTerm, at: 0)
        try save(terms)
    }

    func clear() throws {
        try save([])
    }

    private func normalized(_ terms: [String]) -> [String] {
        var seen = Set<String>()

        return terms
            .map(normalize)
            .filter { !$0.isEmpty }
            .filter { seen.insert($0.lowercased()).inserted }
            .prefix(maxHistoryCount)
            .map { $0 }
    }

    private func normalize(_ term: String) -> String {
        term.trimmingCharacters(in: .whitespacesAndNewlines)
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

private extension JSONEncoder {
    static var knowledgeSearchHistoryEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }
}
