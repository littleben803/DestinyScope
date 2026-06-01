//
//  WeightBreakdownCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct WeightBreakdownCard: View {
    let breakdown: LifeWeightBreakdown

    private var items: [WeightItem] {
        [
            breakdown.year,
            breakdown.month,
            breakdown.day,
            breakdown.hour
        ]
    }

    private let columns = [
        GridItem(.flexible(), spacing: AppTheme.Spacing.md),
        GridItem(.flexible(), spacing: AppTheme.Spacing.md)
    ]

    var body: some View {
        AppCard {
            AppSectionHeader(title: "权重明细")

            LazyVGrid(columns: columns, alignment: .leading, spacing: AppTheme.Spacing.md) {
                ForEach(items, id: \.label) { item in
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                        Text(item.label)
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(AppTheme.Colors.secondaryText)

                        Text(item.valueText)
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                            .lineLimit(2)
                            .minimumScaleFactor(0.85)

                        Text(item.weightText)
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
