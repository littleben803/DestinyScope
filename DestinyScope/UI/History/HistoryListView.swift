//
//  HistoryListView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import SwiftUI

struct HistoryListView: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    @State private var records: [HistoryRecord] = []
    @State private var errorMessage: String?
    @State private var stateMessage: String?
    @State private var isShowingDeleteAllConfirmation = false
    @State private var selectedRecord: HistoryRecord?

    private let store = HistoryRecordStore()
    private let localDataManagementService = LocalDataManagementService()

    private var sortedRecords: [HistoryRecord] {
        records.sorted { $0.createdAt > $1.createdAt }
    }

    var body: some View {
        let pageTitle = localizationStore.string("history.navigation.title")

        AnimatedTitlePage(title: pageTitle) { titleContext in
            AppBackground {
                Group {
                    if let errorMessage {
                        messageScrollView(title: pageTitle, titleContext: titleContext) {
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
                        }
                    } else if records.isEmpty {
                        messageScrollView(title: pageTitle, titleContext: titleContext) {
                            HistoryEmptyStateView()
                            if let stateMessage {
                                AppCard {
                                    Text(stateMessage)
                                        .font(AppTheme.Typography.footnote)
                                        .foregroundColor(AppTheme.Colors.secondaryText)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                    } else {
                        recordsListView(title: pageTitle, titleContext: titleContext)
                    }
                }
            }
        }
        .navigationDestination(isPresented: isDetailPresented) {
            if let selectedRecord {
                HistoryDetailView(record: selectedRecord)
                    .environmentObject(localizationStore)
            }
        }
        .onAppear {
            loadRecords()
        }
        .alert(localizationStore.string("history.clearAll.confirmTitle"), isPresented: $isShowingDeleteAllConfirmation) {
            Button(localizationStore.string("common.clear"), role: .destructive) {
                deleteAll()
            }

            Button(localizationStore.string(.commonCancel), role: .cancel) {}
        } message: {
            Text(localizationStore.string("history.clearAll.confirmMessage"))
        }
    }

    private func messageScrollView<Content: View>(
        title: String,
        titleContext: AnimatedTitlePageContext,
        @ViewBuilder content: () -> Content
    ) -> some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.md) {
                AnimatedTitleHeader(title: title, titleOpacity: titleContext.largeTitleOpacity)
                content()
            }
            .padding(AppTheme.Spacing.lg)
        }
        .animatedTitleScrollTracking(titleContext)
    }

    private func recordsListView(title: String, titleContext: AnimatedTitlePageContext) -> some View {
        List {
            AnimatedTitleHeader(title: title, titleOpacity: titleContext.largeTitleOpacity)
                .historyListRowStyle()

            if let stateMessage {
                AppCard {
                    Text(stateMessage)
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .historyListRowStyle()
            }

            ForEach(sortedRecords) { record in
                Button {
                    selectedRecord = record
                } label: {
                    HistoryRecordRowView(record: record)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                .historyListRowStyle()
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        delete(record)
                    } label: {
                        Label(localizationStore.string("common.delete"), systemImage: "trash")
                    }
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
            .historyListRowStyle()
        }
        .listStyle(.plain)
        .listRowSpacing(AppTheme.Spacing.md)
        .scrollContentBackground(.hidden)
        .animatedTitleScrollTracking(titleContext)
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

    private func delete(_ record: HistoryRecord) {
        do {
            try store.delete(id: record.id)
            loadRecords()
            stateMessage = nil
        } catch {
            errorMessage = localizationStore.string("history.error.deleteFailed")
        }
    }

    private func deleteAll() {
        do {
            try localDataManagementService.clearHistory()
            loadRecords()
            stateMessage = nil
        } catch {
            errorMessage = localizationStore.string("history.error.clearFailed")
        }
    }

    private var isDetailPresented: Binding<Bool> {
        Binding {
            selectedRecord != nil
        } set: { isPresented in
            if !isPresented {
                selectedRecord = nil
            }
        }
    }
}

private extension View {
    func historyListRowStyle() -> some View {
        listRowInsets(
            EdgeInsets(
                top: 0,
                leading: AppTheme.Spacing.lg,
                bottom: 0,
                trailing: AppTheme.Spacing.lg
            )
        )
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    NavigationStack {
        HistoryListView()
            .environmentObject(LocalizationStore())
    }
}
