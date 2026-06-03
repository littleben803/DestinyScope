//
//  BirthGender.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import Foundation

enum BirthGender: String, Codable, CaseIterable, Identifiable, Equatable {
    case male
    case female

    static let defaultValue: BirthGender = .male

    var id: String {
        rawValue
    }
}
