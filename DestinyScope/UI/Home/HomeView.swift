//
//  HomeView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var homeInputDraftStore: HomeInputDraftStore

    @State private var birthDate = Date()
    @State private var selectedHour = 0
    @State private var calculation: LifeWeightResult?
    @State private var interpretation: FortuneInterpretation?
    @State private var insight: LifeWeightInsight?
    @State private var errorMessage: String?
    @State private var profileMessage: String?
    @State private var draftBannerMessage: String?
    @State private var savedProfiles: [SavedBirthProfile] = []
    @State private var recentHistoryRecord: HistoryRecord?
    @State private var isShowingSaveProfileSheet = false
    @State private var shouldShowResult = false

    private let hours = Array(0...23)
    private let savedProfileStore = SavedBirthProfileStore()
    private let historyRecordStore = HistoryRecordStore()

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    HomeHeroCard()

                    HomePrivacyNoticeCard()

                    if let draftBannerMessage {
                        HomeInputDraftBanner(message: draftBannerMessage) {
                            self.draftBannerMessage = nil
                        }
                    }

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

                    HomeInputCard(
                        birthDate: $birthDate,
                        selectedHour: $selectedHour,
                        hours: hours,
                        errorMessage: errorMessage,
                        onSaveCurrent: {
                            isShowingSaveProfileSheet = true
                        },
                        onCalculate: calculateLifeWeight
                    )
                    .transition(.opacity.combined(with: .scale))
                    .animation(.easeInOut, value: errorMessage)

                    HomeRecentHistoryCard(record: recentHistoryRecord)

                    HomeKnowledgeEntryCard()
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("DestinyScope")
        .navigationDestination(isPresented: $shouldShowResult) {
            if let calculation, let interpretation, let insight {
                DestinyResultView(result: calculation, interpretation: interpretation, insight: insight)
            }
        }
        .onAppear {
            loadSavedProfiles()
            loadRecentHistory()
            applyPendingDraftIfNeeded()
        }
        .onReceive(homeInputDraftStore.$pendingDraft) { draft in
            guard draft != nil else { return }
            applyPendingDraftIfNeeded()
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
            let calculation = try engine.calculate(birthDate: birthDate, selectedHour: selectedHour)
            let interpretation = TemplateFortuneInterpreter().interpret(result: calculation)
            let insight = LifeWeightInsightGenerator().generate(result: calculation)
            let savedRecord = saveHistoryRecord(result: calculation, insight: insight)

            self.calculation = calculation
            self.interpretation = interpretation
            self.insight = insight
            errorMessage = nil
            draftBannerMessage = nil
            if let savedRecord {
                recentHistoryRecord = savedRecord
            }
            shouldShowResult = true
        } catch {
            calculation = nil
            interpretation = nil
            insight = nil
            shouldShowResult = false
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "暂时无法计算，请稍后重试。"
        }
    }

    @discardableResult
    private func saveHistoryRecord(result: LifeWeightResult, insight: LifeWeightInsight) -> HistoryRecord? {
        let record = HistoryRecord(
            id: UUID(),
            createdAt: Date(),
            solarDate: result.birthProfile.solarDate,
            hour: result.birthProfile.hour,
            lunarBirthday: result.lunarBirthDate.displayText,
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
            profileMessage = "常用出生资料加载失败，请稍后重试。"
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
        profileMessage = "已填入“\(profile.displayName)”，请确认后点击查询。"
        draftBannerMessage = nil
        errorMessage = nil
    }

    private func applyPendingDraftIfNeeded() {
        guard let draft = homeInputDraftStore.consumeDraft() else {
            return
        }

        birthDate = draft.birthDate
        selectedHour = draft.hour
        shouldShowResult = false
        draftBannerMessage = "已从\(draft.source)填入出生日期和时辰，请确认后点击查询。"
        profileMessage = nil
        errorMessage = nil
    }

    private func saveCurrentBirthProfile(displayName: String) {
        let trimmedName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalName = trimmedName.isEmpty ? "常用资料" : String(trimmedName.prefix(20))
        let now = Date()
        let profile = SavedBirthProfile(
            id: UUID(),
            displayName: finalName,
            birthDate: birthDate,
            hour: selectedHour,
            createdAt: now,
            updatedAt: now
        )

        do {
            try savedProfileStore.add(profile)
            loadSavedProfiles()
            profileMessage = "已保存“\(finalName)”，资料仅保存在本机。"
        } catch {
            profileMessage = "常用出生资料保存失败，请稍后重试。"
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(DataManager.shared)
            .environmentObject(HomeInputDraftStore())
    }
}
