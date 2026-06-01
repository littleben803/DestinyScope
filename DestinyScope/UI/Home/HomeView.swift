//
//  HomeView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var dataManager: DataManager

    @State private var birthDate = Date()
    @State private var selectedHour = 0
    @State private var calculation: LifeWeightResult?
    @State private var interpretation: FortuneInterpretation?
    @State private var insight: LifeWeightInsight?
    @State private var errorMessage: String?
    @State private var profileMessage: String?
    @State private var savedProfiles: [SavedBirthProfile] = []
    @State private var isShowingSaveProfileSheet = false
    @State private var shouldShowResult = false

    private let hours = Array(0...23)
    private let savedProfileStore = SavedBirthProfileStore()

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    AppCard {
                        AppSectionHeader(title: "出生信息")

                        DatePicker("出生日期", selection: $birthDate, displayedComponents: [.date])
                            .environment(\.locale, Locale(identifier: "zh_CN"))
                            .foregroundColor(AppTheme.Colors.primaryText)

                        Divider()
                            .background(AppTheme.Colors.divider)

                        Picker("出生时辰", selection: $selectedHour) {
                            ForEach(hours, id: \.self) { hour in
                                Text(String(format: "%02d 时", hour)).tag(hour)
                            }
                        }
                        .pickerStyle(.menu)
                        .foregroundColor(AppTheme.Colors.primaryText)
                    }

                    HomeBirthProfilePickerView(
                        profiles: savedProfiles,
                        onSelect: applySavedProfile,
                        onSaveCurrent: {
                            isShowingSaveProfileSheet = true
                        }
                    )

                    if let profileMessage {
                        Text(profileMessage)
                            .font(AppTheme.Typography.footnote)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    AppPrimaryButton(title: "查询", action: calculateLifeWeight)

                    if let errorMessage {
                        AppCard {
                            AppSectionHeader(title: "提示")
                            Text(errorMessage)
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.primaryText)
                        }
                        .transition(.opacity.combined(with: .scale))
                        .animation(.easeInOut, value: errorMessage)
                    }

                    Text("出生信息仅在设备端处理，结果仅供娱乐、自我探索和传统文化学习参考。")
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
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
        .onAppear(perform: loadSavedProfiles)
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
            saveHistoryRecord(result: calculation, insight: insight)

            self.calculation = calculation
            self.interpretation = interpretation
            self.insight = insight
            errorMessage = nil
            shouldShowResult = true
        } catch {
            calculation = nil
            interpretation = nil
            insight = nil
            shouldShowResult = false
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "暂时无法计算，请稍后重试。"
        }
    }

    private func saveHistoryRecord(result: LifeWeightResult, insight: LifeWeightInsight) {
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
            try HistoryRecordStore().add(record)
        } catch {
            print("History record save failed: \(error.localizedDescription)")
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

    private func applySavedProfile(_ profile: SavedBirthProfile) {
        birthDate = profile.birthDate
        selectedHour = profile.hour
        profileMessage = "已填入“\(profile.displayName)”，请确认后点击查询。"
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
    }
}
