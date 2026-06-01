//
//  KnowledgeRecentArticleRowView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct KnowledgeRecentArticleRowView: View {
    let article: KnowledgeArticle

    var body: some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            Image(systemName: "clock")
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.darkGold)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(article.title)
                    .font(AppTheme.Typography.secondary.weight(.semibold))
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Text(article.category)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }

            Spacer(minLength: AppTheme.Spacing.sm)

            Image(systemName: "chevron.right")
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("最近阅读 \(article.title)")
        .accessibilityHint("打开这篇知识库文章。")
    }
}
