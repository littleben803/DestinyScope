//
//  DisclaimerView.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct DisclaimerView: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    private let sections: [(titleID: L10nID, bodyID: L10nID)] = [
        ("legal.disclaimer.section.culture.title", "legal.disclaimer.section.culture.body"),
        ("legal.disclaimer.section.boundary.title", "legal.disclaimer.section.boundary.body"),
        ("legal.disclaimer.section.nonAdvice.title", "legal.disclaimer.section.nonAdvice.body"),
        ("legal.disclaimer.section.health.title", "legal.disclaimer.section.health.body"),
        ("legal.disclaimer.section.finance.title", "legal.disclaimer.section.finance.body"),
        ("legal.disclaimer.section.relationship.title", "legal.disclaimer.section.relationship.body"),
        ("legal.disclaimer.section.promise.title", "legal.disclaimer.section.promise.body"),
        ("legal.disclaimer.section.localModel.title", "legal.disclaimer.section.localModel.body"),
        ("legal.disclaimer.section.majorDecision.title", "legal.disclaimer.section.majorDecision.body")
    ]

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    LegalSummaryCard(
                        title: localizationStore.string("legal.disclaimer.summary.title"),
                        bodyText: localizationStore.string("legal.disclaimer.summary.body"),
                        highlights: (0...2).map {
                            localizationStore.string(L10nID("legal.disclaimer.highlight.\($0)"))
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
        .navigationTitle(localizationStore.string(.legalDisclaimerNavigationTitle))
    }
}
