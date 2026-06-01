//
//  MainContentView.swift
//  DestinyScope
//
//  Created by phoenix on 2025/4/8.
//

import SwiftUI

struct MainContentView: View {
    private let onboardingStore: OnboardingStateStore

    @State private var isOnboardingPresented: Bool

    init(onboardingStore: OnboardingStateStore = OnboardingStateStore()) {
        self.onboardingStore = onboardingStore
        _isOnboardingPresented = State(initialValue: !onboardingStore.hasCompletedOnboarding)
    }

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
        .fullScreenCover(isPresented: $isOnboardingPresented) {
            OnboardingView {
                onboardingStore.markCompleted()
                isOnboardingPresented = false
            }
        }
    }
}

#Preview {
    MainContentView()
        .environmentObject(DataManager.shared)
}
