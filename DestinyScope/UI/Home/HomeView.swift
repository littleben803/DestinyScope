//
//  HomeView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var localizationStore: LocalizationStore

    @State private var birthDate = Date()
    @State private var selectedHour = Calendar.current.component(.hour, from: Date())
    @State private var selectedGender = BirthGender.defaultValue
    @State private var calculation: LifeWeightResult?
    @State private var interpretation: FortuneInterpretation?
    @State private var insight: LifeWeightInsight?
    @State private var detailedReading: LifeWeightReading?
    @State private var errorMessage: String?
    @State private var shouldShowResult = false

    private let hours = Array(0...23)
    private let historyRecordStore = HistoryRecordStore()
    private let lifeWeightReadingRepository = LifeWeightReadingRepository()

    var body: some View {
        AnimatedTitlePage(title: localizationStore.string(.appName)) { titleContext in
            AppBackground {
                ScrollView {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                        HomeHeroCard(titleOpacity: titleContext.largeTitleOpacity)

                        HomeInputCard(
                            birthDate: $birthDate,
                            selectedHour: $selectedHour,
                            selectedGender: $selectedGender,
                            hours: hours,
                            errorMessage: errorMessage,
                            onCalculate: calculateLifeWeight
                        )
                        .transition(.opacity.combined(with: .scale))
                        .animation(.easeInOut, value: errorMessage)

                        HomeZodiacArtworkCard(
                            artwork: HomeZodiacArtwork.zodiac(
                                for: birthDate,
                                hour: selectedHour
                            )
                        )
                    }
                    .padding(AppTheme.Spacing.lg)
                }
                .animatedTitleScrollTracking(titleContext)
            }
        }
        .navigationDestination(isPresented: $shouldShowResult) {
            if let calculation, let interpretation, let insight {
                DestinyResultView(
                    result: calculation,
                    interpretation: interpretation,
                    insight: insight,
                    detailedReading: detailedReading
                )
            }
        }
    }

    private func calculateLifeWeight() {
        let engine = LifeWeightEngine(dataManager: dataManager)

        do {
            let calculation = try engine
                .calculate(birthDate: birthDate, selectedHour: selectedHour)
                .withGender(selectedGender)
            let interpretation = TemplateFortuneInterpreter().interpret(result: calculation)
            let insight = LifeWeightInsightGenerator().generate(result: calculation)
            let detailedReading = try? lifeWeightReadingRepository.reading(
                forWeightKey: calculation.readingWeightKey,
                gender: selectedGender
            )
            saveHistoryRecord(result: calculation, insight: insight)

            self.calculation = calculation
            self.interpretation = interpretation
            self.insight = insight
            self.detailedReading = detailedReading
            errorMessage = nil
            shouldShowResult = true
        } catch {
            calculation = nil
            interpretation = nil
            insight = nil
            detailedReading = nil
            shouldShowResult = false
            errorMessage = localizedCalculationError(error)
        }
    }

    private func localizedCalculationError(_ error: Error) -> String {
        guard let lifeWeightError = error as? LifeWeightError else {
            return localizationStore.string(.homeErrorCalculateFallback)
        }

        switch lifeWeightError {
        case .invalidHour:
            return localizationStore.string(.homeErrorInvalidHour)
        case .lunarDateConversionFailed:
            return localizationStore.string(.homeErrorLunarDateConversionFailed)
        case .missingYearInfo:
            return localizationStore.string(.homeErrorMissingYearInfo)
        case .missingMonthInfo:
            return localizationStore.string(.homeErrorMissingMonthInfo)
        case .missingDateInfo:
            return localizationStore.string(.homeErrorMissingDateInfo)
        case .missingHourInfo:
            return localizationStore.string(.homeErrorMissingHourInfo)
        case .missingPoemInfo:
            return localizationStore.string(.homeErrorMissingPoemInfo)
        }
    }

    @discardableResult
    private func saveHistoryRecord(result: LifeWeightResult, insight: LifeWeightInsight) -> HistoryRecord? {
        let record = HistoryRecord(
            id: UUID(),
            createdAt: Date(),
            solarDate: result.birthProfile.solarDate,
            hour: result.birthProfile.hour,
            gender: result.birthProfile.gender,
            lunarBirthday: result.lunarBirthDate.displayText,
            birthEightCharacters: BirthEightCharactersCalculator().calculate(
                solarDate: result.birthProfile.solarDate,
                hour: result.birthProfile.hour
            ),
            totalWeightText: result.totalWeightText,
            title: result.title,
            poem: result.poem,
            tags: insight.tags
        )

        do {
            try historyRecordStore.add(record)
            return record
        } catch {
            print("History record save failed: \(error.localizedDescription)")
            return nil
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(DataManager.shared)
            .environmentObject(LocalizationStore())
    }
}
