//
//  AppPrimaryButton.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI

struct AppPrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Typography.sectionTitle)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.Spacing.md)
                .background(AppTheme.Colors.cinnabar)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.button, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
