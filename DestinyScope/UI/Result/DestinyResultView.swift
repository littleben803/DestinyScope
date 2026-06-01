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
                    ResultSummaryCard(result: result)

                    poemCard

                    WeightBreakdownCard(breakdown: result.breakdown)

                    AppCard {
                        insightSection
                    }

                    InterpretationCard(interpretation: interpretation)

                    AppCard {
                        FortuneQuestionView(
                            result: result,
                            interpretation: interpretation,
                            insight: insight
                        )
                    }

                    LocalRefiningPreviewCard(
                        interpretation: interpretation,
                        insight: insight
                    )

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

            InsightTagsView(tags: insight.tags)

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

    private var poemCard: some View {
        AppCard {
            AppSectionHeader(title: "称骨诗文")

            Text(result.poem)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .lineSpacing(4)
        }
    }
}
