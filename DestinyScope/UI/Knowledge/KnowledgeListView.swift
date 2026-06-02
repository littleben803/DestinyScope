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
                        AppSectionHeader(title: localizationStore.string("common.loadFailed"))
                        Text(errorMessage)
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }
                    .padding(AppTheme.Spacing.lg)
                } else if articles.isEmpty {
                    AppCard {
                        Text(localizationStore.string("knowledge.empty.noContent"))
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }
                    .padding(AppTheme.Spacing.lg)
                } else {
                    contentView
                }
            }
        }
        .navigationTitle(localizationStore.string(.tabKnowledge))
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .automatic),
            prompt: Text(localizationStore.string("knowledge.search.prompt"))
        )
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
            Button(localizationStore.string(.homeSaveSheetCancel), role: .cancel) { }
        } message: {
            Text(localizationStore.string("knowledge.clearRecent.message"))
        }
        .confirmationDialog(
            localizationStore.string("knowledge.clearFavorites.confirmTitle"),
            isPresented: $isShowingClearFavoritesConfirmation,
            titleVisibility: .visible
        ) {
            Button(localizationStore.string("knowledge.clearFavorites.button"), role: .destructive, action: clearFavorites)
            Button(localizationStore.string(.homeSaveSheetCancel), role: .cancel) { }
        } message: {
            Text(localizationStore.string("knowledge.clearFavorites.message"))
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
                displayTitle: localizedCategoryTitle,
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
                     ? localizationStore.string(
                        "knowledge.summary.categoryCount",
                        replacements: ["count": "\(selectedCategoryCount)"]
                     )
                     : localizationStore.string(
                        "knowledge.summary.searchCount",
                        replacements: ["count": "\(filteredArticles.count)"]
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
        if selectedCategory == KnowledgeArticleFilter.favoriteCategory,
           searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return localizationStore.string("knowledge.empty.favoritesTitle")
        }
        return localizationStore.string("knowledge.empty.searchTitle")
    }

    private var emptyStateMessage: String {
        if selectedCategory == KnowledgeArticleFilter.favoriteCategory,
           searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? localizationStore.string("knowledge.error.loadFailed")
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
