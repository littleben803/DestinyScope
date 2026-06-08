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
    private let shareTextBuilder = ResultShareTextBuilder()

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

                    Text(localizationStore.string("result.safety.short"))
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle(localizationStore.string("result.navigation.title"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: resultShareText) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .frame(width: 36, height: 36)
                        .contentShape(Circle())
                }
                .accessibilityLabel(localizationStore.string("result.navigation.share.accessibilityLabel"))
                .accessibilityHint(localizationStore.string("result.navigation.share.accessibilityHint"))
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

    private var resultShareText: String {
        shareTextBuilder.build(
            result: result,
            reading: detailedReading,
            interpretation: interpretation,
            insight: insight,
            localizationStore: localizationStore
        )
    }
}
