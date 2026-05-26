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
