//
//  LocalRefiningPreviewState.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/29.
//

import Foundation

enum LocalRefiningPreviewState: Equatable {
    case idle
    case generating
    case success
    case fallback
    case failed

    var displayName: String {
        switch self {
        case .idle:
            return "待生成"
        case .generating:
            return "生成中"
        case .success:
            return "已生成"
        case .fallback:
            return "已回退"
        case .failed:
            return "生成失败"
        }
    }
}
