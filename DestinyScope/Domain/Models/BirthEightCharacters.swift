//
//  BirthEightCharacters.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/3.
//

import Foundation

struct BirthEightCharacters: Codable, Equatable {
    let yearPillar: String
    let monthPillar: String
    let dayPillar: String
    let hourPillar: String

    static let fallback = BirthEightCharacters(
        yearPillar: "--",
        monthPillar: "--",
        dayPillar: "--",
        hourPillar: "--"
    )
}
