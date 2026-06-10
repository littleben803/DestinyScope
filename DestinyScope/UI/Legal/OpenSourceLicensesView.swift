//
//  OpenSourceLicensesView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct OpenSourceLicensesView: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        AppBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    LegalSummaryCard(
                        title: localizationStore.string("legal.openSource.summary.title"),
                        bodyText: localizationStore.string("legal.openSource.summary.body"),
                        highlights: (0...2).map {
                            localizationStore.string(L10nID("legal.openSource.highlight.\($0)"))
                        }
                    )

                    LegalSectionCard(
                        title: localizationStore.string("legal.openSource.additional.title"),
                        bodyText: localizationStore.string("legal.openSource.additional.body")
                    )
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle(localizationStore.string(.legalOpenSourceNavigationTitle))
    }
}
