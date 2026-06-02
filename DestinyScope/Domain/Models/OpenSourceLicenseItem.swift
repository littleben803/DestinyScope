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
    let sha256: String?
    let usageDescription: String
    let copyrightText: String
    let noticeText: String
}

extension OpenSourceLicenseItem {
    var sourceDisplayText: String {
        sourceURLs.joined(separator: "\n")
    }
}
