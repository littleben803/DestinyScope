//
//  HistoryRecordRowView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct HistoryRecordRowView: View {
    let record: HistoryRecord

    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                HStack(alignment: .firstTextBaseline, spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.darkGold)
                        .accessibilityHidden(true)

                    Text(record.title)
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Text(record.createdAtDisplayText)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.secondaryText)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(record.birthDisplayText)
                        .font(AppTheme.Typography.secondary)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(localizationStore.string(
                        "history.row.birthEightCharacters",
                        replacements: ["value": record.birthEightCharacters.displayText]
                    ))
                        .font(AppTheme.Typography.secondary)
                        .foregroundColor(AppTheme.Colors.secondaryText)

                    Text(localizationStore.string(
                        "history.row.totalWeight",
                        replacements: ["weight": record.totalWeightText]
                    ))
                        .font(AppTheme.Typography.secondary.weight(.semibold))
                        .foregroundColor(AppTheme.Colors.darkGold)
                }
            }
        }
    }
}

struct HistoryTagGrid: View {
    let tags: [String]

    private let columns = [
        GridItem(.adaptive(minimum: 72), spacing: AppTheme.Spacing.sm, alignment: .leading)
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: AppTheme.Spacing.sm) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(AppTheme.Typography.caption.weight(.medium))
                    .foregroundColor(AppTheme.Colors.darkGold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .padding(.horizontal, AppTheme.Spacing.sm)
                    .padding(.vertical, AppTheme.Spacing.xs)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(AppTheme.Colors.secondaryBackground.opacity(0.55))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(AppTheme.Colors.divider.opacity(0.45), lineWidth: 1)
                    )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
