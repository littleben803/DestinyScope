//
//  KnowledgeLibrarySummaryView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct KnowledgeLibrarySummaryView: View {
    let favoriteCount: Int
    let recentReadCount: Int
    let recentArticles: [KnowledgeArticle]
    let onClearRecentReads: () -> Void
    let onClearFavorites: () -> Void

    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                AppSectionHeader(title: localizationStore.string("knowledge.summary.myLibrary"))

                Text(localizationStore.string("knowledge.summary.localNotice"))
                    .font(AppTheme.Typography.footnote)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: AppTheme.Spacing.sm) {
                    countBadge(
                        title: localizationStore.string("knowledge.summary.favoriteCount"),
                        count: favoriteCount,
                        systemImageName: "star.fill"
                    )
                    countBadge(
                        title: localizationStore.string("knowledge.summary.recentCount"),
                        count: recentReadCount,
                        systemImageName: "clock"
                    )
                }

                if !recentArticles.isEmpty {
                    Divider()
                        .background(AppTheme.Colors.divider)

                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text(localizationStore.string("knowledge.recent.title"))
                            .font(AppTheme.Typography.sectionTitle)
                            .foregroundColor(AppTheme.Colors.primaryText)

                        ForEach(recentArticles) { article in
                            NavigationLink(destination: KnowledgeDetailView(article: article)) {
                                KnowledgeRecentArticleRowView(article: article)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                if favoriteCount > 0 || recentReadCount > 0 {
                    Divider()
                        .background(AppTheme.Colors.divider)

                    HStack(spacing: AppTheme.Spacing.sm) {
                        if recentReadCount > 0 {
                            Button(localizationStore.string("knowledge.clearRecent.button"), action: onClearRecentReads)
                                .font(AppTheme.Typography.footnote.weight(.semibold))
                                .foregroundColor(AppTheme.Colors.cinnabar)
                                .accessibilityLabel(localizationStore.string("knowledge.clearRecent.button"))
                                .accessibilityHint(localizationStore.string("knowledge.clearRecent.accessibilityHint"))
                        }

                        if favoriteCount > 0 {
                            Button(localizationStore.string("knowledge.clearFavorites.button"), action: onClearFavorites)
                                .font(AppTheme.Typography.footnote.weight(.semibold))
                                .foregroundColor(AppTheme.Colors.cinnabar)
                                .accessibilityLabel(localizationStore.string("knowledge.clearFavorites.button"))
                                .accessibilityHint(localizationStore.string("knowledge.clearFavorites.accessibilityHint"))
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func countBadge(title: String, count: Int, systemImageName: String) -> some View {
        HStack(spacing: AppTheme.Spacing.xs) {
            Image(systemName: systemImageName)
            Text("\(title) \(count)")
        }
        .font(AppTheme.Typography.footnote.weight(.semibold))
        .foregroundColor(AppTheme.Colors.darkGold)
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(AppTheme.Colors.secondaryBackground.opacity(0.55))
        .clipShape(Capsule())
    }
}
