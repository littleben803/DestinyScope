//
//  WeightBreakdownCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct WeightBreakdownCard: View {
    let breakdown: LifeWeightBreakdown

    @EnvironmentObject private var localizationStore: LocalizationStore

    private var items: [BreakdownDisplayItem] {
        [
            BreakdownDisplayItem(id: "year", labelID: "result.weightBreakdown.year", item: breakdown.year),
            BreakdownDisplayItem(id: "month", labelID: "result.weightBreakdown.month", item: breakdown.month),
            BreakdownDisplayItem(id: "day", labelID: "result.weightBreakdown.day", item: breakdown.day),
            BreakdownDisplayItem(id: "hour", labelID: "result.weightBreakdown.hour", item: breakdown.hour)
        ]
    }

    private let columns = [
        GridItem(.flexible(), spacing: AppTheme.Spacing.md),
        GridItem(.flexible(), spacing: AppTheme.Spacing.md)
    ]

    var body: some View {
        AppCard {
            AppSectionHeader(title: localizationStore.string("result.weightBreakdown.title"))

            LazyVGrid(columns: columns, alignment: .leading, spacing: AppTheme.Spacing.md) {
                ForEach(items) { displayItem in
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                        Text(localizationStore.string(L10nID(displayItem.labelID)))
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(AppTheme.Colors.secondaryText)

                        Text(displayItem.item.valueText)
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                            .lineLimit(2)
                            .minimumScaleFactor(0.85)

                        Text(displayItem.item.weightText)
                            .font(AppTheme.Typography.sectionTitle)
                            .foregroundColor(AppTheme.Colors.darkGold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(AppTheme.Spacing.md)
                    .background(AppTheme.Colors.secondaryBackground.opacity(0.55))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous))
                }
            }
        }
    }
}

private struct BreakdownDisplayItem: Identifiable {
    let id: String
    let labelID: String
    let item: WeightItem
}
