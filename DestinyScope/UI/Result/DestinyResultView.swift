//
//  DestinyResultView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct DestinyResultView: View {
    let result: LifeWeightResult
    let interpretation: FortuneInterpretation

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    AppCard {
                        Text(result.title)
                            .font(AppTheme.Typography.pageTitle)
                            .foregroundColor(AppTheme.Colors.primaryText)

                        Text(result.lunarBirthDate.displayText)
                            .font(AppTheme.Typography.secondary)
                            .foregroundColor(AppTheme.Colors.secondaryText)

                        Text("总重量：\(result.totalWeightText)")
                            .font(AppTheme.Typography.sectionTitle)
                            .foregroundColor(AppTheme.Colors.darkGold)

                        Divider()
                            .background(AppTheme.Colors.divider)

                        Text(result.poem)
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }

                    AppCard {
                        AppSectionHeader(title: "权重明细")
                        weightRow(result.breakdown.year)
                        weightRow(result.breakdown.month)
                        weightRow(result.breakdown.day)
                        weightRow(result.breakdown.hour)
                    }

                    AppCard {
                        interpretationSection
                    }

                    Text("结果仅供娱乐、自我探索和传统文化学习参考。")
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("命理结果")
    }

    private var interpretationSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            AppSectionHeader(title: "命理师解读")

            Text("总评")
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
            Text(interpretation.summary)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)

            Text("性格")
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
            Text(interpretation.personality)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)

            Text("事业")
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
            Text(interpretation.career)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)

            Text("财运")
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
            Text(interpretation.wealth)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)

            Text("关系")
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
            Text(interpretation.relationship)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)

            Text(interpretation.safetyNotice)
                .font(AppTheme.Typography.footnote)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func weightRow(_ item: WeightItem) -> some View {
        HStack {
            Text("\(item.label)：\(item.valueText)")
            Spacer()
            Text(item.weightText)
        }
        .font(AppTheme.Typography.body)
        .foregroundColor(AppTheme.Colors.primaryText)
    }
}
