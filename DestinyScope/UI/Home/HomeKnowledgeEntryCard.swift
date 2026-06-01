//
//  HomeKnowledgeEntryCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import SwiftUI

struct HomeKnowledgeEntryCard: View {
    var body: some View {
        AppCard {
            AppSectionHeader(title: "知识学习")

            Text("想了解称骨、时辰、生肖、五行等基础内容，可以在知识库阅读入门文章。")
                .font(AppTheme.Typography.footnote)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
