//
//  MainContentView.swift
//  DestinyScope
//
//  Created by phoenix on 2025/4/8.
//

import SwiftUI

struct MainContentView: View {
    @EnvironmentObject var dataManager: DataManager
    
    @State private var birthDate = Date()
    @State private var selectedHour = 0
    // 命格标题
    @State private var lifeTitle: String = ""
    // 农历生日
    @State private var lunarBirthDate: String = ""
    // 评测结果
    @State private var result: String = ""
    @State private var errorMessage: String?
    
    let hours = Array(0...23)

    var body: some View {
        NavigationView {
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

                    resultView()

                    Spacer()
                }
                .padding(.top)
                .navigationTitle("测试程序")
                .background(Color.clear)
            }
        }
    }
    
    @ViewBuilder
    private func resultView() -> some View {
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
            .transition(.opacity.combined(with: .scale)) // 动画效果
            .animation(.easeInOut, value: errorMessage)
        } else if !result.isEmpty {
            VStack(alignment: .center, spacing: 12) {
                Text(lifeTitle)
                    .font(.headline)
                
                Text(lunarBirthDate)
                    .font(.subheadline)

                Text(result)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(16)
            .padding(.horizontal)
            .transition(.opacity.combined(with: .scale)) // 动画效果
            .animation(.easeInOut, value: result)
        }
    }

    func calculateLifeWeight() {
        let engine = LifeWeightEngine(dataManager: dataManager)
        do {
            let calculation = try engine.calculate(birthDate: birthDate, selectedHour: selectedHour)
            errorMessage = nil
            lunarBirthDate = calculation.lunarBirthDate.displayText
            lifeTitle = calculation.title
            result = calculation.poem
        } catch {
            lifeTitle = ""
            lunarBirthDate = ""
            result = ""
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "暂时无法计算，请稍后重试。"
        }
    }
}

#Preview {
    MainContentView()
}
