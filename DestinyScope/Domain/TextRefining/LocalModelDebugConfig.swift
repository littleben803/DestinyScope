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

    private var fileResolver: LocalModelFileResolver {
        LocalModelFileResolver()
    }

    static var current: LocalModelDebugConfig {
        #if DEBUG
        let isEnabled = true
        #else
        let isEnabled = false
        #endif

        return LocalModelDebugConfig(
            isDebugFeatureEnabled: isEnabled,
            expectedModelFileName: LocalModelFileResolver.expectedFileName,
            primaryModelPath: "/Users/bytedance/LocalModels/DestinyScope/qwen2.5-0.5b-instruct-q4_k_m.gguf",
            fallbackModelPath: "/Users/bytedance/LocalModels/DestinyScope/qwen2_5_0_5b_instruct_q4.gguf",
            sandboxModelPaths: [],
            llamaFrameworkPath: "/Users/bytedance/LocalModels/DestinyScope/llama.xcframework",
            modelDirectoryDescription: "Simulator 可用 Mac 本地路径；真机必须把模型手工放入 App 沙盒 Documents/LocalModels/DestinyScope。模型文件不得提交仓库或进入 Release 默认路径。"
        )
    }

    var modelPathCandidates: [String] {
        let resolver = fileResolver
        let orderedPaths = [
            resolver.appDocumentsModelFileURL().path,
            resolver.appDocumentsAliasFileURL().path,
            resolver.developerLocalModelsFileURL().path,
            resolver.developerLocalModelsAliasFileURL().path
        ] + sandboxModelPaths

        return Array(NSOrderedSet(array: orderedPaths)) as? [String] ?? orderedPaths
    }

    func appDocumentsModelDirectoryURL() -> URL {
        fileResolver.appDocumentsModelDirectoryURL()
    }

    func appDocumentsModelFileURL() -> URL {
        fileResolver.appDocumentsModelFileURL()
    }

    func ensureAppDocumentsModelDirectoryExists() throws {
        try fileResolver.ensureAppDocumentsModelDirectoryExists()
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
        fileResolver.resolveModelFileStatus().resolvedURL?.path
    }

    func llamaFrameworkExists() -> Bool {
        var isDirectory: ObjCBool = false
        let expanded = expandedPath(llamaFrameworkPath)
        return FileManager.default.fileExists(atPath: expanded, isDirectory: &isDirectory) && isDirectory.boolValue
    }

    func modelFileStatuses() -> [LocalModelFileStatus] {
        fileResolver.candidateStatuses()
    }

    func currentModelFileStatuses() -> [LocalModelFileStatus] {
        let statuses = modelFileStatuses()
        if let existingStatus = statuses.first(where: { $0.isUsable }) {
            return [existingStatus]
        }

        return statuses
    }

    func modelFileStatus(for path: String) -> LocalModelFileStatus {
        let url = URL(fileURLWithPath: expandedPath(path))
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) && !isDirectory.boolValue
        let attributes = exists ? try? FileManager.default.attributesOfItem(atPath: url.path) : nil
        let fileSize = (attributes?[.size] as? NSNumber)?.int64Value

        return fileResolver.candidateStatuses().first { $0.resolvedURL?.path == url.path } ??
            LocalModelFileStatus(
                expectedFileName: expectedModelFileName,
                resolvedURL: url,
                exists: exists,
                fileSize: fileSize,
                source: .developerLocalModels,
                reason: nil
            )
    }
}
