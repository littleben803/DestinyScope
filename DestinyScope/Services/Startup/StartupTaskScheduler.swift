//
//  StartupTaskScheduler.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import Foundation

enum StartupTaskPriority: Sendable {
    case high
    case medium
    case low

    var taskPriority: TaskPriority {
        switch self {
        case .high:
            return .userInitiated
        case .medium:
            return .utility
        case .low:
            return .background
        }
    }

    var idleDelayNanoseconds: UInt64 {
        switch self {
        case .high:
            return 300_000_000
        case .medium:
            return 1_000_000_000
        case .low:
            return 2_000_000_000
        }
    }
}

actor StartupTaskScheduler {
    static let shared = StartupTaskScheduler()

    private var scheduledTaskIDs = Set<String>()

    func schedule(
        id: String,
        priority: StartupTaskPriority = .low,
        operation: @escaping @Sendable () async -> Void
    ) {
        guard !scheduledTaskIDs.contains(id) else {
            return
        }

        scheduledTaskIDs.insert(id)

        Task.detached(priority: priority.taskPriority) {
            try? await Task.sleep(nanoseconds: priority.idleDelayNanoseconds)

            guard !Task.isCancelled else {
                return
            }

            await operation()
        }
    }
}
