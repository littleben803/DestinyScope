//
//  DestinyInterpretationModels.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/8.
//

import Foundation

struct DestinyContext: Equatable {
    let gender: BirthGender?
    let totalQian: Int?
    let boneWeightTitle: String?
    let baziPillars: [String]
    let wuxingCounts: [String: Int]
    let dominantElements: [String]
    let weakElements: [String]
    let userQuestion: String?

    init(
        gender: BirthGender? = nil,
        totalQian: Int? = nil,
        boneWeightTitle: String? = nil,
        baziPillars: [String] = [],
        wuxingCounts: [String: Int] = [:],
        dominantElements: [String] = [],
        weakElements: [String] = [],
        userQuestion: String? = nil
    ) {
        self.gender = gender
        self.totalQian = totalQian
        self.boneWeightTitle = boneWeightTitle
        self.baziPillars = baziPillars
        self.wuxingCounts = wuxingCounts
        self.dominantElements = dominantElements
        self.weakElements = weakElements
        self.userQuestion = userQuestion
    }

    init(
        result: LifeWeightResult,
        bazi: BirthEightCharacters? = nil,
        wuxingCounts: [String: Int] = [:],
        dominantElements: [String] = [],
        weakElements: [String] = [],
        userQuestion: String? = nil
    ) {
        let pillars = bazi.map {
            [$0.yearPillar, $0.monthPillar, $0.dayPillar, $0.hourPillar]
        } ?? []

        self.init(
            gender: result.birthProfile.gender,
            totalQian: Int((result.totalWeight * 10).rounded()),
            boneWeightTitle: result.title,
            baziPillars: pillars,
            wuxingCounts: wuxingCounts,
            dominantElements: dominantElements,
            weakElements: weakElements,
            userQuestion: userQuestion
        )
    }

    var promptSummary: String {
        var lines: [String] = []

        if let gender {
            lines.append("性别：\(gender.displayName)")
        }

        if let totalQian {
            lines.append("称骨总钱数：\(totalQian)")
        }

        if let boneWeightTitle, !boneWeightTitle.isEmpty {
            lines.append("命格标题：\(boneWeightTitle)")
        }

        if !baziPillars.isEmpty {
            lines.append("四柱：\(baziPillars.joined(separator: " "))")
        }

        if !wuxingCounts.isEmpty {
            let countText = wuxingCounts
                .sorted { $0.key < $1.key }
                .map { "\($0.key)\($0.value)" }
                .joined(separator: "、")
            lines.append("五行计数：\(countText)")
        }

        if !dominantElements.isEmpty {
            lines.append("偏旺元素：\(dominantElements.joined(separator: "、"))")
        }

        if !weakElements.isEmpty {
            lines.append("偏弱元素：\(weakElements.joined(separator: "、"))")
        }

        if let userQuestion, !userQuestion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            lines.append("用户问题：\(userQuestion.trimmingCharacters(in: .whitespacesAndNewlines))")
        }

        return lines.isEmpty ? "无额外命盘上下文。" : lines.joined(separator: "\n")
    }
}

struct HomeDestinyDetailResult: Codable, Equatable {
    var overview: String
    var wuxingQi: String
    var personality: String
    var career: String
    var suggestion: String
    var boundary: String
    var isFallback = false
    var fallbackReason: String?
    var chunkIDs: [String] = []

    init(
        overview: String,
        wuxingQi: String,
        personality: String,
        career: String,
        suggestion: String,
        boundary: String,
        isFallback: Bool = false,
        fallbackReason: String? = nil,
        chunkIDs: [String] = []
    ) {
        self.overview = overview
        self.wuxingQi = wuxingQi
        self.personality = personality
        self.career = career
        self.suggestion = suggestion
        self.boundary = boundary
        self.isFallback = isFallback
        self.fallbackReason = fallbackReason
        self.chunkIDs = chunkIDs
    }

