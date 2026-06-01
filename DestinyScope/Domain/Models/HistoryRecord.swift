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

extension HistoryRecord {
    var createdAtDisplayText: String {
        Self.dateTimeFormatter.string(from: createdAt)
    }

    var solarDateDisplayText: String {
        Self.dateFormatter.string(from: solarDate)
    }

    var hourDisplayText: String {
        String(format: "%02d 时", hour)
    }

    var birthDisplayText: String {
        "出生：\(solarDateDisplayText) \(hourDisplayText)"
    }

    private static let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月d日 HH:mm"
        return formatter
    }()

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月d日"
        return formatter
    }()
}
