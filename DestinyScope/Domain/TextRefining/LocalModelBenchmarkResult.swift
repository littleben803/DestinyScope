//
//  LocalModelBenchmarkResult.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/28.
//

import Foundation

struct LocalModelBenchmarkResult: Codable, Identifiable, Equatable {
    let id: UUID
    let createdAt: Date
    let deviceName: String
    let systemVersion: String
    let modelFileName: String
    let modelFileSize: UInt64?
    let testName: String
    let loadTime: TimeInterval
    let generationTime: TimeInterval
    let totalTime: TimeInterval
    let outputCharacterCount: Int
    let didFallback: Bool
    let errorMessage: String?
    let notes: String
    let outputPreview: String

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        deviceName: String,
        systemVersion: String,
        modelFileName: String,
        modelFileSize: UInt64?,
        testName: String,
        loadTime: TimeInterval,
        generationTime: TimeInterval,
        totalTime: TimeInterval,
        outputCharacterCount: Int,
        didFallback: Bool,
        errorMessage: String?,
        notes: String,
        outputPreview: String
    ) {
        self.id = id
        self.createdAt = createdAt
        self.deviceName = deviceName
        self.systemVersion = systemVersion
        self.modelFileName = modelFileName
        self.modelFileSize = modelFileSize
        self.testName = testName
        self.loadTime = loadTime
        self.generationTime = generationTime
        self.totalTime = totalTime
        self.outputCharacterCount = outputCharacterCount
        self.didFallback = didFallback
        self.errorMessage = errorMessage
        self.notes = notes
        self.outputPreview = outputPreview
    }
}

