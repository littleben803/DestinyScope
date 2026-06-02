//
//  LocalModelFileResolver.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/29.
//

import Foundation

struct LocalModelFileResolver {
    static let expectedFileName = "qwen2.5-0.5b-instruct-q4_k_m.gguf"
    static let aliasFileName = "qwen2_5_0_5b_instruct_q4.gguf"

    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    var expectedFileName: String {
        Self.expectedFileName
    }

    var aliasFileName: String {
        Self.aliasFileName
    }

    func appDocumentsModelDirectoryURL() -> URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("LocalModels", isDirectory: true)
            .appendingPathComponent("DestinyScope", isDirectory: true)
    }

    func bundledModelFileURL() -> URL? {
        Bundle.main.url(
            forResource: Self.expectedFileName.replacingOccurrences(of: ".gguf", with: ""),
            withExtension: "gguf"
        ) ?? Bundle.main.url(
            forResource: Self.expectedFileName.replacingOccurrences(of: ".gguf", with: ""),
            withExtension: "gguf",
            subdirectory: "Models"
        ) ?? Bundle.main.url(
            forResource: Self.expectedFileName.replacingOccurrences(of: ".gguf", with: ""),
            withExtension: "gguf",
            subdirectory: "Resources/Models"
        )
    }

    func appDocumentsModelFileURL() -> URL {
        appDocumentsModelDirectoryURL()
            .appendingPathComponent(Self.expectedFileName)
    }

    func appDocumentsAliasFileURL() -> URL {
        appDocumentsModelDirectoryURL()
            .appendingPathComponent(Self.aliasFileName)
    }

    func developerLocalModelsDirectoryURL() -> URL {
        developerHomeDirectoryURL()
            .appendingPathComponent("LocalModels", isDirectory: true)
            .appendingPathComponent("DestinyScope", isDirectory: true)
    }

    func developerLocalModelsFileURL() -> URL {
        developerLocalModelsDirectoryURL()
            .appendingPathComponent(Self.expectedFileName)
    }

    func developerLocalModelsAliasFileURL() -> URL {
        developerLocalModelsDirectoryURL()
            .appendingPathComponent(Self.aliasFileName)
    }

    func ensureAppDocumentsModelDirectoryExists() throws {
        try fileManager.createDirectory(
            at: appDocumentsModelDirectoryURL(),
            withIntermediateDirectories: true,
            attributes: nil
        )
    }

    func resolveModelFileStatus() -> LocalModelFileStatus {
        candidateStatuses().first(where: { $0.isUsable }) ??
            LocalModelFileStatus(
                expectedFileName: Self.expectedFileName,
                resolvedURL: nil,
                exists: false,
                fileSize: nil,
                source: .notFound,
                reason: "未找到本地模型文件。"
            )
    }

    func candidateStatuses() -> [LocalModelFileStatus] {
        candidateURLs().map { candidate in
            status(for: candidate.url, source: candidate.source)
        }
    }

    private func candidateURLs() -> [(url: URL, source: LocalModelFileSource)] {
        var candidates: [(url: URL, source: LocalModelFileSource)] = []

        if let bundledModelURL = bundledModelFileURL() {
            candidates.append((bundledModelURL, .appBundle))
        }

        candidates.append(contentsOf: [
            (appDocumentsModelFileURL(), .appDocuments),
            (appDocumentsAliasFileURL(), .appDocuments)
        ])

        if DeviceModelIdentifier.isRunningOnSimulator {
            candidates.append(contentsOf: [
                (developerLocalModelsFileURL(), .developerLocalModels),
                (developerLocalModelsAliasFileURL(), .developerLocalModels)
            ])
        }

        return candidates
    }

    private func developerHomeDirectoryURL() -> URL {
        #if targetEnvironment(simulator)
        if let simulatorHostHome = ProcessInfo.processInfo.environment["SIMULATOR_HOST_HOME"],
           !simulatorHostHome.isEmpty {
            return URL(fileURLWithPath: simulatorHostHome, isDirectory: true)
        }

        return URL(fileURLWithPath: "/Users/bytedance", isDirectory: true)
        #else
        return URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
        #endif
    }

    private func status(for url: URL, source: LocalModelFileSource) -> LocalModelFileStatus {
        var isDirectory: ObjCBool = false
        let exists = fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) && !isDirectory.boolValue
        let fileSize: Int64?

        if exists {
            let attributes = try? fileManager.attributesOfItem(atPath: url.path)
            if let size = attributes?[.size] as? NSNumber {
                fileSize = size.int64Value
            } else {
                fileSize = nil
            }
        } else {
            fileSize = nil
        }

        let reason: String?
        if !exists {
            reason = "未找到本地模型文件。"
        } else if url.pathExtension.lowercased() != "gguf" {
            reason = "模型文件扩展名不是 .gguf。"
        } else if (fileSize ?? 0) <= 0 {
            reason = "模型文件为空。"
        } else if url.lastPathComponent != Self.expectedFileName && url.lastPathComponent != Self.aliasFileName {
            reason = "模型文件名不在允许列表中。"
        } else {
            reason = nil
        }

        return LocalModelFileStatus(
            expectedFileName: Self.expectedFileName,
            resolvedURL: url,
            exists: exists,
            fileSize: fileSize,
            source: source,
            reason: reason
        )
    }
}
