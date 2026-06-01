//
//  LocalDataManagementView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct LocalDataManagementView: View {
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
                        AppSectionHeader(title: "本地数据管理")

                        Text("以下数据仅保存在当前设备，不上传、不同步。删除后无法恢复。")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("清理操作不会删除内置知识库、称骨数据、模型文件或 App 资源。")
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
                        AppSectionHeader(title: "清理操作")

                        ForEach(LocalDataAction.allCases) { action in
                            LocalDataActionRow(
                                title: action.title,
                                subtitle: action.subtitle,
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
        .navigationTitle("本地数据管理")
        .onAppear(perform: refreshSummary)
        .confirmationDialog(
            pendingAction?.confirmationTitle ?? "确认操作",
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
            Button(action.confirmButtonTitle, role: .destructive) {
                perform(action)
            }

            Button("取消", role: .cancel) {
                pendingAction = nil
            }
        } message: { action in
            Text(action.confirmationMessage)
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
            case .clearHistoryUserState:
                try service.clearHistoryUserState()
            case .clearSavedBirthProfiles:
                try service.clearSavedBirthProfiles()
            case .clearKnowledgeFavorites:
                try service.clearKnowledgeFavorites()
            case .clearKnowledgeRecentReads:
                try service.clearKnowledgeRecentReads()
            case .resetOnboarding:
                try service.resetOnboarding()
            case .clearAllUserLocalData:
                try service.clearAllUserLocalData()
            }

            message = action.successMessage
            pendingAction = nil
            refreshSummary()
        } catch {
            message = "操作失败，请稍后重试。"
            pendingAction = nil
            refreshSummary()
        }
    }
}

private enum LocalDataAction: String, CaseIterable, Identifiable {
    case clearHistory
    case clearHistoryUserState
    case clearSavedBirthProfiles
    case clearKnowledgeFavorites
    case clearKnowledgeRecentReads
    case resetOnboarding
    case clearAllUserLocalData

    var id: String { rawValue }

    var title: String {
        switch self {
        case .clearHistory:
            return "清空历史记录"
        case .clearHistoryUserState:
            return "清空历史收藏 / 置顶状态"
        case .clearSavedBirthProfiles:
            return "清空常用出生资料"
        case .clearKnowledgeFavorites:
            return "清空知识库收藏"
        case .clearKnowledgeRecentReads:
            return "清空知识库最近阅读"
        case .resetOnboarding:
            return "重置首次使用说明"
        case .clearAllUserLocalData:
            return "清空全部本地用户数据"
        }
    }

    var subtitle: String {
        switch self {
        case .clearHistory:
            return "删除本机历史记录，并同步清理对应收藏和置顶状态。"
        case .clearHistoryUserState:
            return "只清理历史记录的收藏和置顶标记，不删除历史记录。"
        case .clearSavedBirthProfiles:
            return "删除保存在本机的常用出生日期和时辰。"
        case .clearKnowledgeFavorites:
            return "只清理文章收藏状态，不删除内置知识库文章。"
        case .clearKnowledgeRecentReads:
            return "只清理最近阅读记录，不删除内置知识库文章。"
        case .resetOnboarding:
            return "下次启动时重新展示首次使用说明，不删除其他数据。"
        case .clearAllUserLocalData:
            return "清空历史、常用资料、知识库状态和首次使用说明状态，不删除内置资源或模型文件。"
        }
    }

    var systemImage: String {
        switch self {
        case .clearHistory:
            return "clock.badge.xmark"
        case .clearHistoryUserState:
            return "pin.slash"
        case .clearSavedBirthProfiles:
            return "person.crop.circle.badge.xmark"
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

    var confirmationTitle: String {
        title
    }

    var confirmationMessage: String {
        switch self {
        case .clearHistory:
            return "此操作只会删除本机历史记录，并同步清理对应收藏和置顶状态。删除后无法恢复，不影响内置知识库和称骨数据。"
        case .clearHistoryUserState:
            return "此操作只会删除本机历史收藏和置顶状态，不删除历史记录。删除后无法恢复。"
        case .clearSavedBirthProfiles:
            return "此操作只会删除本机常用出生资料，不影响历史记录。删除后无法恢复。"
        case .clearKnowledgeFavorites:
            return "此操作只会删除本机知识库收藏状态，不删除内置文章。删除后无法恢复。"
        case .clearKnowledgeRecentReads:
            return "此操作只会删除本机知识库最近阅读记录，不删除内置文章。删除后无法恢复。"
        case .resetOnboarding:
            return "此操作只会重置本机首次使用说明状态，不删除历史、常用资料或知识库状态。"
        case .clearAllUserLocalData:
            return "此操作会清空本机历史记录、历史收藏和置顶、常用出生资料、知识库收藏、最近阅读和首次使用说明状态。不会删除内置知识库、称骨数据、模型文件或 App 资源。删除后无法恢复。"
        }
    }

    var confirmButtonTitle: String {
        switch self {
        case .resetOnboarding:
            return "重置"
        default:
            return "确认清理"
        }
    }

    var successMessage: String {
        switch self {
        case .clearHistory:
            return "已清空本机历史记录。"
        case .clearHistoryUserState:
            return "已清空本机历史收藏和置顶状态。"
        case .clearSavedBirthProfiles:
            return "已清空本机常用出生资料。"
        case .clearKnowledgeFavorites:
            return "已清空本机知识库收藏。"
        case .clearKnowledgeRecentReads:
            return "已清空本机知识库最近阅读。"
        case .resetOnboarding:
            return "已重置首次使用说明状态。"
        case .clearAllUserLocalData:
            return "已清空本机用户数据。"
        }
    }
}
