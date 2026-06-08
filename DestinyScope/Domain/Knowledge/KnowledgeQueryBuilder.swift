//
//  KnowledgeQueryBuilder.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/8.
//

import Foundation

struct KnowledgeQueryBuilder {
    func buildHomeDestinyDetailQuery(_ context: DestinyContext) -> [String] {
        let baseKeywords: [String?] = [
            "称骨",
            "命格",
            "五行",
            "阴阳",
            "天干地支",
            "传统文化",
            context.boneWeightTitle,
            context.totalQian.map { "\($0)钱" }
        ]
        return uniqueKeywords(
            baseKeywords
                + elementKeywords(from: context).map(Optional.some)
                + baziKeywords(from: context).map(Optional.some)
        )
    }

    func buildWuxingBalanceQuery(_ context: DestinyContext) -> [String] {
        uniqueKeywords([
            "五行",
            "五行平衡",
            "相生相克",
            "金木水火土",
            "阴阳平衡",
            "偏旺",
            "偏弱"
        ] + elementKeywords(from: context))
    }

    func buildDailyQiQuery(_ context: DestinyContext, dailyStemBranch: String) -> [String] {
        uniqueKeywords([
            "今日",
            "天干地支",
            "阴阳",
            "五行",
            "时令",
            "气象",
            dailyStemBranch
        ] + baziKeywords(from: context) + elementKeywords(from: context))
    }

    func buildQAQuery(_ context: DestinyContext, question: String) -> [String] {
        let baseKeywords: [String?] = [
            "命格",
            "五行",
            "阴阳",
            "八卦",
            "天干地支",
            context.boneWeightTitle
        ]
        return uniqueKeywords(
            tokenize(question).map(Optional.some)
                + baseKeywords
                + baziKeywords(from: context).map(Optional.some)
                + elementKeywords(from: context).map(Optional.some)
        )
    }
}

private extension KnowledgeQueryBuilder {
    func elementKeywords(from context: DestinyContext) -> [String] {
        var keywords: [String] = []

        for element in context.dominantElements {
            keywords.append(element)
            keywords.append("\(element)偏旺")
        }

        for element in context.weakElements {
            keywords.append(element)
            keywords.append("\(element)偏弱")
        }

        for (element, count) in context.wuxingCounts.sorted(by: { $0.key < $1.key }) {
            keywords.append(element)
            keywords.append("\(element)\(count)")
        }

        return keywords
    }

    func baziKeywords(from context: DestinyContext) -> [String] {
        var keywords = context.baziPillars.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        if !keywords.isEmpty {
            keywords.append("四柱")
            keywords.append("天干")
            keywords.append("地支")
        }
        return keywords
    }

    func tokenize(_ text: String) -> [String] {
        let separators = CharacterSet.whitespacesAndNewlines
            .union(.punctuationCharacters)
            .union(CharacterSet(charactersIn: "，。、！？；：,.!?;:()（）[]【】「」“”\"'"))

        let coarseTokens = text
            .components(separatedBy: separators)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let domainTerms = [
            "称骨",
            "命格",
            "五行",
            "阴阳",
            "八卦",
            "天干",
            "地支",
            "天干地支",
            "相生",
            "相克",
            "今日",
            "气象"
        ].filter { text.contains($0) }

        return coarseTokens + domainTerms
    }

    func uniqueKeywords(_ rawKeywords: [String?]) -> [String] {
        uniqueKeywords(rawKeywords.compactMap { $0 })
    }

    func uniqueKeywords(_ rawKeywords: [String]) -> [String] {
        var seen = Set<String>()
        var keywords: [String] = []

        for keyword in rawKeywords {
            let trimmed = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
            guard trimmed.count >= 1 else {
                continue
            }

            let key = trimmed.lowercased()
            guard !seen.contains(key) else {
                continue
            }

            seen.insert(key)
            keywords.append(trimmed)
        }

        return Array(keywords.prefix(18))
    }
}
