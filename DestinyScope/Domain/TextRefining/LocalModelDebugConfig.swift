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
            llamaFrameworkPath: "/Users/bytedance/LocalModels/DestinyScope/llama.xcframework",
            modelDirectoryDescription: "开发者本地 Debug 测试目录；模型文件不得提交仓库或进入 Release 默认路径。"
        )
    }

    var modelPathCandidates: [String] {
        [primaryModelPath, fallbackModelPath]
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
            let expanded = expandedPath(candidate)
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
                displayPath: candidate,
                expandedPath: expanded,
                exists: exists && !isDirectory.boolValue,
                sizeInBytes: size
            )
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
