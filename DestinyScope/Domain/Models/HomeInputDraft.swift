//
//  HomeInputDraft.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct HomeInputDraft: Identifiable, Equatable {
    let id: UUID
    let birthDate: Date
    let hour: Int
    let source: String
    let createdAt: Date
}
