//
//  LifeWeightReadingQuestionChipsView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/3.
//

import SwiftUI

struct LifeWeightReadingQuestion: Identifiable, Equatable {
    let id: String
    let title: String
    let answer: String
}

struct LifeWeightReadingQuestionChipsView: View {
    let questions: [LifeWeightReadingQuestion]
    @Binding var selectedQuestionID: String

    private let columns = [
        GridItem(.adaptive(minimum: 132), spacing: AppTheme.Spacing.sm, alignment: .leading)
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: AppTheme.Spacing.sm) {
            ForEach(questions) { question in
                Button {
                    selectedQuestionID = question.id
                } label: {
                    Text(question.title)
                        .font(AppTheme.Typography.caption.weight(.semibold))
                        .foregroundColor(selectedQuestionID == question.id ? .white : AppTheme.Colors.primaryText)
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, AppTheme.Spacing.sm)
                        .padding(.vertical, AppTheme.Spacing.xs)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.Radius.button, style: .continuous)
                                .fill(selectedQuestionID == question.id
                                      ? AppTheme.Colors.cinnabar
                                      : AppTheme.Colors.secondaryBackground.opacity(0.68))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.Radius.button, style: .continuous)
                                .stroke(AppTheme.Colors.divider.opacity(0.55), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selectedQuestionID == question.id ? .isSelected : [])
            }
        }
    }
}
