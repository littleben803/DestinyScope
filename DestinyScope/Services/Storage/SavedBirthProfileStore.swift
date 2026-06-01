//
//  SavedBirthProfileStore.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct SavedBirthProfileStore {
    private let fileName = "saved_birth_profiles.json"
    private let maxProfileCount = 20
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func load() throws -> [SavedBirthProfile] {
        let url = try storageURL()

        guard fileManager.fileExists(atPath: url.path) else {
            return []
        }

        let data = try Data(contentsOf: url)
        let profiles = try JSONDecoder.savedBirthProfileDecoder.decode([SavedBirthProfile].self, from: data)
        return profiles.sorted { $0.updatedAt > $1.updatedAt }
    }

    func save(_ profiles: [SavedBirthProfile]) throws {
        let url = try storageURL()
        let sortedProfiles = profiles
            .sorted { $0.updatedAt > $1.updatedAt }
            .prefix(maxProfileCount)
        let data = try JSONEncoder.savedBirthProfileEncoder.encode(Array(sortedProfiles))
        try data.write(to: url, options: [.atomic])
    }

    func add(_ profile: SavedBirthProfile) throws {
        var profiles = try load()
        profiles.removeAll { $0.id == profile.id }
        profiles.insert(profile, at: 0)
        try save(profiles)
    }

    func update(_ profile: SavedBirthProfile) throws {
        var profiles = try load()
        profiles.removeAll { $0.id == profile.id }
        profiles.insert(profile, at: 0)
        try save(profiles)
    }

    func delete(id: UUID) throws {
        var profiles = try load()
        profiles.removeAll { $0.id == id }
        try save(profiles)
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
    static var savedBirthProfileDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

private extension JSONEncoder {
    static var savedBirthProfileEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }
}
