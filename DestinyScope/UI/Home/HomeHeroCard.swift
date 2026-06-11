//
//  HomeHeroCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct HomeHeroCard: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    let titleOpacity: Double

    init(titleOpacity: Double = 1) {
        self.titleOpacity = titleOpacity
    }

    var body: some View {
        AnimatedTitleHeader(
            title: localizationStore.string(.appName),
            subtitle: localizationStore.string(.appSubtitle),
            titleOpacity: titleOpacity
        )
    }
}
