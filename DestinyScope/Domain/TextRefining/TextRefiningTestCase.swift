//
//  TextRefiningTestCase.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct TextRefiningTestCase: Identifiable, Equatable {
    let id: String
    let title: String
    let sourceText: String
    let purpose: TextRefiningPurpose
    let tone: TextRefiningTone
}
