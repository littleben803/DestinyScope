//
//  HistoryListView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import SwiftUI

struct HistoryListView: View {
    let onRequestHomeTab: () -> Void

    @EnvironmentObject private var localizationStore: LocalizationStore

    @State private var records: [HistoryRecord] = []
    @State private var userState = HistoryRecordUserState.empty
    @State private var errorMessage: String?
    @State private var stateMessage: String?
    @State private var recordPendingDeletion: HistoryRecord?
    @State private var isShowingDeleteConfirmation = false
    @State private var isShowingDeleteAllConfirmation = false

    private let store = HistoryRecordStore()
    private let userStateStore = HistoryRecordUserStateStore()

    init(onRequestHomeTab: @escaping () -> Void = {}) {
        self.onRequestHomeTab = onRequestHomeTab
    }

    private var sortedRecords: [HistoryRecord] {
        let pinnedIDs = Set(userState.pinnedRecordIDs)
        return records.sorted { lhs, rhs in
            let lhsPinned = pinnedIDs.contains(lhs.id)
            let rhsPinned = pinnedIDs.contains(rhs.id)

            if lhsPinned != rhsPinned {
                return lhsPinned
            }
            return lhs.createdAt > rhs.createdAt
        }
    }

    private var favoriteIDs: Set<UUID> {
        Set(userState.favoriteRecordIDs)
    }

    private var pinnedIDs: Set<UUID> {
        Set(userState.pinnedRecordIDs)
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

                        Button(localizationStore.string("common.reload")) {
                            loadRecords()
                        }
                        .font(AppTheme.Typography.body.weight(.semibold))
                        .foregroundColor(AppTheme.Colors.cinnabar)
                    }
                    .padding(AppTheme.Spacing.lg)
                } else if records.isEmpty {
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.md) {
                            HistoryEmptyStateView()
                            HistoryLocalNoticeView()
                            if let stateMessage {
                                AppCard {
                                    Text(stateMessage)
                                        .font(AppTheme.Typography.footnote)
                                        .foregroundColor(AppTheme.Colors.secondaryText)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        .padding(AppTheme.Spacing.lg)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppTheme.Spacing.md) {
                            HistoryLocalNoticeView()

                            if let stateMessage {
                                AppCard {
                                    Text(stateMessage)
                                        .font(AppTheme.Typography.footnote)
                                        .foregroundColor(AppTheme.Colors.secondaryText)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }

                            ForEach(sortedRecords) { record in
                                HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
                                    NavigationLink(
                                        destination: HistoryDetailView(
                                            record: record,
                                            onRequestHomeTab: onRequestHomeTab
                                        )
                                    ) {
                                        HistoryRecordRowView(
                                            record: record,
                                            isFavorite: favoriteIDs.contains(record.id),
                                            isPinned: pinnedIDs.contains(record.id)
                                        )
                                    }
                                    .buttonStyle(.plain)

                                    Button(role: .destructive) {
                                        recordPendingDeletion = record
                                        isShowingDeleteConfirmation = true
                                    } label: {
                                        Image(systemName: "trash")
                                            .font(AppTheme.Typography.secondary)
                                            .foregroundColor(AppTheme.Colors.cinnabar)
                                            .padding(AppTheme.Spacing.sm)
                                            .background(AppTheme.Colors.cardBackground)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(AppTheme.Colors.divider.opacity(0.55), lineWidth: 1)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityLabel(localizationStore.string("history.delete.accessibilityLabel"))
                                    .accessibilityHint(localizationStore.string("history.delete.accessibilityHint"))
                                }
                            }

                            Button(role: .destructive) {
                                isShowingDeleteAllConfirmation = true
                            } label: {
                                Text(localizationStore.string("common.clearAll"))
                                    .font(AppTheme.Typography.body)
                                    .foregroundColor(AppTheme.Colors.cinnabar)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, AppTheme.Spacing.md)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(AppTheme.Spacing.lg)
                    }
                }
            }
        }
        .navigationTitle(localizationStore.string("history.navigation.title"))
        .onAppear {
            loadRecords()
            loadUserState()
        }
        .alert(localizationStore.string("history.delete.confirmTitle"), isPresented: $isShowingDeleteConfirmation) {
            Button(localizationStore.string("common.delete"), role: .destructive) {
                if let recordPendingDeletion {
                    delete(recordPendingDeletion)
                }
                recordPendingDeletion = nil
            }

            Button(localizationStore.string(.homeSaveSheetCancel), role: .cancel) {
                recordPendingDeletion = nil
            }
        } message: {
            Text(localizationStore.string("history.delete.confirmMessage"))
        }
        .alert(localizationStore.string("history.clearAll.confirmTitle"), isPresented: $isShowingDeleteAllConfirmation) {
            Button(localizationStore.string("common.clear"), role: .destructive) {
                deleteAll()
            }

            Button(localizationStore.string(.homeSaveSheetCancel), role: .cancel) {}
        } message: {
            Text(localizationStore.string("history.clearAll.confirmMessage"))
        }
    }

    private func loadRecords() {
        do {
            records = try store.load()
            errorMessage = nil
        } catch {
            records = []
            errorMessage = localizationStore.string("history.error.loadFailed")
        }
    }

    private func loadUserState() {
        do {
            userState = try userStateStore.load()
            stateMessage = nil
        } catch {
            userState = .empty
            stateMessage = localizationStore.string("history.error.stateLoadFailed")
        }
    }

    private func delete(_ record: HistoryRecord) {
        do {
            try store.delete(id: record.id)
            let cleanupMessage: String?
            do {
                try userStateStore.remove(id: record.id)
                cleanupMessage = nil
            } catch {
                cleanupMessage = localizationStore.string("history.error.deleteCleanupFailed")
            }
            loadUserState()
            loadRecords()
            stateMessage = cleanupMessage
        } catch {
            errorMessage = localizationStore.string("history.error.deleteFailed")
        }
    }

    private func deleteAll() {
        do {
            try store.deleteAll()
            let cleanupMessage: String?
            do {
                try userStateStore.clearAll()
                cleanupMessage = nil
            } catch {
                cleanupMessage = localizationStore.string("history.error.clearCleanupFailed")
            }
            loadUserState()
            loadRecords()
            stateMessage = cleanupMessage
        } catch {
            errorMessage = localizationStore.string("history.error.clearFailed")
        }
    }
}

#Preview {
    NavigationStack {
        HistoryListView()
            .environmentObject(HomeInputDraftStore())
            .environmentObject(LocalizationStore())
    }
}
