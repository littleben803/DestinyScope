//
//  KnowledgeListView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct KnowledgeListView: View {
    @State private var articles: [KnowledgeArticle] = []
    @State private var errorMessage: String?

    private let repository = KnowledgeRepository()

    var body: some View {
        AppBackground {
            Group {
                if let errorMessage {
                    AppCard {
                        AppSectionHeader(title: "加载失败")
                        Text(errorMessage)
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }
                    .padding(AppTheme.Spacing.lg)
                } else if articles.isEmpty {
                    AppCard {
                        Text("暂无知识库内容")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }
                    .padding(AppTheme.Spacing.lg)
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppTheme.Spacing.md) {
                            ForEach(articles) { article in
                                NavigationLink(destination: KnowledgeDetailView(article: article)) {
                                    AppCard {
                                        Text(article.category)
                                            .font(AppTheme.Typography.caption)
                                            .foregroundColor(AppTheme.Colors.darkGold)

                                        Text(article.title)
                                            .font(AppTheme.Typography.sectionTitle)
                                            .foregroundColor(AppTheme.Colors.primaryText)

                                        Text(article.summary)
                                            .font(AppTheme.Typography.secondary)
                                            .foregroundColor(AppTheme.Colors.secondaryText)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(AppTheme.Spacing.lg)
                    }
                }
            }
        }
        .navigationTitle("知识库")
        .onAppear(perform: loadArticles)
    }

    private func loadArticles() {
        do {
            articles = try repository.articles()
            errorMessage = nil
        } catch {
            articles = []
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "知识库加载失败，请稍后重试。"
        }
    }
}
