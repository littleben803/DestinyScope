//
//  ResultSummaryCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct ResultSummaryCard: View {
    let result: LifeWeightResult

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                Text(result.title)
                    .font(AppTheme.Typography.pageTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    infoRow(title: "农历生日", value: result.lunarBirthDate.displayText)
                    infoRow(title: "出生时辰", value: result.hourText)
                    infoRow(title: "总重量", value: result.totalWeightText, emphasized: true)
                }

                Divider()
                    .background(AppTheme.Colors.divider)

                Text("结果仅供娱乐、自我探索和传统文化学习参考。")
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
