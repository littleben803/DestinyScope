//
//  LifeWeightDetailedReading.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import Foundation

struct LifeWeightReadingCatalog: Decodable, Equatable {
    let readings: [String: LifeWeightDetailedReading]

    private enum CodingKeys: String, CodingKey {
        case readings
    }

    init(readings: [String: LifeWeightDetailedReading]) {
        self.readings = readings
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.readings) {
            readings = try container.decode([String: LifeWeightDetailedReading].self, forKey: .readings)
        } else {
            readings = try [String: LifeWeightDetailedReading](from: decoder)
        }
    }

    func reading(forWeightKey weightKey: String, gender: BirthGender) -> LifeWeightReading? {
        let key = Self.normalizedWeightKey(weightKey)
        let detailedReading = readings[weightKey] ?? readings[key]
        return detailedReading?.variant(for: gender)
    }

    private static func normalizedWeightKey(_ weightKey: String) -> String {
        weightKey
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "錢", with: "")
            .replacingOccurrences(of: "钱", with: "")
    }
}

struct LifeWeightDetailedReading: Decodable, Equatable {
    let weightKey: String
    let weightLabel: String
    let totalQian: Double
    let general: LifeWeightReading?
    let male: LifeWeightReading?
    let female: LifeWeightReading?

    private enum CodingKeys: String, CodingKey {
        case weightKey = "weight_key"
        case weightLabel = "weight_label"
        case totalQian = "total_qian"
        case general
        case male
        case female
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        weightKey = try container.decodeIfPresent(String.self, forKey: .weightKey) ?? ""
        weightLabel = try container.decodeIfPresent(String.self, forKey: .weightLabel) ?? ""
        totalQian = try container.decodeIfPresent(Double.self, forKey: .totalQian) ?? 0
        general = try container.decodeIfPresent(LifeWeightReading.self, forKey: .general)?
            .withDefaults(weightKey: weightKey, weightLabel: weightLabel, totalQian: totalQian, gender: "general")
        male = try container.decodeIfPresent(LifeWeightReading.self, forKey: .male)?
            .withDefaults(weightKey: weightKey, weightLabel: weightLabel, totalQian: totalQian, gender: BirthGender.male.rawValue)
        female = try container.decodeIfPresent(LifeWeightReading.self, forKey: .female)?
            .withDefaults(weightKey: weightKey, weightLabel: weightLabel, totalQian: totalQian, gender: BirthGender.female.rawValue)
    }

    func variant(for gender: BirthGender) -> LifeWeightReading? {
        switch gender {
        case .male:
            return male ?? general
        case .female:
            return female ?? general
        }
    }
}

struct LifeWeightReading: Codable, Equatable {
    let weightKey: String
    let weightLabel: String
    let totalQian: Double
    let gender: String
    let title: String
    let insight: String
    let keywords: [String]
    let detail: String
    let personality: String
    let career: String
    let wealth: String
    let relationship: String
    let childrenFamily: String
    let healthBlessing: String
    let advice: String
    let originalPoem: String
    let originalNote: String
    let rewriteNotes: String?

    private enum CodingKeys: String, CodingKey {
        case weightKey = "weight_key"
        case weightLabel = "weight_label"
        case totalQian = "total_qian"
        case gender
        case title
        case insight
        case keywords
        case detail
        case personality
        case career
        case wealth
        case relationship
        case childrenFamily = "children_family"
        case healthBlessing = "health_blessing"
        case advice
        case originalPoem = "original_poem"
        case originalNote = "original_note"
        case rewriteNotes = "rewrite_notes"
    }

    init(
        weightKey: String = "",
        weightLabel: String = "",
        totalQian: Double = 0,
        gender: String = "",
        title: String = "",
        insight: String = "",
        keywords: [String] = [],
        detail: String = "",
        personality: String = "",
        career: String = "",
        wealth: String = "",
        relationship: String = "",
        childrenFamily: String = "",
        healthBlessing: String = "",
        advice: String = "",
        originalPoem: String = "",
        originalNote: String = "",
        rewriteNotes: String? = nil
    ) {
        self.weightKey = weightKey
        self.weightLabel = weightLabel
        self.totalQian = totalQian
        self.gender = gender
        self.title = title
        self.insight = insight
        self.keywords = keywords
        self.detail = detail
        self.personality = personality
        self.career = career
        self.wealth = wealth
        self.relationship = relationship
        self.childrenFamily = childrenFamily
        self.healthBlessing = healthBlessing
        self.advice = advice
        self.originalPoem = originalPoem
        self.originalNote = originalNote
        self.rewriteNotes = rewriteNotes
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        weightKey = try container.decodeIfPresent(String.self, forKey: .weightKey) ?? ""
        weightLabel = try container.decodeIfPresent(String.self, forKey: .weightLabel) ?? ""
        totalQian = try container.decodeIfPresent(Double.self, forKey: .totalQian) ?? 0
        gender = try container.decodeIfPresent(String.self, forKey: .gender) ?? ""
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        insight = try container.decodeIfPresent(String.self, forKey: .insight) ?? ""
        keywords = try container.decodeIfPresent([String].self, forKey: .keywords) ?? []
        detail = try container.decodeIfPresent(String.self, forKey: .detail) ?? ""
        personality = try container.decodeIfPresent(String.self, forKey: .personality) ?? ""
        career = try container.decodeIfPresent(String.self, forKey: .career) ?? ""
        wealth = try container.decodeIfPresent(String.self, forKey: .wealth) ?? ""
        relationship = try container.decodeIfPresent(String.self, forKey: .relationship) ?? ""
        childrenFamily = try container.decodeIfPresent(String.self, forKey: .childrenFamily) ?? ""
        healthBlessing = try container.decodeIfPresent(String.self, forKey: .healthBlessing) ?? ""
        advice = try container.decodeIfPresent(String.self, forKey: .advice) ?? ""
        originalPoem = try container.decodeIfPresent(String.self, forKey: .originalPoem) ?? ""
        originalNote = try container.decodeIfPresent(String.self, forKey: .originalNote) ?? ""
        rewriteNotes = try container.decodeIfPresent(String.self, forKey: .rewriteNotes)
    }

    func withDefaults(
        weightKey defaultWeightKey: String,
        weightLabel defaultWeightLabel: String,
        totalQian defaultTotalQian: Double,
        gender defaultGender: String
    ) -> LifeWeightReading {
        LifeWeightReading(
            weightKey: weightKey.isEmpty ? defaultWeightKey : weightKey,
            weightLabel: weightLabel.isEmpty ? defaultWeightLabel : weightLabel,
            totalQian: totalQian == 0 ? defaultTotalQian : totalQian,
            gender: gender.isEmpty ? defaultGender : gender,
            title: title,
            insight: insight,
            keywords: keywords,
            detail: detail,
            personality: personality,
            career: career,
            wealth: wealth,
            relationship: relationship,
            childrenFamily: childrenFamily,
            healthBlessing: healthBlessing,
            advice: advice,
            originalPoem: originalPoem,
            originalNote: originalNote,
            rewriteNotes: rewriteNotes
        )
    }
}

typealias LifeWeightReadingVariant = LifeWeightReading
