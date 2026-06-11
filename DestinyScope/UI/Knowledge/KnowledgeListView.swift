//
//  KnowledgeListView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct KnowledgeListView: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    @State private var articles: [KnowledgeArticle] = []
    @State private var errorMessage: String?
    @State private var selectedCategory = KnowledgeArticleFilter.allCategory
    @State private var isShowingSearchResults = false
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
            searchText: "",
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
        let pageTitle = localizationStore.string(.tabKnowledge)

        AnimatedTitlePage(title: pageTitle) { titleContext in
            AppBackground {
                Group {
                    if let errorMessage {
                        messageScrollView(title: pageTitle, titleContext: titleContext) {
                            AppCard {
                                AppSectionHeader(title: localizationStore.string("common.loadFailed"))
                                Text(errorMessage)
                                    .font(AppTheme.Typography.body)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                            }
                        }
                    } else if articles.isEmpty {
                        messageScrollView(title: pageTitle, titleContext: titleContext) {
                            AppCard {
                                Text(localizationStore.string("knowledge.empty.noContent"))
                                    .font(AppTheme.Typography.body)
                                    .foregroundColor(AppTheme.Colors.secondaryText)
                            }
                        }
                    } else {
                        contentView(title: pageTitle, titleContext: titleContext)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingSearchResults, onDismiss: loadLibraryState) {
            NavigationStack {
                KnowledgeSearchResultsView(
                    articles: articles,
                    initialCategory: selectedCategory
                )
            }
        }
        .onAppear {
            loadArticles()
            loadLibraryState()
        }
        .confirmationDialog(
            localizationStore.string("knowledge.clearRecent.confirmTitle"),
            isPresented: $isShowingClearRecentConfirmation,
            titleVisibility: .visible
        ) {
            Button(localizationStore.string("knowledge.clearRecent.button"), role: .destructive, action: clearRecentReads)
            Button(localizationStore.string(.commonCancel), role: .cancel) { }
        } message: {
            Text(localizationStore.string("knowledge.clearRecent.message"))
        }
        .confirmationDialog(
            localizationStore.string("knowledge.clearFavorites.confirmTitle"),
            isPresented: $isShowingClearFavoritesConfirmation,
            titleVisibility: .visible
        ) {
            Button(localizationStore.string("knowledge.clearFavorites.button"), role: .destructive, action: clearFavorites)
            Button(localizationStore.string(.commonCancel), role: .cancel) { }
        } message: {
            Text(localizationStore.string("knowledge.clearFavorites.message"))
        }
    }

    private func messageScrollView<Content: View>(
        title: String,
        titleContext: AnimatedTitlePageContext,
        @ViewBuilder content: () -> Content
    ) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                AnimatedTitleHeader(title: title, titleOpacity: titleContext.largeTitleOpacity)
                content()
            }
            .padding(AppTheme.Spacing.lg)
        }
        .animatedTitleScrollTracking(titleContext)
    }

    private func contentView(title: String, titleContext: AnimatedTitlePageContext) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                AnimatedTitleHeader(title: title, titleOpacity: titleContext.largeTitleOpacity)

            KnowledgeSearchLaunchButton {
                isShowingSearchResults = true
            }

            KnowledgeCategoryFilterView(
                categories: categories,
                articleCount: { category in
                    filter.articleCount(
                        for: category,
                        in: articles,
                        favoriteArticleIDs: libraryState.favoriteArticleIDs
                    )
                },
                displayTitle: localizedCategoryTitle,
                selectedCategory: $selectedCategory
            )
            .padding(.horizontal, -AppTheme.Spacing.lg)

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
        .animatedTitleScrollTracking(titleContext)
    }

    private var listSummaryView: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(summaryTitle)
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Text(localizationStore.string(
                        "knowledge.summary.categoryCount",
                        replacements: ["count": "\(selectedCategoryCount)"]
                ))
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
            return localizationStore.string("knowledge.summary.allArticles")
        }
        if selectedCategory == KnowledgeArticleFilter.favoriteCategory {
            return localizationStore.string("knowledge.summary.favoriteArticles")
        }
        return localizedCategoryTitle(selectedCategory)
    }

    private var emptyStateTitle: String {
        if selectedCategory == KnowledgeArticleFilter.favoriteCategory {
            return localizationStore.string("knowledge.empty.favoritesTitle")
        }
        return localizationStore.string("knowledge.empty.searchTitle")
    }

    private var emptyStateMessage: String {
        if selectedCategory == KnowledgeArticleFilter.favoriteCategory {
            return localizationStore.string("knowledge.empty.favoritesMessage")
        }
        return localizationStore.string("knowledge.empty.searchMessage")
    }

    private func localizedCategoryTitle(_ category: String) -> String {
        if category == KnowledgeArticleFilter.allCategory {
            return localizationStore.string("knowledge.category.all")
        }
        if category == KnowledgeArticleFilter.favoriteCategory {
            return localizationStore.string("knowledge.category.favorite")
        }
        if let article = articles.first(where: { $0.category == category }) {
            return localizationStore.string(KnowledgeArticleLocalization.categoryKind(for: article).titleID)
        }
        return category
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
            errorMessage = localizationStore.string("knowledge.error.loadFailed")
        }
    }

    private func loadLibraryState() {
        do {
            libraryState = try libraryStateStore.load()
            libraryStateMessage = nil
        } catch {
            libraryState = .empty
            libraryStateMessage = localizationStore.string("knowledge.error.stateLoadFailed")
        }
    }

    private func clearRecentReads() {
        do {
            try libraryStateStore.clearRecentReads()
            loadLibraryState()
        } catch {
            libraryStateMessage = localizationStore.string("knowledge.error.clearRecentFailed")
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
            libraryStateMessage = localizationStore.string("knowledge.error.clearFavoritesFailed")
        }
    }
}

private struct KnowledgeSearchLaunchButton: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: "magnifyingglass")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .accessibilityHidden(true)

                Text(localizationStore.string("knowledge.search.prompt"))
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .lineLimit(1)

                Spacer()
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .background(AppTheme.Colors.secondaryBackground.opacity(0.72))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(AppTheme.Colors.divider.opacity(0.55), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(localizationStore.string("knowledge.search.launch.accessibilityLabel"))
    }
}
