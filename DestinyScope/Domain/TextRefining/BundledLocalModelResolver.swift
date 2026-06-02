//
//  BundledLocalModelResolver.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import Foundation

struct BundledLocalModelResolver {
    private let resolver: LocalModelFileResolver

    init(resolver: LocalModelFileResolver = LocalModelFileResolver()) {
        self.resolver = resolver
    }

    func resolveModelFileStatus() -> LocalModelFileStatus {
        resolver.resolveModelFileStatus()
    }

    func candidateStatuses() -> [LocalModelFileStatus] {
        resolver.candidateStatuses()
    }
}
