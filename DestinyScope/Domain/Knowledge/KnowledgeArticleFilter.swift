//
//  KnowledgeArticleFilter.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct KnowledgeArticleFilter {
    static let allCategory = "全部"

    func categories(from articles: [KnowledgeArticle]) -> [String] {
        var seen = Set<String>()
        let categories = articles.compactMap { article -> String? in
            let category = article.category.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !category.isEmpty, !seen.contains(category) else {
                return nil
            }
            seen.insert(category)
            return category
        }
        return [Self.allCategory] + categories
    }

    func articleCount(for category: String, in articles: [KnowledgeArticle]) -> Int {
        if category == Self.allCategory {
            return articles.count
        }
        return articles.filter { $0.category == category }.count
    }

    func filteredArticles(
        articles: [KnowledgeArticle],
        selectedCategory: String,
        searchText: String
    ) -> [KnowledgeArticle] {
        let categoryFiltered = selectedCategory == Self.allCategory
            ? articles
            : articles.filter { $0.category == selectedCategory }

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
