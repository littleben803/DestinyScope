//
//  FortuneQuestionView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import SwiftUI

struct FortuneQuestionView: View {
    let result: LifeWeightResult
    let interpretation: FortuneInterpretation
    let insight: LifeWeightInsight

    @EnvironmentObject private var localizationStore: LocalizationStore

    @State private var selectedQuestionID: String?
    @State private var answer: FortuneAnswer?

    private let answerer = TemplateFortuneQuestionAnswerer()

    private var questions: [FortuneQuestion] {
        [
            FortuneQuestion(id: "career", title: localizationStore.string("result.question.career"), intent: .career),
            FortuneQuestion(id: "wealth", title: localizationStore.string("result.question.wealth"), intent: .wealth),
            FortuneQuestion(id: "personality", title: localizationStore.string("result.question.personality"), intent: .personality),
            FortuneQuestion(id: "relationship", title: localizationStore.string("result.question.relationship"), intent: .relationship),
            FortuneQuestion(id: "daily_advice", title: localizationStore.string("result.question.dailyAdvice"), intent: .dailyAdvice)
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            AppSectionHeader(title: localizationStore.string("result.question.title"))

            Text(localizationStore.string("result.question.description"))
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)

            VStack(spacing: AppTheme.Spacing.sm) {
                ForEach(questions) { question in
                    Button {
                        select(question)
                    } label: {
                        HStack {
                            Text(question.title)
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.primaryText)
                            Spacer()
                            Image(systemName: selectedQuestionID == question.id ? "checkmark.circle.fill" : "chevron.right")
                                .font(AppTheme.Typography.secondary)
                                .foregroundColor(AppTheme.Colors.cinnabar)
                        }
                        .padding(AppTheme.Spacing.md)
                        .background(
                            selectedQuestionID == question.id
                                ? AppTheme.Colors.secondaryBackground
                                : AppTheme.Colors.cardBackground
                        )
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous)
                                .stroke(AppTheme.Colors.divider.opacity(0.6), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            if let answer {
                Divider()
                    .background(AppTheme.Colors.divider)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text(answer.questionTitle)
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(answer.answer)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(answer.safetyNotice)
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func select(_ question: FortuneQuestion) {
        selectedQuestionID = question.id
        answer = answerer.answer(
            question: question,
            result: result,
            interpretation: interpretation,
            insight: insight
        )
    }
}
