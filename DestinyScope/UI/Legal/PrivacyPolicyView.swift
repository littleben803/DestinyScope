//
//  PrivacyPolicyView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    private let sections: [(titleID: L10nID, bodyID: L10nID)] = [
        ("legal.privacy.section.account.title", "legal.privacy.section.account.body"),
        ("legal.privacy.section.birth.title", "legal.privacy.section.birth.body"),
        ("legal.privacy.section.history.title", "legal.privacy.section.history.body"),
        ("legal.privacy.section.knowledgeState.title", "legal.privacy.section.knowledgeState.body"),
        ("legal.privacy.section.localData.title", "legal.privacy.section.localData.body"),
        ("legal.privacy.section.network.title", "legal.privacy.section.network.body"),
        ("legal.privacy.section.share.title", "legal.privacy.section.share.body"),
        ("legal.privacy.section.permissions.title", "legal.privacy.section.permissions.body"),
        ("legal.privacy.section.tracking.title", "legal.privacy.section.tracking.body"),
        ("legal.privacy.section.resources.title", "legal.privacy.section.resources.body"),
        ("legal.privacy.section.future.title", "legal.privacy.section.future.body"),
        ("legal.privacy.section.contact.title", "legal.privacy.section.contact.body")
    ]

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    LegalSummaryCard(
                        title: localizationStore.string("legal.privacy.summary.title"),
                        bodyText: localizationStore.string("legal.privacy.summary.body"),
                        highlights: (0...4).map {
                            localizationStore.string(L10nID("legal.privacy.highlight.\($0)"))
                        }
                    )

                    ForEach(sections, id: \.titleID) { section in
                        LegalSectionCard(
                            title: localizationStore.string(section.titleID),
                            bodyText: localizationStore.string(section.bodyID)
                        )
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle(localizationStore.string(.legalPrivacyNavigationTitle))
    }
}
