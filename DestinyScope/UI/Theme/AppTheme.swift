//
//  AppTheme.swift
//  DestinyScope
//
//  Created by Codex on 2026/5/26.
//

import SwiftUI
import UIKit

enum AppTheme {
    enum Colors {
        static let background = dynamicColor(
            light: UIColor(red: 247/255, green: 239/255, blue: 220/255, alpha: 1),
            dark: UIColor(red: 24/255, green: 21/255, blue: 18/255, alpha: 1)
        )
        static let secondaryBackground = dynamicColor(
            light: UIColor(red: 238/255, green: 224/255, blue: 194/255, alpha: 1),
            dark: UIColor(red: 34/255, green: 30/255, blue: 26/255, alpha: 1)
        )
        static let cardBackground = dynamicColor(
            light: UIColor(red: 255/255, green: 250/255, blue: 238/255, alpha: 1),
            dark: UIColor(red: 42/255, green: 37/255, blue: 32/255, alpha: 1)
        )
        static let primaryText = dynamicColor(
            light: UIColor(red: 32/255, green: 28/255, blue: 24/255, alpha: 1),
            dark: UIColor(red: 244/255, green: 235/255, blue: 218/255, alpha: 1)
        )
        static let secondaryText = dynamicColor(
            light: UIColor(red: 99/255, green: 83/255, blue: 63/255, alpha: 1),
            dark: UIColor(red: 192/255, green: 176/255, blue: 148/255, alpha: 1)
        )
        static let cinnabar = dynamicColor(
            light: UIColor(red: 158/255, green: 45/255, blue: 36/255, alpha: 1),
            dark: UIColor(red: 214/255, green: 92/255, blue: 73/255, alpha: 1)
        )
        static let darkGold = dynamicColor(
            light: UIColor(red: 151/255, green: 111/255, blue: 38/255, alpha: 1),
            dark: UIColor(red: 210/255, green: 166/255, blue: 78/255, alpha: 1)
        )
        static let ink = dynamicColor(
            light: UIColor(red: 24/255, green: 28/255, blue: 29/255, alpha: 1),
            dark: UIColor(red: 226/255, green: 229/255, blue: 226/255, alpha: 1)
        )
        static let paper = dynamicColor(
            light: UIColor(red: 255/255, green: 252/255, blue: 241/255, alpha: 1),
            dark: UIColor(red: 31/255, green: 28/255, blue: 24/255, alpha: 1)
        )
        static let divider = dynamicColor(
            light: UIColor(red: 209/255, green: 188/255, blue: 145/255, alpha: 1),
            dark: UIColor(red: 91/255, green: 78/255, blue: 58/255, alpha: 1)
        )

        private static func dynamicColor(light: UIColor, dark: UIColor) -> Color {
            Color(UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ? dark : light
            })
        }
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
    }

    enum Radius {
        static let card: CGFloat = 8
        static let button: CGFloat = 20
    }

    enum Typography {
        static let pageTitle = Font.title2.weight(.semibold)
        static let sectionTitle = Font.headline.weight(.semibold)
        static let body = Font.body
        static let secondary = Font.subheadline
        static let caption = Font.caption
        static let footnote = Font.footnote
    }
}
