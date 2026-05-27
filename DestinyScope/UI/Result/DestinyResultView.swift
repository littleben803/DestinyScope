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
    let insight: LifeWeightInsight

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
                        insightSection
                    }

                    AppCard {
                        FortuneQuestionView(
                            result: result,
                            interpretation: interpretation,
                            insight: insight
                        )
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

    private var insightSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            AppSectionHeader(title: "命格洞察")

            tagList

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(insight.focusTitle)
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)
                Text(insight.focusDescription)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)
            }

            bulletSection(title: "优势倾向", items: insight.strengths)
            bulletSection(title: "需要关注", items: insight.cautions)

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text("行动建议")
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)
                Text(insight.actionSuggestion)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)
            }

            Text(insight.safetyNotice)
                .font(AppTheme.Typography.footnote)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var tagList: some View {
        FlowLayout(spacing: AppTheme.Spacing.sm) {
            ForEach(insight.tags, id: \.self) { tag in
                Text(tag)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.cinnabar)
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.vertical, AppTheme.Spacing.xs)
                    .background(AppTheme.Colors.secondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous)
                            .stroke(AppTheme.Colors.divider.opacity(0.6), lineWidth: 1)
                    )
            }
        }
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

    private func bulletSection(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(title)
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(AppTheme.Colors.primaryText)

            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
                    Text("•")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.darkGold)
                    Text(item)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.primaryText)
                }
            }
        }
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

private struct FlowLayout<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder let content: Content

    var body: some View {
        if #available(iOS 16.0, *) {
            AnyLayout(HStackLayout(spacing: spacing)) {
                content
            }
        } else {
            HStack(spacing: spacing) {
                content
            }
        }
    }
}
