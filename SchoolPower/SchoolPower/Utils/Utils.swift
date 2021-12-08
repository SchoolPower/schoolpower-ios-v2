//
//  Utils.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/3/21.
//

import Foundation
import UIKit

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
        return "\(UIDevice.current.systemName) \(isMacCatalyst() ? "(Mac Catalyst)" : "")"
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
