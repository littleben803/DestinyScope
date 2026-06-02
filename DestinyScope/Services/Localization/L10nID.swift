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

    static let tabHome = L10nID("tab.home")
    static let tabKnowledge = L10nID("tab.knowledge")
    static let tabHistory = L10nID("tab.history")
    static let tabSettings = L10nID("tab.settings")

    static let appLanguageSystem = L10nID("app.language.system")
    static let appLanguageSimplifiedChinese = L10nID("app.language.zhHans")
    static let appLanguageTraditionalChinese = L10nID("app.language.zhHant")
    static let appLanguageEnglish = L10nID("app.language.en")

    static let settingsNavigationTitle = L10nID("settings.navigation.title")
    static let settingsApplicationSectionTitle = L10nID("settings.application.section.title")
    static let settingsApplicationSectionSubtitle = L10nID("settings.application.section.subtitle")
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
    static let settingsPrivacySectionSubtitle = L10nID("settings.privacy.section.subtitle")
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
    static let settingsLocalDataSectionSubtitle = L10nID("settings.localData.section.subtitle")
    static let settingsLocalDataManagementTitle = L10nID("settings.localDataManagement.title")
    static let settingsLocalDataManagementSubtitle = L10nID("settings.localDataManagement.subtitle")
    static let settingsLocalDataManagementAccessibilityHint = L10nID("settings.localDataManagement.accessibilityHint")
    static let settingsSavedProfilesTitle = L10nID("settings.savedProfiles.title")
    static let settingsSavedProfilesSubtitle = L10nID("settings.savedProfiles.subtitle")
    static let settingsSavedProfilesAccessibilityHint = L10nID("settings.savedProfiles.accessibilityHint")
    static let settingsDebugSectionTitle = L10nID("settings.debug.section.title")
    static let settingsDebugSectionSubtitle = L10nID("settings.debug.section.subtitle")
    static let settingsLocalModelDebugTitle = L10nID("settings.localModelDebug.title")
    static let settingsLocalModelDebugSubtitle = L10nID("settings.localModelDebug.subtitle")
    static let settingsLocalModelDebugAccessibilityHint = L10nID("settings.localModelDebug.accessibilityHint")

    static let languageSettingsSectionTitle = L10nID("languageSettings.section.title")
    static let languageSettingsSectionSubtitle = L10nID("languageSettings.section.subtitle")
    static let languageSettingsSystemSubtitle = L10nID("languageSettings.option.system.subtitle")
    static let languageSettingsManualSubtitle = L10nID("languageSettings.option.manual.subtitle")
    static let languageSettingsSelectedAccessibilityValue = L10nID("languageSettings.option.selected.accessibilityValue")

    static let aboutNavigationTitle = L10nID("about.navigation.title")
    static let aboutTagline = L10nID("about.tagline")
    static let aboutBody = L10nID("about.body")
    static let aboutCapabilitiesTitle = L10nID("about.capabilities.title")
    static let aboutCapabilityBirth = L10nID("about.capability.birth")
    static let aboutCapabilityOffline = L10nID("about.capability.offline")
    static let aboutCapabilityHistory = L10nID("about.capability.history")
    static let aboutCapabilityLocalModel = L10nID("about.capability.localModel")
    static let aboutBoundaryTitle = L10nID("about.boundary.title")
    static let aboutBoundaryBody = L10nID("about.boundary.body")
    static let aboutHelpTitle = L10nID("about.help.title")
    static let aboutLegalPrivacyTitle = L10nID("about.legalPrivacy.title")
    static let aboutPrivacySubtitle = L10nID("about.privacy.subtitle")
    static let aboutDisclaimerSubtitle = L10nID("about.disclaimer.subtitle")
    static let aboutOpenSourceSubtitle = L10nID("about.openSource.subtitle")

    static let onboardingNavigationTitle = L10nID("onboarding.navigation.title")
    static let onboardingHeaderTitle = L10nID("onboarding.header.title")
    static let onboardingHeaderSubtitle = L10nID("onboarding.header.subtitle")
    static let onboardingNext = L10nID("onboarding.button.next")
    static let onboardingPrevious = L10nID("onboarding.button.previous")
    static let onboardingDone = L10nID("onboarding.button.done")
    static let onboardingStart = L10nID("onboarding.button.start")
    static let onboardingNextHint = L10nID("onboarding.accessibility.nextHint")
    static let onboardingPreviousHint = L10nID("onboarding.accessibility.previousHint")
    static let onboardingDoneHint = L10nID("onboarding.accessibility.doneHint")
    static let onboardingStartHint = L10nID("onboarding.accessibility.startHint")

    static let homeHeroSubtitle = L10nID("home.hero.subtitle")
    static let homeInputTitle = L10nID("home.input.title")
    static let homeBirthDateTitle = L10nID("home.input.birthDate")
    static let homeBirthHourTitle = L10nID("home.input.birthHour")
    static let homeHourValue = L10nID("home.input.hourValue")
    static let homeInputPrivacy = L10nID("home.input.privacy")
    static let homeInputCalculate = L10nID("home.input.calculate")
    static let homeInputCalculateAccessibilityLabel = L10nID("home.input.calculate.accessibilityLabel")
    static let homeInputCalculateAccessibilityHint = L10nID("home.input.calculate.accessibilityHint")
    static let homeInputSaveProfile = L10nID("home.input.saveProfile")
    static let homeInputSaveProfileAccessibilityLabel = L10nID("home.input.saveProfile.accessibilityLabel")
    static let homeInputSaveProfileAccessibilityHint = L10nID("home.input.saveProfile.accessibilityHint")
    static let homeInputPromptTitle = L10nID("home.input.prompt.title")
    static let homeBirthProfilesTitle = L10nID("home.birthProfiles.title")
    static let homeBirthProfilesBadge = L10nID("home.birthProfiles.badge")
    static let homeBirthProfilesDescription = L10nID("home.birthProfiles.description")
    static let homeBirthProfilesEmpty = L10nID("home.birthProfiles.empty")
    static let homeBirthProfilesSelectAccessibilityLabel = L10nID("home.birthProfiles.select.accessibilityLabel")
    static let homeBirthProfilesSelectAccessibilityHint = L10nID("home.birthProfiles.select.accessibilityHint")
    static let homeRecentTitle = L10nID("home.recent.title")
    static let homeRecentWeight = L10nID("home.recent.weight")
    static let homeRecentDescription = L10nID("home.recent.description")
    static let homeRecentEmpty = L10nID("home.recent.empty")
    static let homePrivacyTitle = L10nID("home.privacy.title")
    static let homePrivacyBody = L10nID("home.privacy.body")
    static let homeKnowledgeTitle = L10nID("home.knowledge.title")
    static let homeKnowledgeBody = L10nID("home.knowledge.body")
    static let homeDraftTitle = L10nID("home.draft.title")
    static let homeDraftClear = L10nID("home.draft.clear")
    static let homeDraftClearAccessibilityLabel = L10nID("home.draft.clear.accessibilityLabel")
    static let homeDraftClearAccessibilityHint = L10nID("home.draft.clear.accessibilityHint")
    static let homeSaveSheetTitle = L10nID("home.saveSheet.title")
    static let homeSaveSheetBody = L10nID("home.saveSheet.body")
    static let homeSaveSheetPrivacy = L10nID("home.saveSheet.privacy")
    static let homeSaveSheetPlaceholder = L10nID("home.saveSheet.placeholder")
    static let homeSaveSheetBirthDate = L10nID("home.saveSheet.birthDate")
    static let homeSaveSheetBirthHour = L10nID("home.saveSheet.birthHour")
    static let homeSaveSheetSave = L10nID("home.saveSheet.save")
    static let homeSaveSheetSaveAccessibilityLabel = L10nID("home.saveSheet.save.accessibilityLabel")
    static let homeSaveSheetSaveAccessibilityHint = L10nID("home.saveSheet.save.accessibilityHint")
    static let homeSaveSheetNavigationTitle = L10nID("home.saveSheet.navigation.title")
    static let homeSaveSheetCancel = L10nID("home.saveSheet.cancel")
    static let homeSaveSheetCancelAccessibilityLabel = L10nID("home.saveSheet.cancel.accessibilityLabel")
    static let homeSaveSheetCancelAccessibilityHint = L10nID("home.saveSheet.cancel.accessibilityHint")
    static let homeErrorCalculateFallback = L10nID("home.error.calculateFallback")
    static let homeProfileLoadFailed = L10nID("home.profile.loadFailed")
    static let homeProfileApplied = L10nID("home.profile.applied")
    static let homeProfileDraftApplied = L10nID("home.profile.draftApplied")
    static let homeProfileDefaultName = L10nID("home.profile.defaultName")
    static let homeProfileSaved = L10nID("home.profile.saved")
    static let homeProfileSaveFailed = L10nID("home.profile.saveFailed")

    static let legalPrivacyNavigationTitle = L10nID("legal.privacy.navigation.title")
    static let legalDisclaimerNavigationTitle = L10nID("legal.disclaimer.navigation.title")
    static let legalOpenSourceNavigationTitle = L10nID("legal.openSource.navigation.title")
    static let legalInfoLicense = L10nID("legal.info.license")
    static let legalInfoSource = L10nID("legal.info.source")
    static let legalInfoUsage = L10nID("legal.info.usage")
    static let legalInfoCopyrightNotice = L10nID("legal.info.copyrightNotice")
    static let legalInfoNotice = L10nID("legal.info.notice")
}
