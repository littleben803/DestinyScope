//
//  HomeInputDraftBanner.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct HomeInputDraftBanner: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    let message: String
    let onClear: () -> Void

    var body: some View {
        AppCard {
            HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
                Image(systemName: "arrow.uturn.left.circle")
                    .font(.title3)
                    .foregroundColor(AppTheme.Colors.darkGold)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text(localizationStore.string(.homeDraftTitle))
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(message)
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    Button(localizationStore.string(.homeDraftClear), action: onClear)
                        .font(AppTheme.Typography.footnote.weight(.semibold))
                        .foregroundColor(AppTheme.Colors.cinnabar)
                        .accessibilityLabel(localizationStore.string(.homeDraftClearAccessibilityLabel))
                        .accessibilityHint(localizationStore.string(.homeDraftClearAccessibilityHint))
                }
            }
        }
    }
}
