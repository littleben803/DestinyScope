//
//  HistoryListView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import SwiftUI

struct HistoryListView: View {
    @State private var records: [HistoryRecord] = []
    @State private var errorMessage: String?
    @State private var recordPendingDeletion: HistoryRecord?
    @State private var isShowingDeleteConfirmation = false
    @State private var isShowingDeleteAllConfirmation = false

    private let store = HistoryRecordStore()

    var body: some View {
        AppBackground {
            Group {
                if let errorMessage {
                    AppCard {
                        AppSectionHeader(title: "加载失败")
                        Text(errorMessage)
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)

                        Button("重新加载") {
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
                        }
                        .padding(AppTheme.Spacing.lg)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppTheme.Spacing.md) {
                            HistoryLocalNoticeView()

                            ForEach(records) { record in
                                HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
                                    NavigationLink(destination: HistoryDetailView(record: record)) {
                                        HistoryRecordRowView(record: record)
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
                                    .accessibilityLabel("删除历史记录")
                                    .accessibilityHint("删除这条本机历史记录，删除后无法恢复。")
                                }
                            }

                            Button(role: .destructive) {
                                isShowingDeleteAllConfirmation = true
                            } label: {
                                Text("清空全部")
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
        .navigationTitle("历史记录")
        .onAppear(perform: loadRecords)
        .alert("删除这条历史记录？", isPresented: $isShowingDeleteConfirmation) {
            Button("删除", role: .destructive) {
                if let recordPendingDeletion {
                    delete(recordPendingDeletion)
                }
                recordPendingDeletion = nil
            }

            Button("取消", role: .cancel) {
                recordPendingDeletion = nil
            }
        } message: {
            Text("此操作只会删除本机记录，无法恢复。")
        }
        .alert("清空全部历史记录？", isPresented: $isShowingDeleteAllConfirmation) {
            Button("清空", role: .destructive) {
                deleteAll()
            }

            Button("取消", role: .cancel) {}
        } message: {
            Text("此操作只会清空本机记录，无法恢复。")
        }
    }

    private func loadRecords() {
        do {
            records = try store.load()
            errorMessage = nil
        } catch {
            records = []
            errorMessage = "历史记录加载失败，请稍后重试。"
        }
    }

    private func delete(_ record: HistoryRecord) {
        do {
            try store.delete(id: record.id)
            loadRecords()
        } catch {
            errorMessage = "历史记录删除失败，请稍后重试。"
        }
    }

    private func deleteAll() {
        do {
            try store.deleteAll()
            loadRecords()
        } catch {
            errorMessage = "历史记录清空失败，请稍后重试。"
        }
    }
}

#Preview {
    NavigationStack {
        HistoryListView()
    }
}
