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
        Group {
            if let errorMessage {
                Text(errorMessage)
                    .padding()
            } else if articles.isEmpty {
                Text("暂无知识库内容")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List(articles) { article in
                    NavigationLink(destination: KnowledgeDetailView(article: article)) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(article.title)
                                .font(.headline)
                            Text(article.summary)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(article.category)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
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
