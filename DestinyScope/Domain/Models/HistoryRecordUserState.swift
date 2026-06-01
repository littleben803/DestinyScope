//
//  HistoryRecordUserState.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct HistoryRecordUserState: Codable, Equatable {
    var favoriteRecordIDs: [UUID]
    var pinnedRecordIDs: [UUID]
    var updatedAt: Date

    static let empty = HistoryRecordUserState(
        favoriteRecordIDs: [],
        pinnedRecordIDs: [],
        updatedAt: Date(timeIntervalSince1970: 0)
    )
}
