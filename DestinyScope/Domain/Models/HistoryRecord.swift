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
    let gender: BirthGender
    let lunarBirthday: String
    let birthEightCharacters: BirthEightCharacters
    let totalWeightText: String
    let title: String
    let poem: String
    let tags: [String]

    init(
        id: UUID,
        createdAt: Date,
        solarDate: Date,
        hour: Int,
        gender: BirthGender = .defaultValue,
        lunarBirthday: String,
        birthEightCharacters: BirthEightCharacters? = nil,
        totalWeightText: String,
        title: String,
        poem: String,
        tags: [String]
    ) {
        self.id = id
        self.createdAt = createdAt
        self.solarDate = solarDate
        self.hour = hour
        self.gender = gender
        self.lunarBirthday = lunarBirthday
        self.birthEightCharacters = birthEightCharacters
            ?? BirthEightCharactersCalculator().calculate(solarDate: solarDate, hour: hour)
            ?? .fallback
        self.totalWeightText = totalWeightText
        self.title = title
        self.poem = poem
        self.tags = tags
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt
        case solarDate
        case hour
        case gender
        case lunarBirthday
        case birthEightCharacters
        case totalWeightText
        case title
        case poem
        case tags
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        solarDate = try container.decode(Date.self, forKey: .solarDate)
        hour = try container.decode(Int.self, forKey: .hour)
        gender = try container.decodeIfPresent(BirthGender.self, forKey: .gender) ?? .defaultValue
        lunarBirthday = try container.decode(String.self, forKey: .lunarBirthday)
        birthEightCharacters = try container.decodeIfPresent(BirthEightCharacters.self, forKey: .birthEightCharacters)
            ?? BirthEightCharactersCalculator().calculate(solarDate: solarDate, hour: hour)
            ?? .fallback
        totalWeightText = try container.decode(String.self, forKey: .totalWeightText)
        title = try container.decode(String.self, forKey: .title)
        poem = try container.decode(String.self, forKey: .poem)
        tags = try container.decode([String].self, forKey: .tags)
    }
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
