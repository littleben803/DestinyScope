//
//  LifeWeightReadingSectionView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/3.
//

import SwiftUI

struct LifeWeightReadingSectionRow: Identifiable, Equatable {
    let id: String
    let title: String
    let systemImageName: String
    let body: String
}

struct LifeWeightReadingSectionView: View {
    let rows: [LifeWeightReadingSectionRow]

    var body: some View {
        if !rows.isEmpty {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                ForEach(rows) { row in
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                        Label {
                            Text(row.title)
                        } icon: {
                            Image(systemName: row.systemImageName)
                        }
                        .font(AppTheme.Typography.secondary.weight(.semibold))
                        .foregroundColor(AppTheme.Colors.darkGold)

                        Text(row.body)
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
