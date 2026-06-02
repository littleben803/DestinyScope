//
//  KnowledgeRecentArticleRowView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct KnowledgeRecentArticleRowView: View {
    let article: KnowledgeArticle

    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            Image(systemName: "clock")
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.darkGold)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                HStack(alignment: .firstTextBaseline, spacing: AppTheme.Spacing.xs) {
                    Image(systemName: "book.closed")
                        .font(AppTheme.Typography.caption.weight(.semibold))
                        .foregroundColor(AppTheme.Colors.darkGold)
                        .accessibilityHidden(true)

                    Text(article.title)
                        .font(AppTheme.Typography.secondary.weight(.semibold))
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Text(localizationStore.string(KnowledgeArticleLocalization.categoryKind(for: article).titleID))
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }

            Spacer(minLength: AppTheme.Spacing.sm)

            Image(systemName: "chevron.right")
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            localizationStore.string(
                "knowledge.recent.row.accessibilityLabel",
                replacements: ["title": article.title]
            )
        )
        .accessibilityHint(localizationStore.string("knowledge.recent.row.accessibilityHint"))
    }
}
