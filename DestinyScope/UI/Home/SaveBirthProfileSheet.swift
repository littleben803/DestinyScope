//
//  SaveBirthProfileSheet.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct SaveBirthProfileSheet: View {
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
                            AppSectionHeader(title: "保存常用出生资料")

                            Text("为当前出生日期和时辰设置一个本地显示名，方便下次快速填写。")
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.primaryText)
                                .fixedSize(horizontal: false, vertical: true)

                            Text("资料仅保存在本机，不会上传或同步。")
                                .font(AppTheme.Typography.footnote)
                                .foregroundColor(AppTheme.Colors.secondaryText)

                            TextField("例如：本人、家人、朋友", text: $displayName)
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
                                Text("出生日期：\(Self.dateFormatter.string(from: birthDate))")
                                Text(String(format: "出生时辰：%02d 时", hour))
                            }
                            .font(AppTheme.Typography.secondary)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                        }

                        AppPrimaryButton(title: "保存") {
                            onSave(displayName)
                            dismiss()
                        }
                        .accessibilityLabel("保存常用出生资料")
                        .accessibilityHint("将当前出生日期和时辰保存到本机。")
                    }
                    .padding(AppTheme.Spacing.lg)
                }
            }
            .navigationTitle("保存资料")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                    .accessibilityLabel("取消保存")
                    .accessibilityHint("关闭保存常用出生资料页面。")
                }
            }
        }
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月d日"
        return formatter
    }()
}
