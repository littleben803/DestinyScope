//
//  LocalModelDebugConfig.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/27.
//

import Foundation

struct LocalModelDebugConfig: Equatable {
    let isDebugFeatureEnabled: Bool
    let expectedModelFileName: String
    let modelDirectoryDescription: String

    static var current: LocalModelDebugConfig {
        #if DEBUG
        let isEnabled = true
        #else
        let isEnabled = false
        #endif

        return LocalModelDebugConfig(
            isDebugFeatureEnabled: isEnabled,
            expectedModelFileName: "qwen2_5_0_5b_instruct_q4.gguf",
            modelDirectoryDescription: "开发者本地 Debug 测试目录；模型文件不得提交仓库或进入 Release 默认路径。"
        )
    }
}
