//
//  L10nID.swift
//  DestinyScope
//
//  Created by Codex on 2026/6/2.
//

import Foundation

struct L10nID: RawRepresentable, Hashable, ExpressibleByStringLiteral {
    let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }

    init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }
}

extension L10nID {
    static let appName = L10nID("app.name")
    static let appSubtitle = L10nID("app.subtitle")
    static let appBrandInternal = L10nID("app.brand.internal")

    static let tabHome = L10nID("tab.home")
    static let tabKnowledge = L10nID("tab.knowledge")
    static let tabQA = L10nID("tab.qa")
    static let tabHistory = L10nID("tab.history")
    static let tabSettings = L10nID("tab.settings")

    static let appLanguageSystem = L10nID("app.language.system")
    static let appLanguageSimplifiedChinese = L10nID("app.language.zhHans")
    static let appLanguageTraditionalChinese = L10nID("app.language.zhHant")
    static let appLanguageEnglish = L10nID("app.language.en")
    static let genderMale = L10nID("gender.male")
    static let genderFemale = L10nID("gender.female")
    static let commonCancel = L10nID("common.cancel")

    static let settingsNavigationTitle = L10nID("settings.navigation.title")
    static let settingsApplicationSectionTitle = L10nID("settings.application.section.title")
    static let settingsAboutTitle = L10nID("settings.about.title")
    static let settingsAboutSubtitle = L10nID("settings.about.subtitle")
    static let settingsAboutAccessibilityHint = L10nID("settings.about.accessibilityHint")
    static let settingsOnboardingTitle = L10nID("settings.onboarding.title")
    static let settingsOnboardingSubtitle = L10nID("settings.onboarding.subtitle")
    static let settingsOnboardingAccessibilityHint = L10nID("settings.onboarding.accessibilityHint")
    static let settingsLanguageTitle = L10nID("settings.language.title")
    static let settingsLanguageCurrentSystem = L10nID("settings.language.current.system")
    static let settingsLanguageCurrentManual = L10nID("settings.language.current.manual")
    static let settingsLanguageAccessibilityHint = L10nID("settings.language.accessibilityHint")
    static let settingsPrivacySectionTitle = L10nID("settings.privacy.section.title")
    static let settingsPrivacyPolicyTitle = L10nID("settings.privacyPolicy.title")
    static let settingsPrivacyPolicySubtitle = L10nID("settings.privacyPolicy.subtitle")
    static let settingsPrivacyPolicyAccessibilityHint = L10nID("settings.privacyPolicy.accessibilityHint")
    static let settingsDisclaimerTitle = L10nID("settings.disclaimer.title")
    static let settingsDisclaimerSubtitle = L10nID("settings.disclaimer.subtitle")
    static let settingsDisclaimerAccessibilityHint = L10nID("settings.disclaimer.accessibilityHint")
    static let settingsOpenSourceTitle = L10nID("settings.openSource.title")
    static let settingsOpenSourceSubtitle = L10nID("settings.openSource.subtitle")
    static let settingsOpenSourceAccessibilityHint = L10nID("settings.openSource.accessibilityHint")
    static let settingsLocalDataSectionTitle = L10nID("settings.localData.section.title")
    static let settingsLocalDataManagementTitle = L10nID("settings.localDataManagement.title")
    static let settingsLocalDataManagementSubtitle = L10nID("settings.localDataManagement.subtitle")
    static let settingsLocalDataManagementAccessibilityHint = L10nID("settings.localDataManagement.accessibilityHint")

    static let languageSettingsSectionTitle = L10nID("languageSettings.section.title")
    static let languageSettingsSectionSubtitle = L10nID("languageSettings.section.subtitle")
    static let languageSettingsSystemSubtitle = L10nID("languageSettings.option.system.subtitle")
    static let languageSettingsManualSubtitle = L10nID("languageSettings.option.manual.subtitle")
    static let languageSettingsSelectedAccessibilityValue = L10nID("languageSettings.option.selected.accessibilityValue")

    static let aboutNavigationTitle = L10nID("about.navigation.title")
    static let aboutTagline = L10nID("about.tagline")
    static let aboutBody = L10nID("about.body")

    static let onboardingNavigationTitle = L10nID("onboarding.navigation.title")
    static let onboardingHeaderTitle = L10nID("onboarding.header.title")
    static let onboardingHeaderSubtitle = L10nID("onboarding.header.subtitle")
    static let onboardingNext = L10nID("onboarding.button.next")
    static let onboardingDone = L10nID("onboarding.button.done")
    static let onboardingStart = L10nID("onboarding.button.start")
    static let onboardingSkip = L10nID("onboarding.button.skip")
    static let onboardingNextHint = L10nID("onboarding.accessibility.nextHint")
    static let onboardingDoneHint = L10nID("onboarding.accessibility.doneHint")
    static let onboardingStartHint = L10nID("onboarding.accessibility.startHint")
    static let onboardingSkipHint = L10nID("onboarding.accessibility.skipHint")

    static let homeHeroSubtitle = L10nID("home.hero.subtitle")
    static let homeInputTitle = L10nID("home.input.title")
    static let homeBirthDateTitle = L10nID("home.input.birthDate")
    static let homeGenderTitle = L10nID("home.input.gender")
    static let homeBirthHourTitle = L10nID("home.input.birthHour")
    static let homeHourValue = L10nID("home.input.hourValue")
    static let homeInputPrivacy = L10nID("home.input.privacy")
    static let homeInputCalculate = L10nID("home.input.calculate")
    static let homeInputCalculateAccessibilityLabel = L10nID("home.input.calculate.accessibilityLabel")
    static let homeInputCalculateAccessibilityHint = L10nID("home.input.calculate.accessibilityHint")
    static let homeInputPromptTitle = L10nID("home.input.prompt.title")
    static let homeRecentTitle = L10nID("home.recent.title")
    static let homeRecentWeight = L10nID("home.recent.weight")
    static let homeRecentBirthEightCharacters = L10nID("home.recent.birthEightCharacters")
    static let homeRecentDescription = L10nID("home.recent.description")
    static let homeZodiacArtworkAccessibilityLabel = L10nID("home.zodiacArtwork.accessibilityLabel")
    static let homePrivacyTitle = L10nID("home.privacy.title")
    static let homePrivacyBody = L10nID("home.privacy.body")
    static let homeKnowledgeTitle = L10nID("home.knowledge.title")
    static let homeKnowledgeBody = L10nID("home.knowledge.body")
    static let homeErrorCalculateFallback = L10nID("home.error.calculateFallback")

    static let legalPrivacyNavigationTitle = L10nID("legal.privacy.navigation.title")
    static let legalDisclaimerNavigationTitle = L10nID("legal.disclaimer.navigation.title")
    static let legalOpenSourceNavigationTitle = L10nID("legal.openSource.navigation.title")
}
