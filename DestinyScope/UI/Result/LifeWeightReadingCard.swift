//
//  LifeWeightReadingCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/3.
//

import SwiftUI

struct LifeWeightReadingCard: View {
    let result: LifeWeightResult
    let reading: LifeWeightReading?
    let interpretation: FortuneInterpretation
    let insight: LifeWeightInsight

    @EnvironmentObject private var localizationStore: LocalizationStore
    @State private var isDetailExpanded = false

    private var content: LifeWeightReadingDisplayContent {
        LifeWeightReadingDisplayContent(
            result: result,
            reading: reading,
            interpretation: interpretation,
            insight: insight
        )
    }

    var body: some View {
        let content = content

        AppCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                AppSectionHeader(title: localizationStore.string("result.reading.title"))

                Text(localizationStore.string("result.reading.subtitle"))
                    .font(AppTheme.Typography.secondary)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

                if !content.keywords.isEmpty {
                    LifeWeightReadingTagFlowView(tags: content.keywords)
                }

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(content.title)
                        .font(AppTheme.Typography.sectionTitle)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    if !content.detail.isEmpty {
                        ExpandableReadingDetailText(
                            text: content.detail,
                            isExpanded: $isDetailExpanded
                        )
                    }
                }

                LifeWeightReadingSectionView(
                    rows: rows(
                        ("personality", "result.reading.field.personality", content.personality),
                        ("career", "result.reading.field.career", content.career)
                    )
                )

                LifeWeightReadingSectionView(
                    rows: rows(
                        ("wealth", "result.reading.field.wealth", content.wealth),
                        ("relationship", "result.reading.field.relationship", content.relationship)
                    )
                )

                LifeWeightReadingSectionView(
                    rows: rows(
                        ("childrenFamily", "result.reading.field.childrenFamily", content.childrenFamily),
                        ("healthBlessing", "result.reading.field.healthBlessing", content.healthBlessing)
                    )
                )

                LifeWeightReadingSectionView(
                    rows: rows(("advice", "result.reading.field.advice", content.advice))
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func rows(_ values: (String, String, String)...) -> [LifeWeightReadingSectionRow] {
        values.compactMap { id, titleID, body in
            let trimmedBody = body.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedBody.isEmpty else {
                return nil
            }
            return LifeWeightReadingSectionRow(
                id: id,
                title: localizationStore.string(L10nID(titleID)),
                systemImageName: sectionRowIconName(for: id),
                body: trimmedBody
            )
        }
    }

    private func sectionRowIconName(for id: String) -> String {
        switch id {
        case "personality":
            return "person.crop.circle.fill"
        case "career":
            return "briefcase.fill"
        case "wealth":
            return "yensign.circle.fill"
        case "relationship":
            return "heart.circle.fill"
        case "childrenFamily":
            return "person.2.fill"
        case "healthBlessing":
            return "leaf.fill"
        case "advice":
            return "checkmark.seal.fill"
        default:
            return "circle.fill"
        }
    }
}

private struct ExpandableReadingDetailText: View {
    let text: String
    @Binding var isExpanded: Bool

    @State private var fullHeight: CGFloat = 0
    @State private var collapsedHeight: CGFloat = 0
    @State private var availableWidth: CGFloat = 0

    private var isTruncated: Bool {
        collapsedHeight > 0 && fullHeight > collapsedHeight + 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(text)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .lineSpacing(4)
                .lineLimit(isExpanded ? nil : 10)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)

            if isTruncated {
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.cinnabar)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .buttonStyle(.plain)
            }
        }
        .readWidth(updateAvailableWidth)
        .overlay(alignment: .topLeading) {
            measurementViews
        }
    }

    @ViewBuilder
    private var measurementViews: some View {
        if availableWidth > 0 {
            ZStack(alignment: .topLeading) {
                measuredText(lineLimit: nil)
                    .readHeight(updateFullHeight)

                measuredText(lineLimit: 10)
                    .readHeight(updateCollapsedHeight)
            }
            .hidden()
            .allowsHitTesting(false)
        }
    }

    private func measuredText(lineLimit: Int?) -> some View {
        Text(text)
            .font(AppTheme.Typography.body)
            .lineSpacing(4)
            .lineLimit(lineLimit)
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: availableWidth, alignment: .leading)
    }

    private func updateFullHeight(_ height: CGFloat) {
        guard abs(fullHeight - height) > 0.5 else {
            return
        }
        fullHeight = height
    }

    private func updateCollapsedHeight(_ height: CGFloat) {
        guard abs(collapsedHeight - height) > 0.5 else {
            return
        }
        collapsedHeight = height
    }

    private func updateAvailableWidth(_ width: CGFloat) {
        guard abs(availableWidth - width) > 0.5 else {
            return
        }
        availableWidth = width
    }
}

private extension View {
    func readWidth(_ update: @escaping (CGFloat) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear { update(proxy.size.width) }
                    .onChange(of: proxy.size.width) { _, width in
                        update(width)
                    }
            }
        )
    }

    func readHeight(_ update: @escaping (CGFloat) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear { update(proxy.size.height) }
                    .onChange(of: proxy.size.height) { _, height in
                        update(height)
                    }
            }
        )
    }
}

struct LifeWeightReadingDisplayContent {
    let title: String
    let keywords: [String]
    let detail: String
    let personality: String
    let career: String
    let wealth: String
    let relationship: String
    let childrenFamily: String
    let healthBlessing: String
    let advice: String

    init(
        result: LifeWeightResult,
        reading: LifeWeightReading?,
        interpretation: FortuneInterpretation,
        insight: LifeWeightInsight
    ) {
        title = Self.firstNonEmpty(reading?.title, result.title)
        keywords = Self.nonEmptyKeywords(reading?.keywords) ?? insight.tags
        detail = Self.firstNonEmpty(reading?.detail, interpretation.summary)
        personality = Self.firstNonEmpty(reading?.personality, interpretation.personality)
        career = Self.firstNonEmpty(reading?.career, interpretation.career)
        wealth = Self.firstNonEmpty(reading?.wealth, interpretation.wealth)
        relationship = Self.firstNonEmpty(reading?.relationship, interpretation.relationship)
        childrenFamily = Self.firstNonEmpty(reading?.childrenFamily)
        healthBlessing = Self.firstNonEmpty(reading?.healthBlessing)
        advice = Self.firstNonEmpty(reading?.advice, insight.actionSuggestion)
    }

    private static func firstNonEmpty(_ values: String?...) -> String {
        values
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .first { !$0.isEmpty } ?? ""
    }

    private static func nonEmptyKeywords(_ values: [String]?) -> [String]? {
        let keywords = values?
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty } ?? []
        return keywords.isEmpty ? nil : keywords
    }
}
