//
//  KnowledgeArticleRowView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct KnowledgeArticleRowView: View {
    let article: KnowledgeArticle
    var isFavorite = false

    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        AppCard {
            HStack(alignment: .center, spacing: AppTheme.Spacing.sm) {
                Text(localizationStore.string(categoryKind.titleID))
                    .font(AppTheme.Typography.caption.weight(.semibold))
                    .foregroundColor(AppTheme.Colors.darkGold)
                    .lineLimit(1)
                    .padding(.horizontal, AppTheme.Spacing.sm)
                    .padding(.vertical, AppTheme.Spacing.xs)
                    .background(AppTheme.Colors.secondaryBackground.opacity(0.55))
                    .clipShape(Capsule())

                Spacer(minLength: AppTheme.Spacing.sm)

                if isFavorite {
                    HStack(spacing: AppTheme.Spacing.xs) {
                        Image(systemName: "star.fill")
                        Text(localizationStore.string("knowledge.favorite.selected"))
                    }
                    .font(AppTheme.Typography.caption.weight(.semibold))
                    .foregroundColor(AppTheme.Colors.cinnabar)
                    .accessibilityLabel(localizationStore.string("knowledge.favorite.selected"))
                }
            }

            HStack(alignment: .firstTextBaseline, spacing: AppTheme.Spacing.sm) {
                Image(systemName: categoryKind.iconName)
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.darkGold)
                    .accessibilityHidden(true)

                Text(article.title)
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Text(article.summary)
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            if !article.tags.isEmpty {
                KnowledgeTagFlowView(tags: article.tags, limit: 3)
            }
        }
    }

    private var categoryKind: KnowledgeArticleCategoryKind {
        KnowledgeArticleLocalization.categoryKind(for: article)
    }
}
