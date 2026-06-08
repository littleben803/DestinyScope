//
//  LocalDataManagementView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct LocalDataManagementView: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    @State private var summary: LocalDataSummary
    @State private var pendingAction: LocalDataAction?
    @State private var message: String?

    private let service: LocalDataManagementService

    init(service: LocalDataManagementService = LocalDataManagementService()) {
        self.service = service
        _summary = State(initialValue: service.loadSummary())
    }

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    AppCard {
                        AppSectionHeader(title: localizationStore.string("localData.management.title"))

                        Text(localizationStore.string("localData.management.body"))
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(localizationStore.string("localData.management.footnote"))
                            .font(AppTheme.Typography.footnote)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    LocalDataSummaryCard(summary: summary)

                    if let message {
                        AppCard {
                            Text(message)
                                .font(AppTheme.Typography.footnote)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    AppCard {
                        AppSectionHeader(title: localizationStore.string("localData.actions.title"))

                        ForEach(LocalDataAction.allCases) { action in
                            LocalDataActionRow(
                                title: localizationStore.string(action.titleID),
                                subtitle: localizationStore.string(action.subtitleID),
                                systemImage: action.systemImage,
                                isDestructive: action.isDestructive
                            ) {
                                pendingAction = action
                            }

                            if action != LocalDataAction.allCases.last {
                                Divider()
                                    .background(AppTheme.Colors.divider)
                            }
                        }
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle(localizationStore.string("localData.management.navigationTitle"))
        .onAppear(perform: refreshSummary)
        .confirmationDialog(
            pendingAction.map { localizationStore.string($0.confirmationTitleID) }
                ?? localizationStore.string("common.confirmAction"),
            isPresented: Binding(
                get: { pendingAction != nil },
                set: { isPresented in
                    if !isPresented {
                        pendingAction = nil
                    }
                }
            ),
            titleVisibility: .visible,
            presenting: pendingAction
        ) { action in
            Button(localizationStore.string(action.confirmButtonTitleID), role: .destructive) {
                perform(action)
            }

            Button(localizationStore.string(.commonCancel), role: .cancel) {
                pendingAction = nil
            }
        } message: { action in
            Text(localizationStore.string(action.confirmationMessageID))
        }
    }

    private func refreshSummary() {
        summary = service.loadSummary()
    }

    private func perform(_ action: LocalDataAction) {
        do {
            switch action {
            case .clearHistory:
                try service.clearHistory()
            case .clearKnowledgeFavorites:
                try service.clearKnowledgeFavorites()
            case .clearKnowledgeRecentReads:
                try service.clearKnowledgeRecentReads()
            case .resetOnboarding:
                try service.resetOnboarding()
            case .clearAllUserLocalData:
                try service.clearAllUserLocalData()
            }

            message = localizationStore.string(action.successMessageID)
            pendingAction = nil
            refreshSummary()
        } catch {
            message = localizationStore.string("localData.error.operationFailed")
            pendingAction = nil
            refreshSummary()
        }
    }
}

private enum LocalDataAction: String, CaseIterable, Identifiable {
    case clearHistory
    case clearKnowledgeFavorites
    case clearKnowledgeRecentReads
    case resetOnboarding
    case clearAllUserLocalData

    var id: String { rawValue }

    var titleID: L10nID {
        switch self {
        case .clearHistory:
            return "localData.action.clearHistory.title"
        case .clearKnowledgeFavorites:
            return "localData.action.clearKnowledgeFavorites.title"
        case .clearKnowledgeRecentReads:
            return "localData.action.clearKnowledgeRecent.title"
        case .resetOnboarding:
            return "localData.action.resetOnboarding.title"
        case .clearAllUserLocalData:
            return "localData.action.clearAll.title"
        }
    }

    var subtitleID: L10nID {
        switch self {
        case .clearHistory:
            return "localData.action.clearHistory.subtitle"
        case .clearKnowledgeFavorites:
            return "localData.action.clearKnowledgeFavorites.subtitle"
        case .clearKnowledgeRecentReads:
            return "localData.action.clearKnowledgeRecent.subtitle"
        case .resetOnboarding:
            return "localData.action.resetOnboarding.subtitle"
        case .clearAllUserLocalData:
            return "localData.action.clearAll.subtitle"
        }
    }

    var systemImage: String {
        switch self {
        case .clearHistory:
            return "clock.badge.xmark"
        case .clearKnowledgeFavorites:
            return "star.slash"
        case .clearKnowledgeRecentReads:
            return "book.closed"
        case .resetOnboarding:
            return "arrow.counterclockwise.circle"
        case .clearAllUserLocalData:
            return "trash"
        }
    }

    var isDestructive: Bool {
        true
    }

    var confirmationTitleID: L10nID {
        titleID
    }

    var confirmationMessageID: L10nID {
        switch self {
        case .clearHistory:
            return "localData.action.clearHistory.confirmation"
        case .clearKnowledgeFavorites:
            return "localData.action.clearKnowledgeFavorites.confirmation"
        case .clearKnowledgeRecentReads:
            return "localData.action.clearKnowledgeRecent.confirmation"
        case .resetOnboarding:
            return "localData.action.resetOnboarding.confirmation"
        case .clearAllUserLocalData:
            return "localData.action.clearAll.confirmation"
        }
    }

    var confirmButtonTitleID: L10nID {
        switch self {
        case .resetOnboarding:
            return "common.reset"
        default:
            return "localData.action.confirmClean"
        }
    }

    var successMessageID: L10nID {
        switch self {
        case .clearHistory:
            return "localData.action.clearHistory.success"
        case .clearKnowledgeFavorites:
            return "localData.action.clearKnowledgeFavorites.success"
        case .clearKnowledgeRecentReads:
            return "localData.action.clearKnowledgeRecent.success"
        case .resetOnboarding:
            return "localData.action.resetOnboarding.success"
        case .clearAllUserLocalData:
            return "localData.action.clearAll.success"
        }
    }
}
