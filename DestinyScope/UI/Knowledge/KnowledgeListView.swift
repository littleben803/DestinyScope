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
    @State private var libraryState = KnowledgeLibraryState.empty
    @State private var libraryStateMessage: String?
    @State private var isShowingClearRecentConfirmation = false
    @State private var isShowingClearFavoritesConfirmation = false

    private let repository = KnowledgeRepository()
    private let filter = KnowledgeArticleFilter()
    private let libraryStateStore = KnowledgeLibraryStateStore()

    private var categories: [String] {
        filter.categories(from: articles, includeFavorites: true)
    }

    private var filteredArticles: [KnowledgeArticle] {
        filter.filteredArticles(
            articles: articles,
            selectedCategory: selectedCategory,
            searchText: searchText,
            favoriteArticleIDs: libraryState.favoriteArticleIDs
        )
    }

    private var selectedCategoryCount: Int {
        filter.articleCount(
            for: selectedCategory,
            in: articles,
            favoriteArticleIDs: libraryState.favoriteArticleIDs
        )
    }

    private var favoriteArticleIDs: Set<String> {
        Set(libraryState.favoriteArticleIDs)
    }

    private var favoriteArticles: [KnowledgeArticle] {
        libraryState.favoriteArticleIDs.compactMap { articleId in
            articles.first { $0.id == articleId }
        }
    }

    private var recentArticles: [KnowledgeArticle] {
        libraryState.recentReads.compactMap { record in
            articles.first { $0.id == record.articleId }
        }
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
        .onAppear {
            loadArticles()
            loadLibraryState()
        }
        .confirmationDialog("清空最近阅读？", isPresented: $isShowingClearRecentConfirmation, titleVisibility: .visible) {
            Button("清空最近阅读", role: .destructive, action: clearRecentReads)
            Button("取消", role: .cancel) { }
        } message: {
            Text("此操作只会清空本机保存的知识库最近阅读记录，无法恢复。")
        }
        .confirmationDialog("清空收藏？", isPresented: $isShowingClearFavoritesConfirmation, titleVisibility: .visible) {
            Button("清空收藏", role: .destructive, action: clearFavorites)
            Button("取消", role: .cancel) { }
        } message: {
            Text("此操作只会清空本机保存的知识库收藏，无法恢复。")
        }
    }

    private var contentView: some View {
        VStack(spacing: 0) {
            KnowledgeCategoryFilterView(
                categories: categories,
                articleCount: { category in
                    filter.articleCount(
                        for: category,
                        in: articles,
                        favoriteArticleIDs: libraryState.favoriteArticleIDs
                    )
                },
                selectedCategory: $selectedCategory
            )

            ScrollView {
                LazyVStack(spacing: AppTheme.Spacing.md) {
                    KnowledgeLibrarySummaryView(
                        favoriteCount: favoriteArticles.count,
                        recentReadCount: recentArticles.count,
                        recentArticles: Array(recentArticles.prefix(3)),
                        onClearRecentReads: {
                            isShowingClearRecentConfirmation = true
                        },
                        onClearFavorites: {
                            isShowingClearFavoritesConfirmation = true
                        }
                    )

                    if let libraryStateMessage {
                        AppCard {
                            Text(libraryStateMessage)
                                .font(AppTheme.Typography.footnote)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    listSummaryView

                    if filteredArticles.isEmpty {
                        emptySearchView
                    } else {
                        ForEach(filteredArticles) { article in
                            NavigationLink(destination: KnowledgeDetailView(article: article)) {
                                KnowledgeArticleRowView(
                                    article: article,
                                    isFavorite: favoriteArticleIDs.contains(article.id)
                                )
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
                Text(summaryTitle)
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
            AppSectionHeader(title: emptyStateTitle)
            Text(emptyStateMessage)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var summaryTitle: String {
        if selectedCategory == KnowledgeArticleFilter.allCategory {
            return "全部文章"
        }
        if selectedCategory == KnowledgeArticleFilter.favoriteCategory {
            return "收藏文章"
        }
        return selectedCategory
    }

    private var emptyStateTitle: String {
        if selectedCategory == KnowledgeArticleFilter.favoriteCategory,
           searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "还没有收藏文章"
        }
        return "没有找到相关知识"
    }

    private var emptyStateMessage: String {
        if selectedCategory == KnowledgeArticleFilter.favoriteCategory,
           searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "可以在文章详情页点收藏，收藏记录仅保存在本机。"
        }
        return "可以换个关键词试试，或切换到“全部”分类浏览。"
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

    private func loadLibraryState() {
        do {
            libraryState = try libraryStateStore.load()
            libraryStateMessage = nil
        } catch {
            libraryState = .empty
            libraryStateMessage = "知识库本地收藏和最近阅读状态加载失败，请稍后重试。"
        }
    }

    private func clearRecentReads() {
        do {
            try libraryStateStore.clearRecentReads()
            loadLibraryState()
        } catch {
            libraryStateMessage = "最近阅读清空失败，请稍后重试。"
        }
    }

    private func clearFavorites() {
        do {
            try libraryStateStore.clearFavorites()
            loadLibraryState()
            if selectedCategory == KnowledgeArticleFilter.favoriteCategory {
                selectedCategory = KnowledgeArticleFilter.allCategory
            }
        } catch {
            libraryStateMessage = "收藏清空失败，请稍后重试。"
        }
    }
}
