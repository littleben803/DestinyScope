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
    let detailedReading: LifeWeightReading?

    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    ResultSummaryCard(result: result)

                    poemCard

                    LifeWeightReadingCard(
                        result: result,
                        reading: detailedReading,
                        interpretation: interpretation,
                        insight: insight
                    )

                    ResultTextShareCard(
                        result: result,
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
