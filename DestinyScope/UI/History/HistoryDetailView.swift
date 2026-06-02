//
//  HistoryDetailView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct HistoryDetailView: View {
    let record: HistoryRecord
    let onRequestHomeTab: () -> Void

    @EnvironmentObject private var homeInputDraftStore: HomeInputDraftStore
    @EnvironmentObject private var localizationStore: LocalizationStore

    @State private var isFavorite = false
    @State private var isPinned = false
    @State private var stateMessage: String?

    private let userStateStore = HistoryRecordUserStateStore()

    init(record: HistoryRecord, onRequestHomeTab: @escaping () -> Void = {}) {
        self.record = record
        self.onRequestHomeTab = onRequestHomeTab
    }

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    summaryCard
                    HistoryRecordActionBar(
                        isFavorite: isFavorite,
                        isPinned: isPinned,
                        onToggleFavorite: toggleFavorite,
                        onTogglePinned: togglePinned,
                        onReuseInput: fillHomeInputDraft
                    )
                    if let stateMessage {
                        AppCard {
                            Text(stateMessage)
                                .font(AppTheme.Typography.footnote)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    poemCard
                    if !record.tags.isEmpty {
                        tagsCard
                    }
                    HistoryLocalNoticeView()
                    lightweightRecordNotice
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle(localizationStore.string("history.detail.navigationTitle"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadUserState)
    }

    private var summaryCard: some View {
        AppCard {
            Text(record.title)
                .font(AppTheme.Typography.pageTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            if isPinned || isFavorite {
                HStack(spacing: AppTheme.Spacing.sm) {
                    if isPinned {
                        HistoryRecordStateBadgeView(
                            title: localizationStore.string("history.badge.pinned"),
                            systemImageName: "pin.fill"
                        )
                    }

                    if isFavorite {
                        HistoryRecordStateBadgeView(
                            title: localizationStore.string("history.badge.favorite"),
                            systemImageName: "star.fill"
                        )
                    }
                }
            }

            Text(localizationStore.string(
                "history.detail.queryTime",
                replacements: ["time": record.createdAtDisplayText]
            ))
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)

            Divider()
                .background(AppTheme.Colors.divider)

            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text(record.birthDisplayText)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Text(record.lunarBirthday)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)

                Text(localizationStore.string(
                    "history.row.totalWeight",
                    replacements: ["weight": record.totalWeightText]
                ))
                    .font(AppTheme.Typography.body.weight(.semibold))
                    .foregroundColor(AppTheme.Colors.darkGold)
            }
        }
    }

    private var poemCard: some View {
        AppCard {
            AppSectionHeader(title: localizationStore.string("result.poem.title"))
            Text(record.poem)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var tagsCard: some View {
        AppCard {
            AppSectionHeader(title: localizationStore.string("knowledge.detail.tagsTitle"))
            HistoryTagGrid(tags: record.tags)
        }
    }

    private var lightweightRecordNotice: some View {
        AppCard {
            Text(localizationStore.string("history.detail.lightweightNotice"))
                .font(AppTheme.Typography.footnote)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func loadUserState() {
        do {
            let userState = try userStateStore.load()
            isFavorite = userState.favoriteRecordIDs.contains(record.id)
            isPinned = userState.pinnedRecordIDs.contains(record.id)
            stateMessage = nil
        } catch {
            isFavorite = false
            isPinned = false
            stateMessage = localizationStore.string("history.error.stateLoadFailed")
        }
    }

    private func toggleFavorite() {
        do {
            try userStateStore.toggleFavorite(id: record.id)
            loadUserState()
            stateMessage = isFavorite
                ? localizationStore.string("history.detail.favoriteAdded")
                : localizationStore.string("history.detail.favoriteRemoved")
        } catch {
            stateMessage = localizationStore.string("history.error.favoriteUpdateFailed")
        }
    }

    private func togglePinned() {
        do {
            try userStateStore.togglePinned(id: record.id)
            loadUserState()
            stateMessage = isPinned
                ? localizationStore.string("history.detail.pinned")
                : localizationStore.string("history.detail.unpinned")
        } catch {
            stateMessage = localizationStore.string("history.error.pinUpdateFailed")
        }
    }

    private func fillHomeInputDraft() {
        homeInputDraftStore.setDraft(
            birthDate: record.solarDate,
            hour: record.hour,
            source: localizationStore.string(
                "history.detail.draftSource",
                replacements: ["title": record.title]
            )
        )
        stateMessage = localizationStore.string("history.detail.reuseApplied")
        onRequestHomeTab()
    }
}
