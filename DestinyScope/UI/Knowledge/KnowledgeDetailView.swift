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
        AppBackground {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    headerCard
                    bodyCard
                    metadataCard
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle(article.title)
    }

    private var headerCard: some View {
        AppCard {
            Text(article.category)
                .font(AppTheme.Typography.caption.weight(.semibold))
                .foregroundColor(AppTheme.Colors.darkGold)
                .lineLimit(1)
                .padding(.horizontal, AppTheme.Spacing.sm)
                .padding(.vertical, AppTheme.Spacing.xs)
                .background(AppTheme.Colors.secondaryBackground.opacity(0.55))
                .clipShape(Capsule())

            Text(article.title)
                .font(AppTheme.Typography.pageTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            Text(article.summary)
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var bodyCard: some View {
        AppCard {
            AppSectionHeader(title: "正文")

            ForEach(Array(bodyParagraphs.enumerated()), id: \.offset) { _, paragraph in
                Text(paragraph)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var metadataCard: some View {
        AppCard {
            if !article.tags.isEmpty {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text("标签")
                        .font(AppTheme.Typography.footnote.weight(.semibold))
                        .foregroundColor(AppTheme.Colors.secondaryText)
                    KnowledgeTagFlowView(tags: article.tags)
                }
            }

            Divider()
                .background(AppTheme.Colors.divider)

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text("来源")
                    .font(AppTheme.Typography.footnote.weight(.semibold))
                    .foregroundColor(AppTheme.Colors.secondaryText)
                Text(article.source ?? "未注明")
                    .font(AppTheme.Typography.footnote)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .textSelection(.enabled)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Text("版本：\(article.version)")
                .font(AppTheme.Typography.footnote)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
    }

    private var bodyParagraphs: [String] {
        let newlineParagraphs = article.body
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        if newlineParagraphs.count > 1 {
            return newlineParagraphs
        }

        return groupedSentences(from: article.body)
    }

    private func groupedSentences(from text: String) -> [String] {
        let sentences = text
            .components(separatedBy: "。")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { "\($0)。" }

        guard !sentences.isEmpty else {
            return [text]
        }

        var paragraphs: [String] = []
        var current = ""

        for sentence in sentences {
            if current.count + sentence.count > 120, !current.isEmpty {
                paragraphs.append(current)
                current = sentence
            } else {
                current += sentence
            }
        }

        if !current.isEmpty {
            paragraphs.append(current)
        }

        return paragraphs
    }
}
