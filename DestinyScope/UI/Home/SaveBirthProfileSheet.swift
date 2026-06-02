//
//  SaveBirthProfileSheet.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct SaveBirthProfileSheet: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    let birthDate: Date
    let hour: Int
    let onSave: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var displayName = ""

    var body: some View {
        NavigationStack {
            AppBackground {
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.md) {
                        AppCard {
                            AppSectionHeader(title: localizationStore.string(.homeSaveSheetTitle))

                            Text(localizationStore.string(.homeSaveSheetBody))
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.primaryText)
                                .fixedSize(horizontal: false, vertical: true)

                            Text(localizationStore.string(.homeSaveSheetPrivacy))
                                .font(AppTheme.Typography.footnote)
                                .foregroundColor(AppTheme.Colors.secondaryText)

                            TextField(localizationStore.string(.homeSaveSheetPlaceholder), text: $displayName)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .padding(AppTheme.Spacing.md)
                                .background(AppTheme.Colors.paper)
                                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous)
                                        .stroke(AppTheme.Colors.divider.opacity(0.55), lineWidth: 1)
                                )

                            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                                Text(
                                    localizationStore.string(
                                        .homeSaveSheetBirthDate,
                                        replacements: ["date": birthDateText]
                                    )
                                )
                                Text(
                                    localizationStore.string(
                                        .homeSaveSheetBirthHour,
                                        replacements: ["hour": hourText]
                                    )
                                )
                            }
                            .font(AppTheme.Typography.secondary)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                        }

                        AppPrimaryButton(title: localizationStore.string(.homeSaveSheetSave)) {
                            onSave(displayName)
                            dismiss()
                        }
                        .accessibilityLabel(localizationStore.string(.homeSaveSheetSaveAccessibilityLabel))
                        .accessibilityHint(localizationStore.string(.homeSaveSheetSaveAccessibilityHint))
                    }
                    .padding(AppTheme.Spacing.lg)
                }
            }
            .navigationTitle(localizationStore.string(.homeSaveSheetNavigationTitle))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(localizationStore.string(.homeSaveSheetCancel)) {
                        dismiss()
                    }
                    .accessibilityLabel(localizationStore.string(.homeSaveSheetCancelAccessibilityLabel))
                    .accessibilityHint(localizationStore.string(.homeSaveSheetCancelAccessibilityHint))
                }
            }
        }
    }

    private var birthDateText: String {
        dateFormatter.string(from: birthDate)
    }

    private var hourText: String {
        localizationStore.string(
            .homeHourValue,
            replacements: ["hour": String(format: "%02d", hour)]
        )
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = localizationStore.locale
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}