    enum CodingKeys: String, CodingKey {
        case overview
        case wuxingQi
        case personality
        case career
        case suggestion
        case boundary
    }
}

struct WuxingBalanceInterpretationResult: Codable, Equatable {
    var summary: String
    var elementInterpretation: String
    var personalityTendency: String
    var balanceSuggestion: String
    var boundary: String
    var isFallback = false
    var fallbackReason: String?
    var chunkIDs: [String] = []

    init(
        summary: String,
        elementInterpretation: String,
        personalityTendency: String,
        balanceSuggestion: String,
        boundary: String,
        isFallback: Bool = false,
        fallbackReason: String? = nil,
        chunkIDs: [String] = []
    ) {
        self.summary = summary
        self.elementInterpretation = elementInterpretation
        self.personalityTendency = personalityTendency
        self.balanceSuggestion = balanceSuggestion
        self.boundary = boundary
        self.isFallback = isFallback
        self.fallbackReason = fallbackReason
        self.chunkIDs = chunkIDs
    }

    enum CodingKeys: String, CodingKey {
        case summary
        case elementInterpretation
        case personalityTendency
        case balanceSuggestion
        case boundary
    }
}

struct DailyQiInterpretationResult: Codable, Equatable {
    var theme: String
    var summary: String
    var suitable: [String]
    var mindful: [String]
    var shortAdvice: String
    var boundary: String
    var isFallback = false
    var fallbackReason: String?
    var chunkIDs: [String] = []

    init(
        theme: String,
        summary: String,
        suitable: [String],
        mindful: [String],
        shortAdvice: String,
        boundary: String,
        isFallback: Bool = false,
        fallbackReason: String? = nil,
        chunkIDs: [String] = []
    ) {
        self.theme = theme
        self.summary = summary
        self.suitable = suitable
        self.mindful = mindful
        self.shortAdvice = shortAdvice
        self.boundary = boundary
        self.isFallback = isFallback
        self.fallbackReason = fallbackReason
        self.chunkIDs = chunkIDs
    }

    enum CodingKeys: String, CodingKey {
        case theme
        case summary
        case suitable
        case mindful
        case shortAdvice
        case boundary
    }
}

struct DestinyQAResult: Codable, Equatable {
    var answer: String
    var relatedTags: [String]
    var suggestedQuestions: [String]
    var boundary: String
    var isFallback = false
    var fallbackReason: String?
    var chunkIDs: [String] = []

    init(
        answer: String,
        relatedTags: [String],
        suggestedQuestions: [String],
        boundary: String,
        isFallback: Bool = false,
        fallbackReason: String? = nil,
        chunkIDs: [String] = []
    ) {
        self.answer = answer
        self.relatedTags = relatedTags
        self.suggestedQuestions = suggestedQuestions
        self.boundary = boundary
        self.isFallback = isFallback
        self.fallbackReason = fallbackReason
        self.chunkIDs = chunkIDs
    }

    enum CodingKeys: String, CodingKey {
        case answer
        case relatedTags
        case suggestedQuestions
        case boundary
    }
}

struct DestinyModelGeneration: Equatable {
    let text: String
    let duration: TimeInterval
    let engine: String
}

protocol DestinyModelGenerating {
    func generate(prompt: String, maxTokens: Int) async throws -> DestinyModelGeneration
}

struct LocalDestinyModelGenerator: DestinyModelGenerating {
    func generate(prompt: String, maxTokens: Int) async throws -> DestinyModelGeneration {
        let result = try await LocalModelLoadingManager.shared.generate(prompt: prompt, maxTokens: maxTokens)
        return DestinyModelGeneration(
            text: result.output,
            duration: result.generateTime,
            engine: result.modelInfo.fileName
        )
    }
}

private extension BirthGender {
    var displayName: String {
        switch self {
        case .male:
            return "男"
        case .female:
            return "女"
        }
    }
}
