//
//  LocalModelFileStatus.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/29.
//

import Foundation

enum LocalModelFileSource: String {
    case appDocuments
    case developerLocalModels
    case notFound

    var displayName: String {
        switch self {
        case .appDocuments:
            return "App Documents"
        case .developerLocalModels:
            return "Developer LocalModels"
        case .notFound:
            return "Not Found"
        }
    }
}

struct LocalModelFileStatus: Equatable, Identifiable {
    var id: String { expandedPath }

    let expectedFileName: String
    let resolvedURL: URL?
    let exists: Bool
    let fileSize: Int64?
    let source: LocalModelFileSource
    let reason: String?

    var isUsable: Bool {
        exists &&
            resolvedURL?.pathExtension.lowercased() == "gguf" &&
            (fileSize ?? 0) > 0 &&
            isSupportedFileName
    }

    var fileSizeText: String {
        guard let fileSize else {
            return "未知"
        }

        return ByteCountFormatter.string(fromByteCount: fileSize, countStyle: .file)
    }

    var displayPath: String {
        resolvedURL?.path ?? expectedFileName
    }

    var expandedPath: String {
        resolvedURL?.path ?? expectedFileName
    }

    var sizeDescription: String {
        fileSizeText
    }

    private var isSupportedFileName: Bool {
        guard let fileName = resolvedURL?.lastPathComponent else {
            return false
        }

        return fileName == LocalModelFileResolver.expectedFileName ||
            fileName == LocalModelFileResolver.aliasFileName
    }
}
