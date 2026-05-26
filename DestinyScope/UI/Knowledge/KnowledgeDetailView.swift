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
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(article.category)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(article.title)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(article.summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(article.body)
                    .font(.body)

                if !article.tags.isEmpty {
                    Text("标签：\(article.tags.joined(separator: "、"))")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                Text("来源：\(article.source ?? "未注明") / 版本：\(article.version)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle(article.title)
    }
}
