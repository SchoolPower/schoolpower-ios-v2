//
//  Utils.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/3/21.
//

import Foundation
import UIKit
import StoreKit

class Utils {
    static func getLocale(
        language: Language = SettingsStore.shared.language,
        defaultLocale: Locale = Locale.current
    ) -> Locale {
        if language == .systemDefault {
            return defaultLocale
        } else {
            return .init(identifier: language.localeIdentifier!)
        }
    }
    
    static func getAppVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static func getAppBuild() -> String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    static func getFormattedAppVersionBuild() -> String {
        return "\(getAppVersion() ?? "Unknown Version") (\(getAppBuild() ?? "Unknown Build"))"
    }
    
    static func isMacCatalyst() -> Bool {
        #if targetEnvironment(macCatalyst)
        return true
        #else
        return false
        #endif
    }
    
    static func getOSName() -> String {
        return isMacCatalyst()
        ? "Mac Catalyst"
        : UIDevice.current.systemName
    }
}

// MARK: Dates
extension Utils {
    static func isSameDayAndMonth(_ date1: Date, _ date2: Date) -> Bool {
        let components1 = Calendar.current.dateComponents([.month, .day], from: date1)
        let components2 = Calendar.current.dateComponents([.month, .day], from: date2)
        return components1.month == components2.month &&
        components1.day == components2.day
    }
    
    static func isSameDayAndMonth(_ date1: Date, month: Int, day: Int) -> Bool {
        let components1 = Calendar.current.dateComponents([.month, .day], from: date1)
        return components1.month == month && components1.day == day
    }
    
    static func isLeapYear(_ year: Int) -> Bool {
        let isLeapYear = ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
        return isLeapYear
    }
    
    static func isLeapYear(_ date: Date = Date()) -> Bool {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year], from: date)
        guard let year = components.year else { return false }
        return isLeapYear(year)
    }
}

// MARK: Licenses
extension Utils {
    static var licenses: [License] {
        guard let licensesFilePath = Bundle.main.path(forResource: "licenses", ofType: "json") else {
            print("Failed to locate licenses.json file in bundle.")
            return []
        }
        guard let licensesJSON = try? String(contentsOfFile: licensesFilePath) else {
            print("Failed to read from licenses.json file at \(licensesFilePath).")
            return []
        }
        guard let licensesData = licensesJSON.data(using: .utf8) else {
            print("Failed to read from licenses data from JSON \(licensesJSON).")
            return []
        }
        guard let decodedLicenses = try? JSONDecoder().decode(Licenses.self, from: licensesData) else {
            print("Failed to decode licenses from data. JSON: \(licensesJSON).")
            return []
        }
        return decodedLicenses.licenses
    }
}


// MARK: App Store Review
extension Utils {
    static func maybeRequestAppStoreReview(delaySecond: TimeInterval = 0) {
        guard versionIsDifferntFromLastShown(),
              sinceLastPromptHasElapsedMonths(4),
              sinceLastLoginHasElapsedDays(30),
              sinceLastLoginHasLaunchedAtLeastTimes(10)
        else { return }
        
        guard let scene = UIApplication.shared.firstForgroundActiveScene else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + delaySecond) {
            SKStoreReviewController.requestReview(in: scene)
            SettingsStore.shared.lastShownAppStoreReviewPromptAt = Date()
            SettingsStore.shared
                .lastShownAppStoreReviewPromptAppVersion = getAppVersion() ?? ""
        }
    }
    
    private static func sinceLastLoginHasElapsedDays(_ days: Int) -> Bool {
        let lastLoggedInAt = SettingsStore.shared.lastLoggedInAt
        guard lastLoggedInAt.timeIntervalSince1970 > 0 else { return false }
        
        // 60s * 60min * 24h * days
        let interval = 60 * 60 * 24 * days
        
        let now = Date()
        return now.timeIntervalSince(lastLoggedInAt) > Double(interval)
    }
    
    private static func sinceLastPromptHasElapsedMonths(_ months: Int) -> Bool {
        let lastShownAppStoreReviewPromptAt = SettingsStore.shared.lastShownAppStoreReviewPromptAt
        guard lastShownAppStoreReviewPromptAt.timeIntervalSince1970 > 0 else { return false }
        
        // 60s * 60min * 24h * 30d * months
        let interval = 60 * 60 * 24 * 30 * months
        
        let now = Date()
        return now.timeIntervalSince(lastShownAppStoreReviewPromptAt) > Double(interval)
    }
    
    private static func versionIsDifferntFromLastShown() -> Bool {
        let lastShownAppStoreReviewPromptAppVersion = SettingsStore.shared.lastShownAppStoreReviewPromptAppVersion
        guard !lastShownAppStoreReviewPromptAppVersion.isEmpty else { return true }
        
        let currentVersion = getAppVersion()
        guard let currentVersion = currentVersion, !currentVersion.isEmpty else { return false }
        
        return currentVersion != lastShownAppStoreReviewPromptAppVersion
    }
    
    private static func sinceLastLoginHasLaunchedAtLeastTimes(_ count: Int) -> Bool {
        let appLaunchesCountSinceLastLogin = SettingsStore.shared.appLaunchesCountSinceLastLogin
        return appLaunchesCountSinceLastLogin >= count
    }
}
