//
//  HistoryEmptyStateView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct HistoryEmptyStateView: View {
    var body: some View {
        AppCard {
            AppSectionHeader(title: "暂无历史记录")

            Text("完成一次查询后，结果会以轻量记录保存在本机，方便以后回看。")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            Text("历史记录不会上传或同步。")
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
    }
}
