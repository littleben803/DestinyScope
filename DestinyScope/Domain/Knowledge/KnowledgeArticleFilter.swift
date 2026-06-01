//
//  KnowledgeArticleFilter.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct KnowledgeArticleFilter {
    static let allCategory = "全部"
    static let favoriteCategory = "收藏"

    func categories(from articles: [KnowledgeArticle], includeFavorites: Bool = false) -> [String] {
        var seen = Set<String>()
        let categories = articles.compactMap { article -> String? in
            let category = article.category.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !category.isEmpty, !seen.contains(category) else {
                return nil
            }
            seen.insert(category)
            return category
        }
        return includeFavorites ? [Self.allCategory, Self.favoriteCategory] + categories : [Self.allCategory] + categories
    }

    func articleCount(for category: String, in articles: [KnowledgeArticle], favoriteArticleIDs: [String] = []) -> Int {
        if category == Self.allCategory {
            return articles.count
        }
        if category == Self.favoriteCategory {
            let favoriteIDs = Set(favoriteArticleIDs)
            return articles.filter { favoriteIDs.contains($0.id) }.count
        }
        return articles.filter { $0.category == category }.count
    }

    func filteredArticles(
        articles: [KnowledgeArticle],
        selectedCategory: String,
        searchText: String,
        favoriteArticleIDs: [String] = []
    ) -> [KnowledgeArticle] {
        let favoriteIDs = Set(favoriteArticleIDs)
        let categoryFiltered: [KnowledgeArticle]
        if selectedCategory == Self.allCategory {
            categoryFiltered = articles
        } else if selectedCategory == Self.favoriteCategory {
            categoryFiltered = articles.filter { favoriteIDs.contains($0.id) }
        } else {
            categoryFiltered = articles.filter { $0.category == selectedCategory }
        }

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            return categoryFiltered
        }

        return categoryFiltered.filter { article in
            matches(article: article, query: query)
        }
    }

    private func matches(article: KnowledgeArticle, query: String) -> Bool {
        let lowercasedQuery = query.lowercased()
        let fields = [
            article.title,
            article.summary,
            article.category,
            article.body,
            article.tags.joined(separator: " ")
        ]

        return fields.contains { field in
            field.localizedCaseInsensitiveContains(query) ||
            field.lowercased().contains(lowercasedQuery)
        }
    }
}
