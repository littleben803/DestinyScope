//
//  LocalDataManagementService.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import Foundation

struct LocalDataManagementService {
    private let historyRecordStore: HistoryRecordStore
    private let savedBirthProfileStore: SavedBirthProfileStore
    private let knowledgeLibraryStateStore: KnowledgeLibraryStateStore
    private let onboardingStateStore: OnboardingStateStore

    init(
        historyRecordStore: HistoryRecordStore = HistoryRecordStore(),
        savedBirthProfileStore: SavedBirthProfileStore = SavedBirthProfileStore(),
        knowledgeLibraryStateStore: KnowledgeLibraryStateStore = KnowledgeLibraryStateStore(),
        onboardingStateStore: OnboardingStateStore = OnboardingStateStore()
    ) {
        self.historyRecordStore = historyRecordStore
        self.savedBirthProfileStore = savedBirthProfileStore
        self.knowledgeLibraryStateStore = knowledgeLibraryStateStore
        self.onboardingStateStore = onboardingStateStore
    }

    func loadSummary() -> LocalDataSummary {
        let historyRecords = (try? historyRecordStore.load()) ?? []
        let savedProfiles = (try? savedBirthProfileStore.load()) ?? []
        let knowledgeState = (try? knowledgeLibraryStateStore.load()) ?? .empty

        return LocalDataSummary(
            historyRecordCount: historyRecords.count,
            savedBirthProfileCount: savedProfiles.count,
            favoriteKnowledgeCount: knowledgeState.favoriteArticleIDs.count,
            recentKnowledgeCount: knowledgeState.recentReads.count,
            hasCompletedOnboarding: onboardingStateStore.hasCompletedOnboarding
        )
    }

    func clearHistory() throws {
        try historyRecordStore.deleteAll()
        try deleteLegacyHistoryMetadataIfNeeded()
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

    private func deleteLegacyHistoryMetadataIfNeeded() throws {
        let fileManager = FileManager.default
        let directory = try fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent("DestinyScope", isDirectory: true)
        let url = directory.appendingPathComponent("history_record_user_state.json")

        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }
    }
}
