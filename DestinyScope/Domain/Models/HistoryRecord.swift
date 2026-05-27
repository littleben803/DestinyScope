//
//  HistoryRecord.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct HistoryRecord: Codable, Identifiable, Equatable {
    let id: UUID
    let createdAt: Date
    let solarDate: Date
    let hour: Int
    let lunarBirthday: String
    let totalWeightText: String
    let title: String
    let poem: String
    let tags: [String]
}
