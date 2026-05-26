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
    @State private var errorMessage: String?
    @State private var shouldShowResult = false

    private let hours = Array(0...23)

    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea() // 设置整个背景色，便于调试

            VStack(spacing: 12) {
                Form {
                    Section(header: Text("").frame(height: 0)) {
                        DatePicker("出生日期", selection: $birthDate, displayedComponents: [.date])
                            .environment(\.locale, Locale(identifier: "zh_CN"))

                        Picker("出生时辰", selection: $selectedHour) {
                            ForEach(hours, id: \.self) { hour in
                                Text(String(format: "%02d 时", hour)).tag(hour)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.white.opacity(0.9))
                .frame(maxHeight: 140)
                .scrollDisabled(true)

                Button(action: calculateLifeWeight) {
                    Text("查询")
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        .background(Color(red: 140/255, green: 32/255, blue: 32/255))
                        .clipShape(Capsule())
                }

                if let errorMessage {
                    VStack(alignment: .center, spacing: 12) {
                        Text(errorMessage)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .transition(.opacity.combined(with: .scale))
                    .animation(.easeInOut, value: errorMessage)
                }

                Spacer()
            }
            .padding(.top)
            .navigationTitle("测试程序")
            .background(Color.clear)
        }
        .navigationDestination(isPresented: $shouldShowResult) {
            if let calculation, let interpretation {
                DestinyResultView(result: calculation, interpretation: interpretation)
            }
        }
    }

    private func calculateLifeWeight() {
        let engine = LifeWeightEngine(dataManager: dataManager)

        do {
            let calculation = try engine.calculate(birthDate: birthDate, selectedHour: selectedHour)
            let interpretation = TemplateFortuneInterpreter().interpret(result: calculation)

            self.calculation = calculation
            self.interpretation = interpretation
            errorMessage = nil
            shouldShowResult = true
        } catch {
            calculation = nil
            interpretation = nil
            shouldShowResult = false
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "暂时无法计算，请稍后重试。"
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(DataManager.shared)
    }
}
