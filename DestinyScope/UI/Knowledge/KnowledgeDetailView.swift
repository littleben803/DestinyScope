//
//  KnowledgeDetailView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct KnowledgeDetailView: View {
    let article: KnowledgeArticle

    @EnvironmentObject private var localizationStore: LocalizationStore

    @State private var isFavorite = false
    @State private var stateMessage: String?

    private let stateStore = KnowledgeLibraryStateStore()

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
        .onAppear {
            loadFavoriteState()
            recordRecentRead()
        }
    }

    private var headerCard: some View {
        AppCard {
            HStack(alignment: .center, spacing: AppTheme.Spacing.sm) {
                Text(localizationStore.string(KnowledgeArticleLocalization.categoryKind(for: article).titleID))
                    .font(AppTheme.Typography.caption.weight(.semibold))
                    .foregroundColor(AppTheme.Colors.darkGold)
                    .lineLimit(1)
                    .padding(.horizontal, AppTheme.Spacing.sm)
                    .padding(.vertical, AppTheme.Spacing.xs)
                    .background(AppTheme.Colors.secondaryBackground.opacity(0.55))
                    .clipShape(Capsule())

                Spacer(minLength: AppTheme.Spacing.sm)

                KnowledgeFavoriteButton(isFavorite: isFavorite, action: toggleFavorite)
            }

            Text(article.title)
                .font(AppTheme.Typography.pageTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            Text(article.summary)
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            if let stateMessage {
                Text(stateMessage)
                    .font(AppTheme.Typography.footnote)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var bodyCard: some View {
        AppCard {
            AppSectionHeader(title: localizationStore.string("knowledge.detail.bodyTitle"))

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
                    Text(localizationStore.string("knowledge.detail.tagsTitle"))
                        .font(AppTheme.Typography.footnote.weight(.semibold))
                        .foregroundColor(AppTheme.Colors.secondaryText)
                    KnowledgeTagFlowView(tags: article.tags)
                }
            }

            Divider()
                .background(AppTheme.Colors.divider)

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(localizationStore.string("knowledge.detail.sourceTitle"))
                    .font(AppTheme.Typography.footnote.weight(.semibold))
                    .foregroundColor(AppTheme.Colors.secondaryText)
                Text(article.source ?? localizationStore.string("knowledge.detail.sourceUnknown"))
                    .font(AppTheme.Typography.footnote)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .textSelection(.enabled)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Text(localizationStore.string("knowledge.detail.version", replacements: ["version": article.version]))
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

    private func loadFavoriteState() {
        isFavorite = stateStore.isFavorite(articleId: article.id)
    }

    private func recordRecentRead() {
        do {
            try stateStore.addRecentRead(articleId: article.id)
        } catch {
            stateMessage = localizationStore.string("knowledge.detail.recentSaveFailed")
        }
    }

    private func toggleFavorite() {
        do {
            try stateStore.toggleFavorite(articleId: article.id)
            isFavorite = stateStore.isFavorite(articleId: article.id)
            stateMessage = isFavorite
                ? localizationStore.string("knowledge.detail.favoriteAdded")
                : localizationStore.string("knowledge.detail.favoriteRemoved")
        } catch {
            stateMessage = localizationStore.string("knowledge.error.favoriteUpdateFailed")
        }
    }
}
