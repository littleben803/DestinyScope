//
//  LocalModelDebugConfig.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct LocalModelDebugConfig: Equatable {
    let isDebugFeatureEnabled: Bool
    let expectedModelFileName: String
    let primaryModelPath: String
    let fallbackModelPath: String
    let sandboxModelPaths: [String]
    let llamaFrameworkPath: String
    let modelDirectoryDescription: String

    static var current: LocalModelDebugConfig {
        #if DEBUG
        let isEnabled = true
        #else
        let isEnabled = false
        #endif

        return LocalModelDebugConfig(
            isDebugFeatureEnabled: isEnabled,
            expectedModelFileName: "qwen2.5-0.5b-instruct-q4_k_m.gguf",
            primaryModelPath: "/Users/bytedance/LocalModels/DestinyScope/qwen2.5-0.5b-instruct-q4_k_m.gguf",
            fallbackModelPath: "/Users/bytedance/LocalModels/DestinyScope/qwen2_5_0_5b_instruct_q4.gguf",
            sandboxModelPaths: Self.sandboxModelPaths(fileNames: [
                "qwen2.5-0.5b-instruct-q4_k_m.gguf",
                "qwen2_5_0_5b_instruct_q4.gguf"
            ]),
            llamaFrameworkPath: "/Users/bytedance/LocalModels/DestinyScope/llama.xcframework",
            modelDirectoryDescription: "Simulator 可用 Mac 本地路径；真机必须把模型手工放入 App 沙盒 Documents/LocalModels/DestinyScope 或 Application Support/LocalModels/DestinyScope。模型文件不得提交仓库或进入 Release 默认路径。"
        )
    }

    var modelPathCandidates: [String] {
        let orderedPaths = [
            appDocumentsModelFileURL().path,
            primaryModelPath,
            fallbackModelPath
        ] + sandboxModelPaths

        return Array(NSOrderedSet(array: orderedPaths)) as? [String] ?? orderedPaths
    }

    func appDocumentsModelDirectoryURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("LocalModels", isDirectory: true)
            .appendingPathComponent("DestinyScope", isDirectory: true)
    }

    func appDocumentsModelFileURL() -> URL {
        appDocumentsModelDirectoryURL()
            .appendingPathComponent(expectedModelFileName)
    }

    func ensureAppDocumentsModelDirectoryExists() throws {
        try FileManager.default.createDirectory(
            at: appDocumentsModelDirectoryURL(),
            withIntermediateDirectories: true,
            attributes: nil
        )
    }

    func modelExistsInAppDocuments() -> Bool {
        var isDirectory: ObjCBool = false
        let path = appDocumentsModelFileURL().path
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && !isDirectory.boolValue
    }

    func expandedPath(_ path: String) -> String {
        (path as NSString).expandingTildeInPath
    }

    func existingModelPath() -> String? {
        modelPathCandidates
            .map(expandedPath)
            .first { FileManager.default.fileExists(atPath: $0) }
    }

    func llamaFrameworkExists() -> Bool {
        var isDirectory: ObjCBool = false
        let expanded = expandedPath(llamaFrameworkPath)
        return FileManager.default.fileExists(atPath: expanded, isDirectory: &isDirectory) && isDirectory.boolValue
    }

    func modelFileStatuses() -> [LocalModelFileStatus] {
        modelPathCandidates.map { candidate in
            modelFileStatus(for: candidate)
        }
    }

    func currentModelFileStatuses() -> [LocalModelFileStatus] {
        let statuses = modelFileStatuses()
        if let existingStatus = statuses.first(where: { $0.exists }) {
            return [existingStatus]
        }

        return statuses
    }

    func modelFileStatus(for path: String) -> LocalModelFileStatus {
        let expanded = expandedPath(path)
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: expanded, isDirectory: &isDirectory)
        let size: UInt64?

        if exists, !isDirectory.boolValue {
            let attributes = try? FileManager.default.attributesOfItem(atPath: expanded)
            size = attributes?[.size] as? UInt64
        } else {
            size = nil
        }

        return LocalModelFileStatus(
            displayPath: path,
            expandedPath: expanded,
            exists: exists && !isDirectory.boolValue,
            sizeInBytes: size
        )
    }

    private static func sandboxModelPaths(fileNames: [String]) -> [String] {
        let fileManager = FileManager.default
        let baseDirectories = [
            fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
            fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first,
            URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        ].compactMap { $0 }

        return baseDirectories.flatMap { baseURL in
            fileNames.map { fileName in
                baseURL
                    .appendingPathComponent("LocalModels", isDirectory: true)
                    .appendingPathComponent("DestinyScope", isDirectory: true)
                    .appendingPathComponent(fileName)
                    .path
            }
        }
    }
}

struct LocalModelFileStatus: Equatable, Identifiable {
    var id: String { expandedPath }

    let displayPath: String
    let expandedPath: String
    let exists: Bool
    let sizeInBytes: UInt64?

    var sizeDescription: String {
        guard let sizeInBytes else {
            return "未知"
        }

        return ByteCountFormatter.string(fromByteCount: Int64(sizeInBytes), countStyle: .file)
    }
}
