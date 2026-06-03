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
    var gender: BirthGender
    let createdAt: Date
    var updatedAt: Date

    init(
        id: UUID,
        displayName: String,
        birthDate: Date,
        hour: Int,
        gender: BirthGender = .defaultValue,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.displayName = displayName
        self.birthDate = birthDate
        self.hour = hour
        self.gender = gender
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case birthDate
        case hour
        case gender
        case createdAt
        case updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        displayName = try container.decode(String.self, forKey: .displayName)
        birthDate = try container.decode(Date.self, forKey: .birthDate)
        hour = try container.decode(Int.self, forKey: .hour)
        gender = try container.decodeIfPresent(BirthGender.self, forKey: .gender) ?? .defaultValue
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
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
