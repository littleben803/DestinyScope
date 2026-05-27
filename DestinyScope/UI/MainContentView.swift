//
//  MainContentView.swift
//  DestinyScope
//
//  Created by phoenix on 2025/4/8.
//

import SwiftUI

struct MainContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("首页", systemImage: "house")
            }

            NavigationStack {
                KnowledgeListView()
            }
            .tabItem {
                Label("知识库", systemImage: "book")
            }

            NavigationStack {
                HistoryListView()
            }
            .tabItem {
                Label("历史", systemImage: "clock")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("关于", systemImage: "info.circle")
            }
        }
        .tint(AppTheme.Colors.cinnabar)
    }
}

#Preview {
    MainContentView()
        .environmentObject(DataManager.shared)
}
