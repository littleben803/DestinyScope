//
//  LlamaCppModelInfo.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct LlamaCppModelInfo: Equatable {
    let path: String
    let fileName: String
    let fileSizeText: String

    init(path: String) {
        self.path = path
        self.fileName = URL(fileURLWithPath: path).lastPathComponent

        if let attributes = try? FileManager.default.attributesOfItem(atPath: path),
           let size = attributes[.size] as? UInt64 {
            self.fileSizeText = ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
        } else {
            self.fileSizeText = "未知"
        }
    }
}
