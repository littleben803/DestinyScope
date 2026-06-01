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

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                AppSectionHeader(title: "我的知识库")

                Text("收藏和最近阅读仅保存在当前设备，不上传、不同步。")
                    .font(AppTheme.Typography.footnote)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: AppTheme.Spacing.sm) {
                    countBadge(title: "收藏", count: favoriteCount, systemImageName: "star.fill")
                    countBadge(title: "最近阅读", count: recentReadCount, systemImageName: "clock")
                }

                if !recentArticles.isEmpty {
                    Divider()
                        .background(AppTheme.Colors.divider)

                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("最近阅读")
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
                            Button("清空最近阅读", action: onClearRecentReads)
                                .font(AppTheme.Typography.footnote.weight(.semibold))
                                .foregroundColor(AppTheme.Colors.cinnabar)
                                .accessibilityLabel("清空最近阅读")
                                .accessibilityHint("清空本机保存的知识库最近阅读记录。")
                        }

                        if favoriteCount > 0 {
                            Button("清空收藏", action: onClearFavorites)
                                .font(AppTheme.Typography.footnote.weight(.semibold))
                                .foregroundColor(AppTheme.Colors.cinnabar)
                                .accessibilityLabel("清空收藏")
                                .accessibilityHint("清空本机保存的知识库收藏。")
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
