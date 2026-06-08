//
//  ResultShareTextBuilder.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/1.
//

import Foundation

struct ResultShareTextBuilder {
    func build(
        result: LifeWeightResult,
        reading: LifeWeightReading?,
        interpretation: FortuneInterpretation,
        insight: LifeWeightInsight,
        localizationStore: LocalizationStore
    ) -> String {
        var lines: [String] = [
            localizationStore.string("result.poem.title"),
            result.poem.trimmingCharacters(in: .whitespacesAndNewlines),
            "",
            localizationStore.string("result.reading.title")
        ]

        let content = displayContent(
            result: result,
            reading: reading,
            interpretation: interpretation,
            insight: insight
        )

        append(content.title, to: &lines)
        append(content.detail, to: &lines)

        appendReadingField("result.reading.field.personality", content.personality, localizationStore, to: &lines)
        appendReadingField("result.reading.field.career", content.career, localizationStore, to: &lines)
        appendReadingField("result.reading.field.wealth", content.wealth, localizationStore, to: &lines)
        appendReadingField("result.reading.field.relationship", content.relationship, localizationStore, to: &lines)
        appendReadingField("result.reading.field.childrenFamily", content.childrenFamily, localizationStore, to: &lines)
        appendReadingField("result.reading.field.healthBlessing", content.healthBlessing, localizationStore, to: &lines)
        appendReadingField("result.reading.field.advice", content.advice, localizationStore, to: &lines)

        return lines
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .joined(separator: "\n\n")
    }

    private func displayContent(
        result: LifeWeightResult,
        reading: LifeWeightReading?,
        interpretation: FortuneInterpretation,
        insight: LifeWeightInsight
    ) -> ShareDisplayContent {
        ShareDisplayContent(
            title: firstNonEmpty(reading?.title, result.title),
            detail: firstNonEmpty(reading?.detail, interpretation.summary),
            personality: firstNonEmpty(reading?.personality, interpretation.personality),
            career: firstNonEmpty(reading?.career, interpretation.career),
            wealth: firstNonEmpty(reading?.wealth, interpretation.wealth),
            relationship: firstNonEmpty(reading?.relationship, interpretation.relationship),
            childrenFamily: firstNonEmpty(reading?.childrenFamily),
            healthBlessing: firstNonEmpty(reading?.healthBlessing),
            advice: firstNonEmpty(reading?.advice, insight.actionSuggestion)
        )
    }

    private func appendReadingField(
        _ titleID: L10nID,
        _ body: String,
        _ localizationStore: LocalizationStore,
        to lines: inout [String]
    ) {
        let trimmedBody = body.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedBody.isEmpty else {
            return
        }
        lines.append("\(localizationStore.string(titleID))\n\(trimmedBody)")
    }

    private func append(_ text: String, to lines: inout [String]) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            return
        }
        lines.append(trimmedText)
    }

    private func firstNonEmpty(_ values: String?...) -> String {
        values
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .first { !$0.isEmpty } ?? ""
    }
}

private struct ShareDisplayContent {
    let title: String
    let detail: String
    let personality: String
    let career: String
    let wealth: String
    let relationship: String
    let childrenFamily: String
    let healthBlessing: String
    let advice: String
}
