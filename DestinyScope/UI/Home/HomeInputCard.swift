//
//  HomeInputCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct HomeInputCard: View {
    @Binding var birthDate: Date
    @Binding var selectedHour: Int

    let hours: [Int]
    let errorMessage: String?
    let onSaveCurrent: () -> Void
    let onCalculate: () -> Void

    var body: some View {
        AppCard {
            AppSectionHeader(title: "开始查询")

            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                DatePicker("出生日期", selection: $birthDate, displayedComponents: [.date])
                    .environment(\.locale, Locale(identifier: "zh_CN"))
                    .foregroundColor(AppTheme.Colors.primaryText)

                Divider()
                    .background(AppTheme.Colors.divider)

                Picker("出生时辰", selection: $selectedHour) {
                    ForEach(hours, id: \.self) { hour in
                        Text(String(format: "%02d 时", hour)).tag(hour)
                    }
                }
                .pickerStyle(.menu)
                .foregroundColor(AppTheme.Colors.primaryText)

                HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "lock.shield")
                        .font(.footnote)
                        .foregroundColor(AppTheme.Colors.cinnabar)
                        .accessibilityHidden(true)

                    Text("出生日期和时辰仅用于本机计算，不需要账号，也不会上传。")
                        .font(AppTheme.Typography.footnote)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            AppPrimaryButton(title: "查询", action: onCalculate)
                .accessibilityLabel("查询称骨结果")
                .accessibilityHint("根据当前出生日期和时辰在本机生成结果。")

            Button(action: onSaveCurrent) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("保存为常用资料")
                }
                .font(AppTheme.Typography.body.weight(.semibold))
                .foregroundColor(AppTheme.Colors.cinnabar)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.Spacing.md)
                .background(AppTheme.Colors.secondaryBackground.opacity(0.45))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("保存当前出生资料")
            .accessibilityHint("输入本地显示名后，将当前出生日期和时辰保存到本机。")

            if let errorMessage {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("提示")
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
}
