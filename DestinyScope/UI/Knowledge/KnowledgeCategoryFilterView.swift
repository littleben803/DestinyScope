//
//  KnowledgeCategoryFilterView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct KnowledgeCategoryFilterView: View {
    let categories: [String]
    let articleCount: (String) -> Int
    @Binding var selectedCategory: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.sm) {
                ForEach(categories, id: \.self) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        Text("\(category) \(articleCount(category))")
                            .font(AppTheme.Typography.footnote.weight(.semibold))
                            .foregroundColor(foregroundColor(for: category))
                            .lineLimit(1)
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.vertical, AppTheme.Spacing.sm)
                            .background(backgroundColor(for: category))
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(borderColor(for: category), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.sm)
        }
    }

    private func isSelected(_ category: String) -> Bool {
        selectedCategory == category
    }

    private func foregroundColor(for category: String) -> Color {
        isSelected(category) ? AppTheme.Colors.paper : AppTheme.Colors.primaryText
    }

    private func backgroundColor(for category: String) -> Color {
        isSelected(category) ? AppTheme.Colors.cinnabar : AppTheme.Colors.cardBackground
    }

    private func borderColor(for category: String) -> Color {
        isSelected(category) ? AppTheme.Colors.cinnabar : AppTheme.Colors.divider.opacity(0.65)
    }
}
