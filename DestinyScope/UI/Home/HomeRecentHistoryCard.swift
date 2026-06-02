//
//  HomeRecentHistoryCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct HomeRecentHistoryCard: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    let record: HistoryRecord?

    var body: some View {
        AppCard {
            AppSectionHeader(title: localizationStore.string(.homeRecentTitle))

            if let record {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    HStack(alignment: .firstTextBaseline, spacing: AppTheme.Spacing.sm) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(AppTheme.Typography.body.weight(.semibold))
                            .foregroundColor(AppTheme.Colors.darkGold)
                            .accessibilityHidden(true)

                        Text(record.title)
                            .font(AppTheme.Typography.body.weight(.semibold))
                            .foregroundColor(AppTheme.Colors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Text(record.createdAtDisplayText)
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)

                    Text(record.birthDisplayText)
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)

                    Text(
                        localizationStore.string(
                            .homeRecentWeight,
                            replacements: ["weight": record.totalWeightText]
                        )
                    )
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.darkGold)

                    Text(localizationStore.string(.homeRecentDescription))
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            } else {
                Text(localizationStore.string(.homeRecentEmpty))
                    .font(AppTheme.Typography.footnote)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
