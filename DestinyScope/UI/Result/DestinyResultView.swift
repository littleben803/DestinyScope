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

    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea() // 设置整个背景色，便于调试

            ScrollView {
                VStack(alignment: .center, spacing: 12) {
                    Text(result.title)
                        .font(.headline)

                    Text(result.lunarBirthDate.displayText)
                        .font(.subheadline)

                    Text("总重量：\(result.totalWeightText)")
                        .font(.subheadline)

                    Text(result.poem)
                        .font(.body)
                        .foregroundColor(.primary)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("权重明细")
                            .font(.headline)
                        weightRow(result.breakdown.year)
                        weightRow(result.breakdown.month)
                        weightRow(result.breakdown.day)
                        weightRow(result.breakdown.hour)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    interpretationSection
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(16)
                .padding(.horizontal)
                .padding(.top)
            }
        }
        .navigationTitle("命理结果")
    }

    private var interpretationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("总评")
                .font(.headline)
            Text(interpretation.summary)
                .font(.body)

            Text("性格")
                .font(.headline)
            Text(interpretation.personality)
                .font(.body)

            Text("事业")
                .font(.headline)
            Text(interpretation.career)
                .font(.body)

            Text("财运")
                .font(.headline)
            Text(interpretation.wealth)
                .font(.body)

            Text("关系")
                .font(.headline)
            Text(interpretation.relationship)
                .font(.body)

            Text(interpretation.safetyNotice)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func weightRow(_ item: WeightItem) -> some View {
        HStack {
            Text("\(item.label)：\(item.valueText)")
            Spacer()
            Text(item.weightText)
        }
        .font(.body)
    }
}
