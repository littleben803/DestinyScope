//
//  SavedBirthProfileRowView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct SavedBirthProfileRowView: View {
    let profile: SavedBirthProfile

    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                HStack(alignment: .firstTextBaseline, spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "bookmark.fill")
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.darkGold)
                        .accessibilityHidden(true)

                    Text(profile.displayName)
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(localizationStore.string(
                        "profile.row.birth",
                        replacements: ["birth": profile.birthSummaryText]
                    ))
                    Text(localizationStore.string(
                        "profile.row.updated",
                        replacements: ["date": profile.updatedAtText]
                    ))
                }
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            localizationStore.string(
                "profile.row.accessibilityLabel",
                replacements: [
                    "name": profile.displayName,
                    "birth": profile.birthSummaryText,
                    "date": profile.updatedAtText
                ]
            )
        )
    }
}
