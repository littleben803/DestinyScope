//
//  LocalDataManagementService.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import Foundation

struct LocalDataManagementService {
    private let historyRecordStore: HistoryRecordStore
    private let historyRecordUserStateStore: HistoryRecordUserStateStore
    private let savedBirthProfileStore: SavedBirthProfileStore
    private let knowledgeLibraryStateStore: KnowledgeLibraryStateStore
    private let onboardingStateStore: OnboardingStateStore

    init(
        historyRecordStore: HistoryRecordStore = HistoryRecordStore(),
        historyRecordUserStateStore: HistoryRecordUserStateStore = HistoryRecordUserStateStore(),
        savedBirthProfileStore: SavedBirthProfileStore = SavedBirthProfileStore(),
        knowledgeLibraryStateStore: KnowledgeLibraryStateStore = KnowledgeLibraryStateStore(),
        onboardingStateStore: OnboardingStateStore = OnboardingStateStore()
    ) {
        self.historyRecordStore = historyRecordStore
        self.historyRecordUserStateStore = historyRecordUserStateStore
        self.savedBirthProfileStore = savedBirthProfileStore
        self.knowledgeLibraryStateStore = knowledgeLibraryStateStore
        self.onboardingStateStore = onboardingStateStore
    }

    func loadSummary() -> LocalDataSummary {
        let historyRecords = (try? historyRecordStore.load()) ?? []
        let historyUserState = (try? historyRecordUserStateStore.load()) ?? .empty
        let savedProfiles = (try? savedBirthProfileStore.load()) ?? []
        let knowledgeState = (try? knowledgeLibraryStateStore.load()) ?? .empty

        return LocalDataSummary(
            historyRecordCount: historyRecords.count,
            savedBirthProfileCount: savedProfiles.count,
            favoriteKnowledgeCount: knowledgeState.favoriteArticleIDs.count,
            recentKnowledgeCount: knowledgeState.recentReads.count,
            favoriteHistoryCount: historyUserState.favoriteRecordIDs.count,
            pinnedHistoryCount: historyUserState.pinnedRecordIDs.count,
            hasCompletedOnboarding: onboardingStateStore.hasCompletedOnboarding
        )
    }

    func clearHistory() throws {
        try historyRecordStore.deleteAll()
        try historyRecordUserStateStore.clearAll()
    }

    func clearHistoryUserState() throws {
        try historyRecordUserStateStore.clearAll()
    }

    func clearSavedBirthProfiles() throws {
        try savedBirthProfileStore.deleteAll()
    }

    func clearKnowledgeFavorites() throws {
        try knowledgeLibraryStateStore.clearFavorites()
    }

    func clearKnowledgeRecentReads() throws {
        try knowledgeLibraryStateStore.clearRecentReads()
    }

    func resetOnboarding() throws {
        onboardingStateStore.reset()
    }

    func clearAllUserLocalData() throws {
        try clearHistory()
        try clearSavedBirthProfiles()
        try clearKnowledgeFavorites()
        try clearKnowledgeRecentReads()
        try resetOnboarding()
    }
}
