//
//  KnowledgeSearchResultsView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/10.
//

import SwiftUI

struct KnowledgeSearchResultsView: View {
    let articles: [KnowledgeArticle]

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localizationStore: LocalizationStore

    @State private var selectedCategory: String
    @State private var searchText = ""
    @State private var searchHistoryTerms: [String] = []
    @State private var libraryState = KnowledgeLibraryState.empty
    @State private var libraryStateMessage: String?

    private let filter = KnowledgeArticleFilter()
    private let libraryStateStore = KnowledgeLibraryStateStore()
    private let searchHistoryStore = KnowledgeSearchHistoryStore()

    private var normalizedSearchText: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    init(articles: [KnowledgeArticle], initialCategory: String) {
        self.articles = articles
        _selectedCategory = State(initialValue: initialCategory)
    }

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

    var body: some View {
        AppBackground {
            VStack(spacing: 0) {
                KnowledgeSearchInputView(
                    searchText: $searchText,
                    onSubmit: commitSearch
                ) {
                    dismiss()
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.top, AppTheme.Spacing.sm)
                .padding(.bottom, AppTheme.Spacing.sm)

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
                        if let libraryStateMessage {
                            AppCard {
                                Text(libraryStateMessage)
                                    .font(AppTheme.Typography.footnote)
                                    .foregroundColor(AppTheme.Colors.secondaryText)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }

                        listSummaryView

                        if normalizedSearchText.isEmpty {
                            initialSearchPlaceholderView
                        } else if filteredArticles.isEmpty {
                            emptySearchView
                        } else {
                            ForEach(filteredArticles) { article in
                                NavigationLink(
                                    destination: KnowledgeDetailView(article: article)
                                        .toolbar(.visible, for: .navigationBar)
                                ) {
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
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            loadLibraryState()
            loadSearchHistory()
            normalizeSelectedCategoryIfNeeded()
        }
    }

    @ViewBuilder
    private var listSummaryView: some View {
        searchHistorySection

        if normalizedSearchText.isEmpty {
            EmptyView()
        } else {
            searchResultSummaryView
        }
    }

    private var searchResultSummaryView: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(summaryTitle)
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Text(summaryCountText)
                    .font(AppTheme.Typography.footnote)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var searchHistorySection: some View {
        if !searchHistoryTerms.isEmpty {
            AppCard {
                HStack(alignment: .center, spacing: AppTheme.Spacing.sm) {
                    Text(localizationStore.string("knowledge.search.historyTitle"))
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Spacer(minLength: AppTheme.Spacing.sm)

                    Button(action: clearSearchHistory) {
                        Image(systemName: "trash")
                            .font(AppTheme.Typography.sectionTitle)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                            .frame(width: 32, height: 32)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(localizationStore.string("knowledge.search.clearHistory"))
                }

                KnowledgeSearchHistoryTagGrid(
                    terms: Array(searchHistoryTerms.prefix(10)),
                    onSelect: selectHistoryTerm
                )
            }
        }
    }

    private var initialSearchPlaceholderView: some View {
        AppCard {
            VStack(alignment: .center, spacing: AppTheme.Spacing.md) {
                Image(systemName: "magnifyingglass.circle")
                    .font(.system(size: 44, weight: .regular))
                    .foregroundColor(AppTheme.Colors.darkGold)
                    .accessibilityHidden(true)

                Text(localizationStore.string("knowledge.search.initialTitle"))
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .multilineTextAlignment(.center)

                Text(localizationStore.string("knowledge.search.initialMessage"))
                    .font(AppTheme.Typography.secondary)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
        }
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

    private var summaryCountText: String {
        if normalizedSearchText.isEmpty {
            return localizationStore.string(
                "knowledge.summary.categoryCount",
                replacements: ["count": "\(selectedCategoryCount)"]
            )
        }

        return localizationStore.string(
            "knowledge.summary.searchCount",
            replacements: ["count": "\(filteredArticles.count)"]
        )
    }

    private var emptyStateTitle: String {
        if selectedCategory == KnowledgeArticleFilter.favoriteCategory,
           normalizedSearchText.isEmpty {
            return localizationStore.string("knowledge.empty.favoritesTitle")
        }
        return localizationStore.string("knowledge.empty.searchTitle")
    }

    private var emptyStateMessage: String {
        if selectedCategory == KnowledgeArticleFilter.favoriteCategory,
           normalizedSearchText.isEmpty {
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

    private func loadLibraryState() {
        do {
            libraryState = try libraryStateStore.load()
            libraryStateMessage = nil
        } catch {
            libraryState = .empty
            libraryStateMessage = localizationStore.string("knowledge.error.stateLoadFailed")
        }
    }

    private func loadSearchHistory() {
        searchHistoryTerms = (try? searchHistoryStore.load()) ?? []
    }

    private func commitSearch() {
        guard !normalizedSearchText.isEmpty else {
            return
        }

        do {
            try searchHistoryStore.add(normalizedSearchText)
            loadSearchHistory()
        } catch {
            libraryStateMessage = localizationStore.string("knowledge.search.historySaveFailed")
        }
    }

    private func selectHistoryTerm(_ term: String) {
        searchText = term
        commitSearch()
    }

    private func clearSearchHistory() {
        do {
            try searchHistoryStore.clear()
            loadSearchHistory()
        } catch {
            libraryStateMessage = localizationStore.string("knowledge.search.historyClearFailed")
        }
    }

    private func normalizeSelectedCategoryIfNeeded() {
        guard !categories.contains(selectedCategory) else {
            return
        }
        selectedCategory = KnowledgeArticleFilter.allCategory
    }
}

private struct KnowledgeSearchInputView: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    @Binding var searchText: String
    let onSubmit: () -> Void
    let onClose: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .accessibilityHidden(true)

            TextField(
                "",
                text: $searchText,
                prompt: Text(localizationStore.string("knowledge.search.prompt"))
                    .foregroundColor(AppTheme.Colors.secondaryText)
            )
            .font(AppTheme.Typography.body)
            .foregroundColor(AppTheme.Colors.primaryText)
            .focused($isFocused)
            .submitLabel(.search)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .onSubmit(onSubmit)

            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(localizationStore.string("knowledge.search.close"))
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .background(isFocused ? AppTheme.Colors.paper : AppTheme.Colors.secondaryBackground.opacity(0.72))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(isFocused ? AppTheme.Colors.cinnabar.opacity(0.72) : AppTheme.Colors.divider.opacity(0.55), lineWidth: 1)
        )
        .shadow(color: isFocused ? AppTheme.Colors.cinnabar.opacity(0.12) : Color.clear, radius: 8, x: 0, y: 3)
        .animation(.easeInOut(duration: 0.18), value: isFocused)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                isFocused = true
            }
        }
    }
}

private struct KnowledgeSearchHistoryTagGrid: View {
    let terms: [String]
    let onSelect: (String) -> Void

    private let columns = [
        GridItem(.adaptive(minimum: 74), spacing: AppTheme.Spacing.sm, alignment: .leading)
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: AppTheme.Spacing.sm) {
            ForEach(terms, id: \.self) { term in
                Button {
                    onSelect(term)
                } label: {
                    Text(displayText(for: term))
                        .font(AppTheme.Typography.secondary.weight(.medium))
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .lineLimit(1)
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .frame(height: 34)
                        .frame(maxWidth: .infinity)
                        .background(AppTheme.Colors.paper)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(AppTheme.Colors.divider.opacity(0.32), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxHeight: 76, alignment: .top)
        .clipped()
    }

    private func displayText(for term: String) -> String {
        let maxLength = 8
        guard term.count > maxLength else {
            return term
        }
        return "\(term.prefix(maxLength))..."
    }
}
