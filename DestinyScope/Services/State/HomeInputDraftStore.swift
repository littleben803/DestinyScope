//
//  HomeInputDraftStore.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Combine
import Foundation

final class HomeInputDraftStore: ObservableObject {
    @Published private(set) var pendingDraft: HomeInputDraft?

    func setDraft(birthDate: Date, hour: Int, source: String) {
        pendingDraft = HomeInputDraft(
            id: UUID(),
            birthDate: birthDate,
            hour: hour,
            source: source,
            createdAt: Date()
        )
    }

    func consumeDraft() -> HomeInputDraft? {
        let draft = pendingDraft
        pendingDraft = nil
        return draft
    }

    func clear() {
        pendingDraft = nil
    }
}
