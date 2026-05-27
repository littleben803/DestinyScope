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
                    }
                    .padding(AppTheme.Spacing.lg)
                } else if records.isEmpty {
                    AppCard {
                        AppSectionHeader(title: "历史记录")
                        Text("暂无历史记录，完成一次查询后会保存在本地。")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }
                    .padding(AppTheme.Spacing.lg)
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppTheme.Spacing.md) {
                            ForEach(records) { record in
                                recordCard(record)
                            }

                            Button(role: .destructive, action: deleteAll) {
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
    }

    private func recordCard(_ record: HistoryRecord) -> some View {
        AppCard {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text(record.title)
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(createdAtText(record.createdAt))
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.secondaryText)

                    Text("出生：\(solarDateText(record.solarDate)) \(String(format: "%02d 时", record.hour))")
                        .font(AppTheme.Typography.secondary)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(record.lunarBirthday)
                        .font(AppTheme.Typography.secondary)
                        .foregroundColor(AppTheme.Colors.secondaryText)

                    Text("总重量：\(record.totalWeightText)")
                        .font(AppTheme.Typography.secondary)
                        .foregroundColor(AppTheme.Colors.darkGold)

                    if !record.tags.isEmpty {
                        Text("标签：\(record.tags.joined(separator: "、"))")
                            .font(AppTheme.Typography.footnote)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }

                    Text(record.poem)
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .lineLimit(3)
                }

                Spacer()

                Button(role: .destructive) {
                    delete(record)
                } label: {
                    Image(systemName: "trash")
                        .font(AppTheme.Typography.secondary)
                        .foregroundColor(AppTheme.Colors.cinnabar)
                        .padding(AppTheme.Spacing.sm)
                }
                .buttonStyle(.plain)
            }
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

    private func createdAtText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月d日 HH:mm"
        return formatter.string(from: date)
    }

    private func solarDateText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月d日"
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        HistoryListView()
    }
}
