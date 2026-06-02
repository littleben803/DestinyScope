//
//  HomeHeroCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct HomeHeroCard: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(localizationStore.string(.homeHeroSubtitle))
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(AppTheme.Colors.darkGold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
