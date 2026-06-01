//
//  LocalDataSummaryCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct LocalDataSummaryCard: View {
    let summary: LocalDataSummary

    var body: some View {
        AppCard {
            AppSectionHeader(title: "本地数据摘要")

            VStack(spacing: AppTheme.Spacing.sm) {
                summaryRow(title: "历史记录", value: "\(summary.historyRecordCount) 条")
                summaryRow(title: "常用出生资料", value: "\(summary.savedBirthProfileCount) 条")
                summaryRow(title: "知识库收藏", value: "\(summary.favoriteKnowledgeCount) 篇")
                summaryRow(title: "知识库最近阅读", value: "\(summary.recentKnowledgeCount) 条")
                summaryRow(title: "历史收藏", value: "\(summary.favoriteHistoryCount) 条")
                summaryRow(title: "历史置顶", value: "\(summary.pinnedHistoryCount) 条")
                summaryRow(title: "首次使用说明", value: summary.hasCompletedOnboarding ? "已完成" : "未完成")
            }
        }
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
