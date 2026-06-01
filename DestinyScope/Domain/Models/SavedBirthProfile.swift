//
//  SavedBirthProfile.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct SavedBirthProfile: Codable, Identifiable, Equatable {
    let id: UUID
    var displayName: String
    var birthDate: Date
    var hour: Int
    let createdAt: Date
    var updatedAt: Date
}

extension SavedBirthProfile {
    var birthDateText: String {
        Self.dateFormatter.string(from: birthDate)
    }

    var hourText: String {
        String(format: "%02d 时", hour)
    }

    var updatedAtText: String {
        Self.dateTimeFormatter.string(from: updatedAt)
    }

    var birthSummaryText: String {
        "\(birthDateText) \(hourText)"
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月d日"
        return formatter
    }()

    private static let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月d日 HH:mm"
        return formatter
    }()
}
