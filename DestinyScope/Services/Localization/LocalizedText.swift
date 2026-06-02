//
//  LocalizedText.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct LocalizedText: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    let id: L10nID
    var replacements: [String: String] = [:]

    var body: some View {
        Text(localizationStore.string(id, replacements: replacements))
    }
}
