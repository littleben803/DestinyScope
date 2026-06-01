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
        .navigationTitle("历史详情")
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
                        HistoryRecordStateBadgeView(title: "置顶", systemImageName: "pin.fill")
                    }

                    if isFavorite {
                        HistoryRecordStateBadgeView(title: "收藏", systemImageName: "star.fill")
                    }
                }
            }

            Text("查询时间：\(record.createdAtDisplayText)")
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

                Text("总重量：\(record.totalWeightText)")
                    .font(AppTheme.Typography.body.weight(.semibold))
                    .foregroundColor(AppTheme.Colors.darkGold)
            }
        }
    }

    private var poemCard: some View {
        AppCard {
            AppSectionHeader(title: "称骨诗文")
            Text(record.poem)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var tagsCard: some View {
        AppCard {
            AppSectionHeader(title: "标签")
            HistoryTagGrid(tags: record.tags)
        }
    }

    private var lightweightRecordNotice: some View {
        AppCard {
            Text("这是一次历史查询的轻量记录，完整报告请重新查询生成。")
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
            stateMessage = "历史记录收藏和置顶状态加载失败，请稍后重试。"
        }
    }

    private func toggleFavorite() {
        do {
            try userStateStore.toggleFavorite(id: record.id)
            loadUserState()
            stateMessage = isFavorite ? "已收藏这条本机历史记录。" : "已取消收藏。"
        } catch {
            stateMessage = "收藏状态更新失败，请稍后重试。"
        }
    }

    private func togglePinned() {
        do {
            try userStateStore.togglePinned(id: record.id)
            loadUserState()
            stateMessage = isPinned ? "已置顶这条本机历史记录。" : "已取消置顶。"
        } catch {
            stateMessage = "置顶状态更新失败，请稍后重试。"
        }
    }

    private func fillHomeInputDraft() {
        homeInputDraftStore.setDraft(
            birthDate: record.solarDate,
            hour: record.hour,
            source: "历史记录：\(record.title)"
        )
        stateMessage = "已填入首页草稿，返回首页后可点击查询。"
        onRequestHomeTab()
    }
}
