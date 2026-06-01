//
//  InterpretationCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct InterpretationCard: View {
    let interpretation: FortuneInterpretation

    @State private var expandedSections: Set<String> = ["summary", "personality"]

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                AppSectionHeader(title: "命理师解读")

                Text("以下为本地模板生成的五类参考解读，原始命理结果保持不变。")
                    .font(AppTheme.Typography.secondary)
                    .foregroundColor(AppTheme.Colors.secondaryText)

                interpretationSection(id: "summary", title: "总评", body: interpretation.summary)
                interpretationSection(id: "personality", title: "性格", body: interpretation.personality)
                interpretationSection(id: "career", title: "事业", body: interpretation.career)
                interpretationSection(id: "wealth", title: "财运", body: interpretation.wealth)
                interpretationSection(id: "relationship", title: "关系", body: interpretation.relationship)

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
