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

    @EnvironmentObject private var localizationStore: LocalizationStore

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

                    ResultTextShareCard(
                        result: result,
                        interpretation: interpretation,
                        insight: insight
                    )

                    ProductionLocalRefiningCard(
                        interpretation: interpretation,
                        insight: insight
                    )

                    Text(localizationStore.string("result.safety.short"))
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle(localizationStore.string("result.navigation.title"))
    }

    private var insightSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            AppSectionHeader(title: localizationStore.string("result.insight.title"))

            InsightTagsView(tags: insight.tags)

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(insight.focusTitle)
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)
                Text(insight.focusDescription)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)
            }

            bulletSection(title: localizationStore.string("result.insight.strengths"), items: insight.strengths)
            bulletSection(title: localizationStore.string("result.insight.cautions"), items: insight.cautions)

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(localizationStore.string("result.insight.actionSuggestion"))
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
            AppSectionHeader(title: localizationStore.string("result.poem.title"))

            Text(result.poem)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .lineSpacing(4)
        }
    }
}
