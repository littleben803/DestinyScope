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
        if !result.isEmpty {
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
        // 拆分
        let (yearIndex, monthIndex, dateIndex) = dataManager.getChineseCalendarComponents(from: birthDate)
        guard let yearIndex, let monthIndex, let dateIndex else {
            return
        }
        // 对应的农历日期
        lunarBirthDate = ""
        var lifeWeight = 0.0
        if let index = dataManager.yearList.firstIndex(where: {$0.year == yearIndex}) {
            print("yearIndex", index)
            //zodiacImageView.image = UIImage(named: yearData[index].zodiacImageName)
            lunarBirthDate.append(dataManager.yearList[index].yearString + "年")
            lifeWeight += dataManager.yearList[index].weight
        }
        if let index = dataManager.monthList.firstIndex(where: {$0.month == monthIndex}) {
            lunarBirthDate.append(dataManager.monthList[index].monthString)
            lifeWeight += dataManager.monthList[index].weight
        }
        if let index = dataManager.dateList.firstIndex(where: {$0.date == dateIndex}) {
            lunarBirthDate.append(dataManager.dateList[index].dateString)
            lifeWeight += dataManager.dateList[index].weight
        }
        if let index = dataManager.hourList.firstIndex(where: {$0.hour == selectedHour}) {
            lunarBirthDate.append(dataManager.hourList[index].hourString)
            lifeWeight += dataManager.hourList[index].weight
        }

        // 生命重量
        print("lifeWeight", lifeWeight)
        
        var poemTitle = ""
        var poemContent = ""
        let epsilon: Double = 0.0001
        if let index = dataManager.poemList.firstIndex(where: { abs($0.weight - lifeWeight) < epsilon }) {
            poemTitle = dataManager.poemList[index].title
            poemContent = dataManager.poemList[index].content
        }
        
        if !poemTitle.isEmpty {
            lifeTitle = poemTitle
        }
        if !poemContent.isEmpty {
            result = poemContent
        }
        print("poemTitle: \(poemTitle)\n, poemContent: \(poemContent)")
    }
}

#Preview {
    MainContentView()
}
