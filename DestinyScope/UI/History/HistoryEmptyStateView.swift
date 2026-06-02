//
//  HistoryEmptyStateView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct HistoryEmptyStateView: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        AppCard {
            AppSectionHeader(title: localizationStore.string("history.empty.title"))

            Text(localizationStore.string("history.empty.message"))
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            Text(localizationStore.string("history.empty.privacy"))
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
    }
}
