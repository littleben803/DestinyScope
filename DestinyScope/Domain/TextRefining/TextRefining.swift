//
//  TextRefining.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

protocol TextRefining {
    func refine(_ input: TextRefiningInput) async throws -> TextRefiningOutput
}

enum TextRefiningError: LocalizedError, Equatable {
    case localModelNotAvailable
    case unsupportedPurpose(TextRefiningPurpose)
    case emptyInput

    var errorDescription: String? {
        switch self {
        case .localModelNotAvailable:
            return "本地小模型暂不可用。"
        case .unsupportedPurpose:
            return "当前暂不支持该文本润色场景。"
        case .emptyInput:
            return "待润色文本不能为空。"
        }
    }
}
