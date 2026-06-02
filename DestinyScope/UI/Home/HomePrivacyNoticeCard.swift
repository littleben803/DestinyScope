//
//  HomePrivacyNoticeCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct HomePrivacyNoticeCard: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        AppCard {
            HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
                Image(systemName: "lock.shield")
                    .font(.title3)
                    .foregroundColor(AppTheme.Colors.cinnabar)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(localizationStore.string(.homePrivacyTitle))
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(localizationStore.string(.homePrivacyBody))
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}
