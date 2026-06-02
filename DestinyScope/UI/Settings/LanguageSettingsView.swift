//
//  LanguageSettingsView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct LanguageSettingsView: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    var body: some View {
        AppBackground {
            ScrollView {
                SettingsSectionCard(
                    title: localizationStore.string(.languageSettingsSectionTitle),
                    subtitle: localizationStore.string(.languageSettingsSectionSubtitle)
                ) {
                    VStack(spacing: 0) {
                        ForEach(AppLanguagePreference.allCases) { preference in
                            optionRow(for: preference)

                            if preference != AppLanguagePreference.allCases.last {
                                Divider()
                                    .background(AppTheme.Colors.divider)
                            }
                        }
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle(localizationStore.string(.settingsLanguageTitle))
    }

    private func optionRow(for preference: AppLanguagePreference) -> some View {
        let isSelected = localizationStore.languagePreference == preference
        let title = optionTitle(for: preference)
        let subtitle = optionSubtitle(for: preference)

        return Button {
            localizationStore.setLanguagePreference(preference)
        } label: {
            HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
                Image(systemName: preference == .system ? "iphone" : "textformat")
                    .font(AppTheme.Typography.sectionTitle)
                    .foregroundColor(AppTheme.Colors.darkGold)
                    .frame(width: 24)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(title)
                        .font(AppTheme.Typography.body.weight(.semibold))
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text(subtitle)
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.cinnabar)
                        .accessibilityHidden(true)
                }
            }
            .padding(.vertical, AppTheme.Spacing.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityHint(subtitle)
        .accessibilityValue(isSelected ? Text(localizationStore.string(.languageSettingsSelectedAccessibilityValue)) : Text(""))
    }

    private func optionTitle(for preference: AppLanguagePreference) -> String {
        localizationStore.string(preference.displayNameID)
    }

    private func optionSubtitle(for preference: AppLanguagePreference) -> String {
        switch preference {
        case .system:
            return localizationStore.string(.languageSettingsSystemSubtitle)
        case .simplifiedChinese, .traditionalChinese, .english:
            let languageName = localizationStore.string(preference.resolvedLanguage().displayNameID)
            return localizationStore.string(
                .languageSettingsManualSubtitle,
                replacements: ["language": languageName]
            )
        }
    }
}

#Preview {
    NavigationStack {
        LanguageSettingsView()
            .environmentObject(LocalizationStore())
    }
}
