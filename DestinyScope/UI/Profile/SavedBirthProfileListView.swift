//
//  SavedBirthProfileListView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct SavedBirthProfileListView: View {
    @State private var profiles: [SavedBirthProfile] = []
    @State private var errorMessage: String?
    @State private var profilePendingDeletion: SavedBirthProfile?
    @State private var isShowingDeleteConfirmation = false
    @State private var isShowingDeleteAllConfirmation = false

    private let store = SavedBirthProfileStore()

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
                            loadProfiles()
                        }
                        .font(AppTheme.Typography.body.weight(.semibold))
                        .foregroundColor(AppTheme.Colors.cinnabar)
                    }
                    .padding(AppTheme.Spacing.lg)
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppTheme.Spacing.md) {
                            localNotice

                            if profiles.isEmpty {
                                emptyState
                            } else {
                                ForEach(profiles) { profile in
                                    HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
                                        SavedBirthProfileRowView(profile: profile)

                                        Button(role: .destructive) {
                                            profilePendingDeletion = profile
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
                                        .accessibilityLabel("删除常用出生资料")
                                        .accessibilityHint("删除这条本机常用出生资料，删除后无法恢复。")
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
                                .accessibilityLabel("清空全部常用出生资料")
                                .accessibilityHint("删除本机保存的全部常用出生资料。")
                            }
                        }
                        .padding(AppTheme.Spacing.lg)
                    }
                }
            }
        }
        .navigationTitle("常用出生资料")
        .onAppear(perform: loadProfiles)
        .alert("删除这条常用出生资料？", isPresented: $isShowingDeleteConfirmation) {
            Button("删除", role: .destructive) {
                if let profilePendingDeletion {
                    delete(profilePendingDeletion)
                }
                profilePendingDeletion = nil
            }

            Button("取消", role: .cancel) {
                profilePendingDeletion = nil
            }
        } message: {
            Text("此操作只会删除本机保存的资料，无法恢复。")
        }
        .alert("清空全部常用出生资料？", isPresented: $isShowingDeleteAllConfirmation) {
            Button("清空", role: .destructive) {
                deleteAll()
            }

            Button("取消", role: .cancel) {}
        } message: {
            Text("此操作只会清空本机保存的常用出生资料，无法恢复。")
        }
    }

    private var localNotice: some View {
        AppCard {
            AppSectionHeader(title: "本地保存")
            Text("常用资料仅保存在当前设备，不上传、不同步，也不需要账号。你可以随时删除。")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var emptyState: some View {
        AppCard {
            AppSectionHeader(title: "暂无常用出生资料")
            Text("你可以在首页保存常用出生日期和时辰，方便下次快速填写。")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func loadProfiles() {
        do {
            profiles = try store.load()
            errorMessage = nil
        } catch {
            profiles = []
            errorMessage = "常用出生资料加载失败，请稍后重试。"
        }
    }

    private func delete(_ profile: SavedBirthProfile) {
        do {
            try store.delete(id: profile.id)
            loadProfiles()
        } catch {
            errorMessage = "常用出生资料删除失败，请稍后重试。"
        }
    }

    private func deleteAll() {
        do {
            try store.deleteAll()
            loadProfiles()
        } catch {
            errorMessage = "常用出生资料清空失败，请稍后重试。"
        }
    }
}

#Preview {
    NavigationStack {
        SavedBirthProfileListView()
    }
}
