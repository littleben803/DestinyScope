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
    @State private var shouldShowResult = false

    private let hours = Array(0...23)

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
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(DataManager.shared)
    }
}
