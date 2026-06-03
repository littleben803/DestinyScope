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
    @State private var profileMessage: String?
    @State private var savedProfiles: [SavedBirthProfile] = []
    @State private var recentHistoryRecord: HistoryRecord?
    @State private var isShowingSaveProfileSheet = false
    @State private var shouldShowResult = false

    private let hours = Array(0...23)
    private let savedProfileStore = SavedBirthProfileStore()
    private let historyRecordStore = HistoryRecordStore()
    private let lifeWeightReadingRepository = LifeWeightReadingRepository()

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    HomeHeroCard()

                    HomeInputCard(
                        birthDate: $birthDate,
                        selectedHour: $selectedHour,
                        selectedGender: $selectedGender,
                        hours: hours,
                        errorMessage: errorMessage,
                        onSaveCurrent: {
                            isShowingSaveProfileSheet = true
                        },
                        onCalculate: calculateLifeWeight
                    )
                    .transition(.opacity.combined(with: .scale))
                    .animation(.easeInOut, value: errorMessage)

                    HomeBirthProfilePickerView(
                        profiles: savedProfiles,
                        onSelect: applySavedProfile
                    )

                    if let profileMessage {
                        Text(profileMessage)
                            .font(AppTheme.Typography.footnote)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    HomeRecentHistoryCard(record: recentHistoryRecord)
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle(localizationStore.string(.appName))
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
        .onAppear {
            loadSavedProfiles()
            loadRecentHistory()
        }
        .sheet(isPresented: $isShowingSaveProfileSheet) {
            SaveBirthProfileSheet(birthDate: birthDate, hour: selectedHour) { displayName in
                saveCurrentBirthProfile(displayName: displayName)
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
            let savedRecord = saveHistoryRecord(result: calculation, insight: insight)

            self.calculation = calculation
            self.interpretation = interpretation
            self.insight = insight
            self.detailedReading = detailedReading
            errorMessage = nil
            if let savedRecord {
                recentHistoryRecord = savedRecord
            }
            shouldShowResult = true
        } catch {
            calculation = nil
            interpretation = nil
            insight = nil
            detailedReading = nil
            shouldShowResult = false
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? localizationStore.string(.homeErrorCalculateFallback)
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

    private func loadSavedProfiles() {
        do {
            savedProfiles = try savedProfileStore.load()
        } catch {
            savedProfiles = []
            profileMessage = localizationStore.string(.homeProfileLoadFailed)
        }
    }

    private func loadRecentHistory() {
        do {
            recentHistoryRecord = try historyRecordStore.load().first
        } catch {
            recentHistoryRecord = nil
        }
    }

    private func applySavedProfile(_ profile: SavedBirthProfile) {
        birthDate = profile.birthDate
        selectedHour = profile.hour
        selectedGender = profile.gender
        profileMessage = localizationStore.string(
            .homeProfileApplied,
            replacements: ["name": profile.displayName]
        )
        errorMessage = nil
    }

    private func saveCurrentBirthProfile(displayName: String) {
        let trimmedName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalName = trimmedName.isEmpty
            ? localizationStore.string(.homeProfileDefaultName)
            : String(trimmedName.prefix(20))
        let now = Date()
        let profile = SavedBirthProfile(
            id: UUID(),
            displayName: finalName,
            birthDate: birthDate,
            hour: selectedHour,
            gender: selectedGender,
            createdAt: now,
            updatedAt: now
        )

        do {
            try savedProfileStore.add(profile)
            loadSavedProfiles()
            profileMessage = localizationStore.string(
                .homeProfileSaved,
                replacements: ["name": finalName]
            )
        } catch {
            profileMessage = localizationStore.string(.homeProfileSaveFailed)
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
