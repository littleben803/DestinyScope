//
//  KnowledgeDetailView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct KnowledgeDetailView: View {
    let article: KnowledgeArticle

    var body: some View {
        AppBackground {
            ScrollView {
                AppCard {
                    Text(article.category)
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.darkGold)

                    Text(article.title)
                        .font(AppTheme.Typography.pageTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(article.summary)
                        .font(AppTheme.Typography.secondary)
                        .foregroundColor(AppTheme.Colors.secondaryText)

                    Divider()
                        .background(AppTheme.Colors.divider)

                    Text(article.body)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    if !article.tags.isEmpty {
                        Text("标签：\(article.tags.joined(separator: "、"))")
                            .font(AppTheme.Typography.footnote)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }

                    Text("来源：\(article.source ?? "未注明") / 版本：\(article.version)")
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle(article.title)
    }
}
