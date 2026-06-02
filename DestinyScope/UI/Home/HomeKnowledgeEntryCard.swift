//
//  HomeKnowledgeEntryCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct HomeKnowledgeEntryCard: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        AppCard {
            AppSectionHeader(title: localizationStore.string(.homeKnowledgeTitle))

            Text(localizationStore.string(.homeKnowledgeBody))
                .font(AppTheme.Typography.footnote)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
