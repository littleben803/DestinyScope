//
//  LunarBirthDate.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import Foundation

struct LunarBirthDate: Equatable {
    let yearIndex: Int
    let yearText: String
    let month: Int
    let monthText: String
    let day: Int
    let dayText: String
    let isLeapMonth: Bool
    let displayText: String
}
