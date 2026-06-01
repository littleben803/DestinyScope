//
//  OpenSourceLicenseItem.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct OpenSourceLicenseItem: Identifiable, Equatable {
    let id: String
    let name: String
    let sourceURLs: [String]
    let license: String
    let description: String
}

extension OpenSourceLicenseItem {
    var sourceDisplayText: String {
        sourceURLs.joined(separator: "\n")
    }
}
