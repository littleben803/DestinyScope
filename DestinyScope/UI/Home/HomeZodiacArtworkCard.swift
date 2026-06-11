//
//  HomeZodiacArtworkCard.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/10.
//

import SwiftUI
import UIKit

struct HomeZodiacArtworkCard: View {
    @EnvironmentObject private var localizationStore: LocalizationStore

    let artwork: HomeZodiacArtwork

    var body: some View {
        AppCard {
            artworkContent
                .aspectRatio(16.0 / 9.0, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card, style: .continuous))
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(localizationStore.string(.homeZodiacArtworkAccessibilityLabel))
    }

    @ViewBuilder
    private var artworkContent: some View {
        if let image = artwork.image() {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            placeholderContent
        }
    }

    private var placeholderContent: some View {
        ZStack {
            AppTheme.Colors.paper

            ZodiacPlaceholderWheel(selectedIndex: artwork.index)
                .padding(AppTheme.Spacing.xl)
        }
    }
}

enum HomeZodiacArtwork: CaseIterable, Equatable {
    case rat
    case ox
    case tiger
    case rabbit
    case dragon
    case snake
    case horse
    case goat
    case monkey
    case rooster
    case dog
    case pig

    var resourceName: String {
        switch self {
        case .rat:
            return "鼠"
        case .ox:
            return "牛"
        case .tiger:
            return "虎"
        case .rabbit:
            return "兔"
        case .dragon:
            return "龙"
        case .snake:
            return "蛇"
        case .horse:
            return "马"
        case .goat:
            return "羊"
        case .monkey:
            return "猴"
        case .rooster:
            return "鸡"
        case .dog:
            return "狗"
        case .pig:
            return "猪"
        }
    }

    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }

    func image(in bundle: Bundle = .main) -> UIImage? {
        for subdirectory in ["Resources/Zodiac", "Zodiac"] {
            if let image = image(in: bundle, subdirectory: subdirectory) {
                return image
            }
        }

        return image(in: bundle, subdirectory: nil)
    }

    static func zodiac(for solarDate: Date, hour: Int, timeZone: TimeZone = .current) -> HomeZodiacArtwork {
        var gregorianCalendar = Calendar(identifier: .gregorian)
        gregorianCalendar.timeZone = timeZone

        let dateComponents = gregorianCalendar.dateComponents([.year, .month, .day], from: solarDate)
        let normalizedHour = min(max(hour, 0), 23)
        let dateAtSelectedHour = gregorianCalendar.date(
            from: DateComponents(
                timeZone: timeZone,
                year: dateComponents.year,
                month: dateComponents.month,
                day: dateComponents.day,
                hour: normalizedHour
            )
        ) ?? solarDate

        var chineseCalendar = Calendar(identifier: .chinese)
        chineseCalendar.timeZone = timeZone

        guard let lunarYear = chineseCalendar.dateComponents([.year], from: dateAtSelectedHour).year else {
            return .dragon
        }

        return Self.allCases[positiveModulo(lunarYear - 1, Self.allCases.count)]
    }

    private static func positiveModulo(_ value: Int, _ divisor: Int) -> Int {
        ((value % divisor) + divisor) % divisor
    }

    private func image(in bundle: Bundle, subdirectory: String?) -> UIImage? {
        guard let imageURL = bundle.url(
            forResource: resourceName,
            withExtension: "png",
            subdirectory: subdirectory
        ) else {
            return nil
        }

        return UIImage(contentsOfFile: imageURL.path)
    }
}

private struct ZodiacPlaceholderWheel: View {
    let selectedIndex: Int

    private let markerCount = 12

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            let markerSize = max(side * 0.065, 6)
            let radius = max((side - markerSize) / 2, 0)

            ZStack {
                Circle()
                    .stroke(AppTheme.Colors.divider.opacity(0.45), lineWidth: 1)
                    .frame(width: side, height: side)

                Circle()
                    .fill(AppTheme.Colors.cinnabar.opacity(0.12))
                    .frame(width: side * 0.48, height: side * 0.48)

                Image(systemName: "sparkles")
                    .font(.system(size: side * 0.18, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.darkGold)
                    .accessibilityHidden(true)

                ForEach(0..<markerCount, id: \.self) { index in
                    let angle = Double(index) / Double(markerCount) * 2 * Double.pi - Double.pi / 2

                    Circle()
                        .fill(index == selectedIndex ? AppTheme.Colors.cinnabar : AppTheme.Colors.darkGold.opacity(0.42))
                        .frame(width: markerSize, height: markerSize)
                        .position(
                            x: proxy.size.width / 2 + CGFloat(cos(angle)) * radius,
                            y: proxy.size.height / 2 + CGFloat(sin(angle)) * radius
                        )
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

#Preview {
    HomeZodiacArtworkCard(artwork: .dragon)
        .environmentObject(LocalizationStore())
        .padding()
        .background(AppTheme.Colors.background)
}
