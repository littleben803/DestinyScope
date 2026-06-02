//
//  DestinyScopeApp.swift
//  DestinyScope
//
//  Created by phoenix on 2025/4/8.
//

import SwiftUI

@main
struct DestinyScopeApp: App {
    // 初始化数据
    @StateObject private var dataManager = DataManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainContentView()
                .environmentObject(dataManager)
                .task {
                    await scheduleStartupTasks()
                }
        }
    }

    private func scheduleStartupTasks() async {
        await LocalModelLoadingManager.shared.markScheduledIfNeeded()
        await StartupTaskScheduler.shared.schedule(id: "local-model-preload", priority: .low) {
            await LocalModelLoadingManager.shared.loadIfNeeded()
        }
    }
}
