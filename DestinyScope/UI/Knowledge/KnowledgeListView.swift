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
    @State private var selectedCategory = KnowledgeArticleFilter.allCategory
    @State private var searchText = ""

    private let repository = KnowledgeRepository()
    private let filter = KnowledgeArticleFilter()

    private var categories: [String] {
        filter.categories(from: articles)
    }

    private var filteredArticles: [KnowledgeArticle] {
        filter.filteredArticles(
            articles: articles,
            selectedCategory: selectedCategory,
            searchText: searchText
        )
    }

    private var selectedCategoryCount: Int {
        filter.articleCount(for: selectedCategory, in: articles)
    }

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
                    contentView
                }
            }
        }
        .navigationTitle("知识库")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "搜索标题、摘要、标签")
        .onAppear(perform: loadArticles)
    }

    private var contentView: some View {
        VStack(spacing: 0) {
            KnowledgeCategoryFilterView(
                categories: categories,
                articleCount: { category in
                    filter.articleCount(for: category, in: articles)
                },
                selectedCategory: $selectedCategory
            )

            ScrollView {
                LazyVStack(spacing: AppTheme.Spacing.md) {
                    listSummaryView

                    if filteredArticles.isEmpty {
                        emptySearchView
                    } else {
                        ForEach(filteredArticles) { article in
                            NavigationLink(destination: KnowledgeDetailView(article: article)) {
                                KnowledgeArticleRowView(article: article)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
    }

    private var listSummaryView: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(selectedCategory == KnowledgeArticleFilter.allCategory ? "全部文章" : selectedCategory)
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Text(searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                     ? "当前分类共 \(selectedCategoryCount) 篇"
                     : "在当前分类中找到 \(filteredArticles.count) 篇")
                    .font(AppTheme.Typography.footnote)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var emptySearchView: some View {
        AppCard {
            AppSectionHeader(title: "没有找到相关知识")
            Text("可以换个关键词试试，或切换到“全部”分类浏览。")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func loadArticles() {
        do {
            articles = try repository.articles()
            if !categories.contains(selectedCategory) {
                selectedCategory = KnowledgeArticleFilter.allCategory
            }
            errorMessage = nil
        } catch {
            articles = []
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "知识库加载失败，请稍后重试。"
        }
    }
}
