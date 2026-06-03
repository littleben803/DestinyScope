//
//  LifeWeightReadingTagFlowView.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/3.
//

import SwiftUI

struct LifeWeightReadingTagFlowView: View {
    let tags: [String]

    var body: some View {
        TagFlowLayout(horizontalSpacing: AppTheme.Spacing.sm, verticalSpacing: AppTheme.Spacing.sm) {
            ForEach(tags, id: \.self) { tag in
                Label(tag, systemImage: "tag.fill")
                    .font(AppTheme.Typography.caption.weight(.medium))
                    .foregroundColor(AppTheme.Colors.cinnabar)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .padding(.horizontal, AppTheme.Spacing.sm)
                    .padding(.vertical, AppTheme.Spacing.xs)
                    .background(AppTheme.Colors.secondaryBackground.opacity(0.72))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous)
                            .stroke(AppTheme.Colors.divider.opacity(0.55), lineWidth: 1)
                    )
            }
        }
    }
}

private struct TagFlowLayout: Layout {
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let rows = rows(in: proposal.width, subviews: subviews)
        let height = rows.reduce(CGFloat.zero) { total, row in
            total + row.height
        } + CGFloat(max(rows.count - 1, 0)) * verticalSpacing

        return CGSize(width: proposal.width ?? rows.map(\.width).max() ?? 0, height: height)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var y = bounds.minY
        for row in rows(in: bounds.width, subviews: subviews) {
            var x = bounds.minX
            for item in row.items {
                subviews[item.index].place(
                    at: CGPoint(x: x, y: y),
                    proposal: ProposedViewSize(item.size)
                )
                x += item.size.width + horizontalSpacing
            }
            y += row.height + verticalSpacing
        }
    }

    private func rows(in width: CGFloat?, subviews: Subviews) -> [TagFlowRow] {
        guard !subviews.isEmpty else {
            return []
        }

        let availableWidth = width ?? CGFloat.greatestFiniteMagnitude
        var rows: [TagFlowRow] = []
        var currentItems: [TagFlowItem] = []
        var currentWidth: CGFloat = 0
        var currentHeight: CGFloat = 0

        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            let itemWidth = min(size.width, availableWidth)
            let spacing = currentItems.isEmpty ? 0 : horizontalSpacing
            let shouldWrap = !currentItems.isEmpty && currentWidth + spacing + itemWidth > availableWidth

            if shouldWrap {
                rows.append(TagFlowRow(items: currentItems, width: currentWidth, height: currentHeight))
                currentItems = []
                currentWidth = 0
                currentHeight = 0
            }

            let item = TagFlowItem(index: index, size: CGSize(width: itemWidth, height: size.height))
            currentItems.append(item)
            currentWidth += (currentItems.count == 1 ? 0 : horizontalSpacing) + itemWidth
            currentHeight = max(currentHeight, size.height)
        }

        if !currentItems.isEmpty {
            rows.append(TagFlowRow(items: currentItems, width: currentWidth, height: currentHeight))
        }

        return rows
    }
}

private struct TagFlowRow {
    let items: [TagFlowItem]
    let width: CGFloat
    let height: CGFloat
}

private struct TagFlowItem {
    let index: Int
    let size: CGSize
}
