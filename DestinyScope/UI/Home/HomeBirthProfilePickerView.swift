//
//  HomeBirthProfilePickerView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct HomeBirthProfilePickerView: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    let profiles: [SavedBirthProfile]
    let onSelect: (SavedBirthProfile) -> Void

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                HStack(alignment: .firstTextBaseline) {
                    AppSectionHeader(title: localizationStore.string(.homeBirthProfilesTitle))

                    Spacer()

                    Text(localizationStore.string(.homeBirthProfilesBadge))
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.darkGold)
                }

                Text(localizationStore.string(.homeBirthProfilesDescription))
                    .font(AppTheme.Typography.footnote)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

                if profiles.isEmpty {
                    Text(localizationStore.string(.homeBirthProfilesEmpty))
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AppTheme.Spacing.sm) {
                            ForEach(profiles) { profile in
                                Button {
                                    onSelect(profile)
                                } label: {
                                    profileChip(profile)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel(
                                    localizationStore.string(
                                        .homeBirthProfilesSelectAccessibilityLabel,
                                        replacements: ["name": profile.displayName]
                                    )
                                )
                                .accessibilityHint(localizationStore.string(.homeBirthProfilesSelectAccessibilityHint))
                            }
                        }
                        .padding(.vertical, AppTheme.Spacing.xs)
                    }
                }
            }
        }
    }

    private func profileChip(_ profile: SavedBirthProfile) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            HStack(alignment: .firstTextBaseline, spacing: AppTheme.Spacing.xs) {
                Image(systemName: "bookmark.fill")
                    .font(AppTheme.Typography.footnote.weight(.semibold))
                    .foregroundColor(AppTheme.Colors.darkGold)
                    .accessibilityHidden(true)

                Text(profile.displayName)
                    .font(AppTheme.Typography.body.weight(.semibold))
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .lineLimit(2)
            }

            Text(profile.birthSummaryText)
                .font(AppTheme.Typography.footnote)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
        .frame(width: 168, alignment: .leading)
        .background(AppTheme.Colors.paper)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous)
                .stroke(AppTheme.Colors.divider.opacity(0.55), lineWidth: 1)
        )
    }
}
