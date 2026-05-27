//
//  TextRefiningOutput.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct TextRefiningOutput: Equatable {
    let text: String
    let wasRefined: Bool
    let engine: String
    let safetyNotice: String?
}
