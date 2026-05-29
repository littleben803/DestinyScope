//
//  LocalModelFileImporter.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/29.
//

import Foundation

struct LocalModelFileImporter {
    private let resolver: LocalModelFileResolver

    init(resolver: LocalModelFileResolver = LocalModelFileResolver()) {
        self.resolver = resolver
    }

    func importModel(from sourceURL: URL) throws -> URL {
        guard sourceURL.pathExtension.lowercased() == "gguf" else {
            throw LocalModelFileImportError.invalidFileExtension(sourceURL.lastPathComponent)
        }

        let didStartAccessing = sourceURL.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                sourceURL.stopAccessingSecurityScopedResource()
            }
        }

        try resolver.ensureAppDocumentsModelDirectoryExists()

        let destinationURL = resolver.appDocumentsModelFileURL()
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.removeItem(at: destinationURL)
        }

        try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
        return destinationURL
    }
}

enum LocalModelFileImportError: LocalizedError, Equatable {
    case invalidFileExtension(String)

    var errorDescription: String? {
        switch self {
        case .invalidFileExtension(let fileName):
            return "请选择 .gguf 模型文件：\(fileName)"
        }
    }
}
