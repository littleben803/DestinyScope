//
//  LocalModelLoadingManager.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import Foundation

enum LocalModelLoadingState: Equatable, Sendable {
    case idle
    case scheduled
    case loading
    case loaded(modelPath: String, loadTime: TimeInterval)
    case failed(reason: String)

    var isLoaded: Bool {
        if case .loaded = self {
            return true
        }

        return false
    }

    var fallbackReason: String {
        switch self {
        case .idle:
            return "本地模型尚未开始加载。"
        case .scheduled:
            return "本地模型正在等待后台加载。"
        case .loading:
            return "本地模型正在后台加载。"
        case .loaded:
            return "本地模型已加载。"
        case .failed(let reason):
            return reason
        }
    }
}

actor LocalModelLoadingManager {
    static let shared = LocalModelLoadingManager()

    private let config: LocalModelDebugConfig
    private let modelResolver: BundledLocalModelResolver
    private var state: LocalModelLoadingState = .idle
    private var session: LlamaCppSession?

    init(
        config: LocalModelDebugConfig = .current,
        modelResolver: BundledLocalModelResolver = BundledLocalModelResolver()
    ) {
        self.config = config
        self.modelResolver = modelResolver
    }

    func currentState() -> LocalModelLoadingState {
        state
    }

    func markScheduledIfNeeded() {
        guard case .idle = state else {
            return
        }

        state = .scheduled
    }

    func loadIfNeeded() async {
        switch state {
        case .loaded, .loading:
            return
        case .idle, .scheduled, .failed:
            break
        }

        let modelStatus = modelResolver.resolveModelFileStatus()
        guard let modelPath = modelStatus.resolvedURL?.path, modelStatus.isUsable else {
            let candidates = modelResolver.candidateStatuses().compactMap { $0.resolvedURL?.path }
            let fallbackCandidates = candidates.isEmpty ? config.modelPathCandidates.map(config.expandedPath) : candidates
            state = .failed(reason: LlamaCppSessionError.modelFileMissing(fallbackCandidates).localizedDescription)
            return
        }

        state = .loading

        do {
            let newSession = LlamaCppSession()
            let loadTime = try newSession.loadModel(path: modelPath)
            session = newSession
            state = .loaded(modelPath: modelPath, loadTime: loadTime)
        } catch {
            session?.unload()
            session = nil
            state = .failed(reason: error.localizedDescription)
        }
    }

    func generate(prompt: String, maxTokens: Int) async throws -> LlamaCppGenerationResult {
        guard case .loaded(let modelPath, let loadTime) = state, let session else {
            throw LocalModelRuntimeError.modelUnavailable
        }

        let generated = try session.generate(prompt: prompt, maxTokens: maxTokens)
        return LlamaCppGenerationResult(
            modelInfo: LlamaCppModelInfo(path: modelPath),
            output: generated.text,
            loadTime: loadTime,
            generateTime: generated.duration
        )
    }

    func unload() {
        session?.unload()
        session = nil
        state = .idle
    }
}
