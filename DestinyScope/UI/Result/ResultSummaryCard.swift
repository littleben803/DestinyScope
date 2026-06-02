//
//  ResultSummaryCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct ResultSummaryCard: View {
    let result: LifeWeightResult

    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text(result.title)
                    .font(AppTheme.Typography.pageTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    infoRow(title: localizationStore.string("result.summary.lunarBirthday"), value: result.lunarBirthDate.displayText)
                    infoRow(title: localizationStore.string("result.summary.birthHour"), value: result.hourText)
                    infoRow(title: localizationStore.string("result.summary.totalWeight"), value: result.totalWeightText, emphasized: true)
                }

                Divider()
                    .background(AppTheme.Colors.divider)

                Text(localizationStore.string("result.safety.short"))
                    .font(AppTheme.Typography.footnote)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
        }
    }

    private func infoRow(title: String, value: String, emphasized: Bool = false) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: AppTheme.Spacing.md) {
            Text(title)
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .frame(width: 72, alignment: .leading)

            Text(value)
                .font(emphasized ? AppTheme.Typography.sectionTitle : AppTheme.Typography.body)
                .foregroundColor(emphasized ? AppTheme.Colors.darkGold : AppTheme.Colors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
