//
//  LocalDataSummaryCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct LocalDataSummaryCard: View {
    let summary: LocalDataSummary

    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        AppCard {
            AppSectionHeader(title: localizationStore.string("localData.summary.title"))

            VStack(spacing: AppTheme.Spacing.sm) {
                summaryRow(
                    title: localizationStore.string("localData.summary.history"),
                    value: countText("localData.count.records", summary.historyRecordCount)
                )
                summaryRow(
                    title: localizationStore.string("localData.summary.knowledgeFavorites"),
                    value: countText("localData.count.articles", summary.favoriteKnowledgeCount)
                )
                summaryRow(
                    title: localizationStore.string("localData.summary.knowledgeRecent"),
                    value: countText("localData.count.records", summary.recentKnowledgeCount)
                )
            }
        }
    }

    private func countText(_ id: L10nID, _ count: Int) -> String {
        localizationStore.string(id, replacements: ["count": "\(count)"])
    }

    private func summaryRow(title: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)

            Spacer(minLength: AppTheme.Spacing.md)

            Text(value)
                .font(AppTheme.Typography.body.weight(.semibold))
                .foregroundColor(AppTheme.Colors.darkGold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
