//
//  KnowledgeArticleLocalization.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import Foundation

enum KnowledgeArticleCategoryKind {
    case lifeWeight
    case lunarHour
    case stemsBranches
    case yinYang
    case heavenlyStems
    case earthlyBranches
    case zodiac
    case fiveElements
    case bagua
    case yiBasics
    case meihua
    case boundary
    case unknown

    var titleID: L10nID {
        switch self {
        case .lifeWeight:
            return "knowledge.category.lifeWeight"
        case .lunarHour:
            return "knowledge.category.lunarHour"
        case .stemsBranches:
            return "knowledge.category.stemsBranches"
        case .yinYang:
            return "knowledge.category.yinYang"
        case .heavenlyStems:
            return "knowledge.category.heavenlyStems"
        case .earthlyBranches:
            return "knowledge.category.earthlyBranches"
        case .zodiac:
            return "knowledge.category.zodiac"
        case .fiveElements:
            return "knowledge.category.fiveElements"
        case .bagua:
            return "knowledge.category.bagua"
        case .yiBasics:
            return "knowledge.category.yiBasics"
        case .meihua:
            return "knowledge.category.meihua"
        case .boundary:
            return "knowledge.category.boundary"
        case .unknown:
            return "knowledge.category.unknown"
        }
    }

    var iconName: String {
        switch self {
        case .lifeWeight:
            return "scalemass"
        case .lunarHour:
            return "clock"
        case .stemsBranches:
            return "calendar"
        case .yinYang:
            return "circle.lefthalf.filled"
        case .heavenlyStems:
            return "calendar"
        case .earthlyBranches:
            return "calendar"
        case .zodiac:
            return "circle.grid.2x2"
        case .fiveElements:
            return "leaf"
        case .bagua:
            return "circle.hexagongrid"
        case .yiBasics:
            return "book.closed"
        case .meihua:
            return "sparkles"
        case .boundary:
            return "shield"
        case .unknown:
            return "book.closed"
        }
    }
}

enum KnowledgeArticleLocalization {
    static func categoryKind(for article: KnowledgeArticle) -> KnowledgeArticleCategoryKind {
        categoryKind(forCategory: article.category) ?? categoryKind(forArticleID: article.id)
    }

    static func categoryKind(forCategory category: String) -> KnowledgeArticleCategoryKind? {
        switch category.trimmingCharacters(in: .whitespacesAndNewlines) {
        case "称骨算命":
            return .lifeWeight
        case "农历时辰":
            return .lunarHour
        case "天干地支":
            return .stemsBranches
        case "阴阳":
            return .yinYang
        case "天干":
            return .heavenlyStems
        case "地支":
            return .earthlyBranches
        case "生肖":
            return .zodiac
        case "五行":
            return .fiveElements
        case "八卦", "八卦周易":
            return .bagua
        case "易学基础", "传统文化":
            return .yiBasics
        case "梅花易数":
            return .meihua
        case "使用边界":
            return .boundary
        default:
            return nil
        }
    }

    static func categoryKind(forArticleID articleID: String) -> KnowledgeArticleCategoryKind {
        if articleID == "life_weight_rational_view"
            || articleID == "metaphysics_self_exploration"
            || articleID == "rational_use_boundary" {
            return .boundary
        }

        if articleID.hasPrefix("life_weight") {
            return .lifeWeight
        }

        if articleID.hasPrefix("lunar") || articleID == "twelve_hours" {
            return .lunarHour
        }

        if articleID.hasPrefix("heavenly")
            || articleID.hasPrefix("earthly")
            || articleID.hasPrefix("stems")
            || articleID.hasPrefix("sexagenary") {
            return .stemsBranches
        }

        if articleID.hasPrefix("zodiac") {
            return .zodiac
        }

        if articleID.hasPrefix("five_elements") {
            return .fiveElements
        }

        if articleID.hasPrefix("bagua")
            || articleID.hasPrefix("qian")
            || articleID.hasPrefix("kun")
            || articleID.hasPrefix("zhen")
            || articleID.hasPrefix("xun")
            || articleID.hasPrefix("kan")
            || articleID.hasPrefix("li_")
            || articleID.hasPrefix("gen")
            || articleID.hasPrefix("dui")
            || articleID.hasPrefix("zhouyi") {
            return .bagua
        }

        if articleID.hasPrefix("meihua") {
            return .meihua
        }

        return .unknown
    }
}
