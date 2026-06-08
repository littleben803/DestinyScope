//
//  HistoryDetailView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct HistoryDetailView: View {
    let record: HistoryRecord

    @EnvironmentObject private var localizationStore: LocalizationStore

    @State private var detailedReading: LifeWeightReading?

    private let lifeWeightReadingRepository = LifeWeightReadingRepository()
    private let shareTextBuilder = ResultShareTextBuilder()

    init(record: HistoryRecord) {
        self.record = record
    }

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    poemCard
                    LifeWeightReadingCard(
                        result: lightweightResult,
                        reading: detailedReading,
                        interpretation: fallbackInterpretation,
                        insight: fallbackInsight
                    )
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle(localizationStore.string("history.detail.navigationTitle"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: historyShareText) {
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
        .onAppear {
            loadDetailedReading()
        }
    }

    private var poemCard: some View {
        AppCard {
            AppSectionHeader(title: localizationStore.string("result.poem.title"))
            Text(record.poem)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var lightweightResult: LifeWeightResult {
        LifeWeightResult(
            birthProfile: BirthProfile(
                solarDate: record.solarDate,
                hour: record.hour,
                gender: record.gender
            ),
            lunarBirthDate: LunarBirthDate(
                yearIndex: 0,
                yearText: "",
                month: 0,
                monthText: "",
                day: 0,
                dayText: "",
                isLeapMonth: false,
                displayText: record.lunarBirthday
            ),
            hourText: record.hourDisplayText,
            breakdown: emptyBreakdown,
            totalWeight: record.totalWeightValue,
            totalWeightText: record.totalWeightText,
            title: record.title,
            poem: record.poem
        )
    }

    private var emptyBreakdown: LifeWeightBreakdown {
        LifeWeightBreakdown(
            year: emptyWeightItem(label: "年"),
            month: emptyWeightItem(label: "月"),
            day: emptyWeightItem(label: "日"),
            hour: emptyWeightItem(label: "时")
        )
    }

    private var fallbackInterpretation: FortuneInterpretation {
        TemplateFortuneInterpreter().interpret(result: lightweightResult)
    }

    private var fallbackInsight: LifeWeightInsight {
        let generatedInsight = LifeWeightInsightGenerator().generate(result: lightweightResult)
        guard !record.tags.isEmpty else {
            return generatedInsight
        }

        return LifeWeightInsight(
            tags: record.tags,
            focusTitle: generatedInsight.focusTitle,
            focusDescription: generatedInsight.focusDescription,
            strengths: generatedInsight.strengths,
            cautions: generatedInsight.cautions,
            actionSuggestion: generatedInsight.actionSuggestion,
            safetyNotice: generatedInsight.safetyNotice
        )
    }

    private var historyShareText: String {
        shareTextBuilder.build(
            result: lightweightResult,
            reading: detailedReading,
            interpretation: fallbackInterpretation,
            insight: fallbackInsight,
            localizationStore: localizationStore
        )
    }

    private func emptyWeightItem(label: String) -> WeightItem {
        WeightItem(
            label: label,
            valueText: localizationStore.string("history.detail.unknownValue"),
            weightText: localizationStore.string("history.detail.unknownValue"),
            weight: 0
        )
    }

    private func loadDetailedReading() {
        detailedReading = try? lifeWeightReadingRepository.reading(
            forWeightKey: record.readingWeightKey,
            gender: record.gender
        )
    }
}

private extension HistoryRecord {
    var readingWeightKey: String {
        totalWeightText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "两", with: "兩")
            .replacingOccurrences(of: "钱", with: "")
            .replacingOccurrences(of: "錢", with: "")
    }

    var totalWeightValue: Double {
        let key = readingWeightKey
        guard let liangMarkerRange = key.range(of: "兩") else {
            return 0
        }

        let liangText = String(key[..<liangMarkerRange.lowerBound])
        let qianText = String(key[liangMarkerRange.upperBound...])
        let liang = Self.chineseNumeralValue(liangText) ?? 0
        let qian = Self.chineseNumeralValue(qianText) ?? 0
        return Double(liang) + Double(qian) / 10
    }

    private static func chineseNumeralValue(_ text: String) -> Int? {
        guard !text.isEmpty else {
            return 0
        }

        let numerals: [String: Int] = [
            "零": 0,
            "一": 1,
            "二": 2,
            "三": 3,
            "四": 4,
            "五": 5,
            "六": 6,
            "七": 7,
            "八": 8,
            "九": 9
        ]
        return numerals[text]
    }
}
