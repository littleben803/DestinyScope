//
//  HistoryLocalNoticeView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct HistoryLocalNoticeView: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        AppCard {
            AppSectionHeader(title: localizationStore.string("history.localNotice.title"))

            Text(localizationStore.string("history.localNotice.body"))
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
