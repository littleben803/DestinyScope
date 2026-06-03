//
//  LifeWeightResult.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import Foundation

struct WeightItem: Equatable {
    let label: String
    let valueText: String
    let weightText: String
    let weight: Double
}

struct LifeWeightBreakdown: Equatable {
    let year: WeightItem
    let month: WeightItem
    let day: WeightItem
    let hour: WeightItem
}

struct LifeWeightResult: Equatable {
    let birthProfile: BirthProfile
    let lunarBirthDate: LunarBirthDate
    let hourText: String
    let breakdown: LifeWeightBreakdown
    let totalWeight: Double
    let totalWeightText: String
    let title: String
    let poem: String
}

extension LifeWeightResult {
    var readingWeightKey: String {
        Self.normalizedWeightKey(totalWeightText)
            ?? Self.weightKey(fromTotalWeight: totalWeight)
    }

    func withGender(_ gender: BirthGender) -> LifeWeightResult {
        LifeWeightResult(
            birthProfile: BirthProfile(
                solarDate: birthProfile.solarDate,
                hour: birthProfile.hour,
                gender: gender
            ),
            lunarBirthDate: lunarBirthDate,
            hourText: hourText,
            breakdown: breakdown,
            totalWeight: totalWeight,
            totalWeightText: totalWeightText,
            title: title,
            poem: poem
        )
    }

    private static func normalizedWeightKey(_ text: String) -> String? {
        let normalized = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "两", with: "兩")
            .replacingOccurrences(of: "钱", with: "")
            .replacingOccurrences(of: "錢", with: "")

        return normalized.isEmpty ? nil : normalized
    }

    private static func weightKey(fromTotalWeight totalWeight: Double) -> String {
        let numerals = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
        let totalQian = Int((totalWeight * 10).rounded())
        let liang = totalQian / 10
        let qian = totalQian % 10
        let liangText = "\(numerals[safe: liang] ?? String(liang))兩"
        guard qian > 0 else {
            return liangText
        }
        return "\(liangText)\(numerals[safe: qian] ?? String(qian))"
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
