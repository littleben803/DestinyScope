//
//  HistoryLocalNoticeView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import SwiftUI

struct HistoryLocalNoticeView: View {
    var body: some View {
        AppCard {
            AppSectionHeader(title: "本地保存")

            Text("当前版本的历史记录仅保存在本设备。不会上传、不会同步，也不会用于在线服务。删除后无法恢复。")
                .font(AppTheme.Typography.secondary)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
