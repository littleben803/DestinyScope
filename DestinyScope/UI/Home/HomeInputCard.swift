//
//  HomeInputCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct HomeInputCard: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    @Binding var birthDate: Date
    @Binding var selectedHour: Int
    @Binding var selectedGender: BirthGender

    let hours: [Int]
    let errorMessage: String?
    let onSaveCurrent: () -> Void
    let onCalculate: () -> Void

    var body: some View {
        AppCard {
            AppSectionHeader(title: localizationStore.string(.homeInputTitle))

            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                DatePicker(selection: $birthDate, displayedComponents: [.date]) {
                    Label(localizationStore.string(.homeBirthDateTitle), systemImage: "calendar")
                }
                    .environment(\.locale, localizationStore.locale)
                    .foregroundColor(AppTheme.Colors.primaryText)

                Divider()
                    .background(AppTheme.Colors.divider)

                HStack(spacing: AppTheme.Spacing.md) {
                    Label(localizationStore.string(.homeBirthHourTitle), systemImage: "clock")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Spacer()

                    Picker(localizationStore.string(.homeBirthHourTitle), selection: $selectedHour) {
                        ForEach(hours, id: \.self) { hour in
                            Text(hourText(for: hour)).tag(hour)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .foregroundColor(AppTheme.Colors.primaryText)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(localizationStore.string(.homeBirthHourTitle))
                .accessibilityValue(Text(hourText(for: selectedHour)))

                Divider()
                    .background(AppTheme.Colors.divider)

                HStack(spacing: AppTheme.Spacing.md) {
                    Label(localizationStore.string(.homeGenderTitle), systemImage: "person.2")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Spacer()

                    BirthGenderSegmentedControl(selection: $selectedGender)
                        .environmentObject(localizationStore)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(localizationStore.string(.homeGenderTitle))
                .accessibilityValue(Text(genderText(for: selectedGender)))

                HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "lock.shield")
                        .font(.footnote)
                        .foregroundColor(AppTheme.Colors.cinnabar)
                        .accessibilityHidden(true)

                    Text(localizationStore.string(.homeInputPrivacy))
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            AppPrimaryButton(title: localizationStore.string(.homeInputCalculate), action: onCalculate)
                .accessibilityLabel(localizationStore.string(.homeInputCalculateAccessibilityLabel))
                .accessibilityHint(localizationStore.string(.homeInputCalculateAccessibilityHint))

            Button(action: onSaveCurrent) {
                HStack {
                    Image(systemName: "tray.and.arrow.down")
                    Text(localizationStore.string(.homeInputSaveProfile))
                }
                .font(AppTheme.Typography.body.weight(.semibold))
                .foregroundColor(AppTheme.Colors.cinnabar)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.Spacing.md)
                .background(AppTheme.Colors.secondaryBackground.opacity(0.45))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(localizationStore.string(.homeInputSaveProfileAccessibilityLabel))
            .accessibilityHint(localizationStore.string(.homeInputSaveProfileAccessibilityHint))

            if let errorMessage {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(localizationStore.string(.homeInputPromptTitle))
                        .font(AppTheme.Typography.footnote.weight(.semibold))
                        .foregroundColor(AppTheme.Colors.cinnabar)

                    Text(errorMessage)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(AppTheme.Spacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.Colors.paper)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous))
            }
        }
    }

    private func hourText(for hour: Int) -> String {
        localizationStore.string(
            .homeHourValue,
            replacements: ["hour": String(format: "%02d", hour)]
        )
    }

    private func genderText(for gender: BirthGender) -> String {
        switch gender {
        case .male:
            return localizationStore.string(.genderMale)
        case .female:
            return localizationStore.string(.genderFemale)
        }
    }
}

private struct BirthGenderSegmentedControl: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    @Binding var selection: BirthGender

    var body: some View {
        HStack(spacing: 0) {
            ForEach(BirthGender.allCases) { gender in
                Button {
                    selection = gender
                } label: {
                    HStack(spacing: AppTheme.Spacing.xs) {
                        Image(systemName: systemImageName(for: gender))
                            .font(AppTheme.Typography.footnote.weight(.semibold))
                            .accessibilityHidden(true)

                        Text(title(for: gender))
                            .font(AppTheme.Typography.footnote.weight(.semibold))
                    }
                    .foregroundColor(selection == gender ? .white : AppTheme.Colors.primaryText)
                    .frame(minWidth: 64)
                    .padding(.vertical, AppTheme.Spacing.xs)
                    .padding(.horizontal, AppTheme.Spacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.button, style: .continuous)
                            .fill(selection == gender ? AppTheme.Colors.cinnabar : Color.clear)
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(title(for: gender))
                .accessibilityAddTraits(selection == gender ? .isSelected : [])
            }
        }
        .padding(3)
        .background(AppTheme.Colors.paper)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.button, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radius.button, style: .continuous)
                .stroke(AppTheme.Colors.divider.opacity(0.65), lineWidth: 1)
        )
    }

    private func title(for gender: BirthGender) -> String {
        switch gender {
        case .male:
            return localizationStore.string(.genderMale)
        case .female:
            return localizationStore.string(.genderFemale)
        }
    }

    private func systemImageName(for gender: BirthGender) -> String {
        switch gender {
        case .male:
            return "figure.stand"
        case .female:
            return "figure.stand.dress"
        }
    }
}
