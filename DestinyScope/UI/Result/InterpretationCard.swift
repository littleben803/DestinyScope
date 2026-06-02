//
//  InterpretationCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct InterpretationCard: View {
    let interpretation: FortuneInterpretation

    @EnvironmentObject private var localizationStore: LocalizationStore
    @State private var expandedSections: Set<String> = ["summary", "personality"]

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                AppSectionHeader(title: localizationStore.string("result.interpretation.title"))

                Text(localizationStore.string("result.interpretation.description"))
                    .font(AppTheme.Typography.secondary)
                    .foregroundColor(AppTheme.Colors.secondaryText)

                interpretationSection(id: "summary", title: localizationStore.string("result.interpretation.summary"), body: interpretation.summary)
                interpretationSection(id: "personality", title: localizationStore.string("result.interpretation.personality"), body: interpretation.personality)
                interpretationSection(id: "career", title: localizationStore.string("result.interpretation.career"), body: interpretation.career)
                interpretationSection(id: "wealth", title: localizationStore.string("result.interpretation.wealth"), body: interpretation.wealth)
                interpretationSection(id: "relationship", title: localizationStore.string("result.interpretation.relationship"), body: interpretation.relationship)

                Text(interpretation.safetyNotice)
                    .font(AppTheme.Typography.footnote)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
        }
    }

    private func interpretationSection(id: String, title: String, body: String) -> some View {
        DisclosureGroup(
            isExpanded: Binding(
                get: { expandedSections.contains(id) },
                set: { isExpanded in
                    if isExpanded {
                        expandedSections.insert(id)
                    } else {
                        expandedSections.remove(id)
                    }
                }
            )
        ) {
            Text(body)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .lineSpacing(4)
                .padding(.top, AppTheme.Spacing.xs)
        } label: {
            Text(title)
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
        }
        .tint(AppTheme.Colors.cinnabar)
        .padding(.vertical, AppTheme.Spacing.xs)
    }
}
