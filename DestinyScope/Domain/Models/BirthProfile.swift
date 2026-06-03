//
//  BirthProfile.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import Foundation

struct BirthProfile: Equatable {
    let solarDate: Date
    let hour: Int
    let gender: BirthGender

    init(solarDate: Date, hour: Int, gender: BirthGender = .defaultValue) {
        self.solarDate = solarDate
        self.hour = hour
        self.gender = gender
    }
}
