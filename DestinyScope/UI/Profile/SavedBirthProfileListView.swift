//
//  SavedBirthProfileListView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct SavedBirthProfileListView: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

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
                        AppSectionHeader(title: localizationStore.string("common.loadFailed"))
                        Text(errorMessage)
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)

                        Button(localizationStore.string("common.reload")) {
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
                                        .accessibilityLabel(localizationStore.string("profile.delete.accessibilityLabel"))
                                        .accessibilityHint(localizationStore.string("profile.delete.accessibilityHint"))
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
                                .accessibilityLabel(localizationStore.string("profile.clearAll.accessibilityLabel"))
                                .accessibilityHint(localizationStore.string("profile.clearAll.accessibilityHint"))
                            }
                        }
                        .padding(AppTheme.Spacing.lg)
                    }
                }
            }
        }
        .navigationTitle(localizationStore.string(.settingsSavedProfilesTitle))
        .onAppear(perform: loadProfiles)
        .alert(localizationStore.string("profile.delete.confirmTitle"), isPresented: $isShowingDeleteConfirmation) {
            Button(localizationStore.string("common.delete"), role: .destructive) {
                if let profilePendingDeletion {
                    delete(profilePendingDeletion)
                }
                profilePendingDeletion = nil
            }

            Button(localizationStore.string(.homeSaveSheetCancel), role: .cancel) {
                profilePendingDeletion = nil
            }
        } message: {
            Text(localizationStore.string("profile.delete.confirmMessage"))
        }
        .alert(localizationStore.string("profile.clearAll.confirmTitle"), isPresented: $isShowingDeleteAllConfirmation) {
            Button(localizationStore.string("common.clear"), role: .destructive) {
                deleteAll()
            }

            Button(localizationStore.string(.homeSaveSheetCancel), role: .cancel) {}
        } message: {
            Text(localizationStore.string("profile.clearAll.confirmMessage"))
        }
    }

    private var localNotice: some View {
        AppCard {
            AppSectionHeader(title: localizationStore.string("profile.localNotice.title"))
            Text(localizationStore.string("profile.localNotice.body"))
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var emptyState: some View {
        AppCard {
            AppSectionHeader(title: localizationStore.string("profile.empty.title"))
            Text(localizationStore.string("profile.empty.message"))
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
            errorMessage = localizationStore.string(.homeProfileLoadFailed)
        }
    }

    private func delete(_ profile: SavedBirthProfile) {
        do {
            try store.delete(id: profile.id)
            loadProfiles()
        } catch {
            errorMessage = localizationStore.string("profile.error.deleteFailed")
        }
    }

    private func deleteAll() {
        do {
            try store.deleteAll()
            loadProfiles()
        } catch {
            errorMessage = localizationStore.string("profile.error.clearFailed")
        }
    }
}

#Preview {
    NavigationStack {
        SavedBirthProfileListView()
            .environmentObject(LocalizationStore())
    }
}
