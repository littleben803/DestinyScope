//
//  MainContentView.swift
//  DestinyScope
//
//  Created by phoenix on 2025/4/8.
//

import SwiftUI

struct MainContentView: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    private enum MainTab: Hashable {
        case home
        case knowledge
        case history
        case settings
    }

    private let onboardingStore: OnboardingStateStore

    @StateObject private var homeInputDraftStore = HomeInputDraftStore()
    @State private var isOnboardingPresented: Bool
    @State private var selectedTab: MainTab = .home

    init(onboardingStore: OnboardingStateStore = OnboardingStateStore()) {
        self.onboardingStore = onboardingStore
        _isOnboardingPresented = State(initialValue: !onboardingStore.hasCompletedOnboarding)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label(localizationStore.string(.tabHome), systemImage: "house")
            }
            .tag(MainTab.home)

            NavigationStack {
                KnowledgeListView()
            }
            .tabItem {
                Label(localizationStore.string(.tabKnowledge), systemImage: "book")
            }
            .tag(MainTab.knowledge)

            NavigationStack {
                HistoryListView {
                    selectedTab = .home
                }
            }
            .tabItem {
                Label(localizationStore.string(.tabHistory), systemImage: "clock")
            }
            .tag(MainTab.history)

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label(localizationStore.string(.tabSettings), systemImage: "info.circle")
            }
            .tag(MainTab.settings)
        }
        .tint(AppTheme.Colors.cinnabar)
        .environmentObject(homeInputDraftStore)
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
        .environmentObject(LocalizationStore())
}
