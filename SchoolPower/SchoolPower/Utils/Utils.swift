//
//  Utils.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/3/21.
//

import Foundation

class Utils {
    static func saveStringToFile(filename: String, data: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(filename)
            do { try data.write(to: path, atomically: true, encoding: .utf8) }
            catch { print("Failed to save string to file \(filename): \(error)") }
        }
    }
    
    static func readStringFromFile(filename: String) -> String? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(filename)
            do { return try String(contentsOf: path, encoding: .utf8) }
            catch { print("Failed to read string from file \(filename): \(error)") }
        }
        return nil
    }
    
    static func getLocale(
        language: Constants.Language = SettingsStore.shared.language,
        defaultLocale: Locale = Locale.current
    ) -> Locale {
        if language == .systemDefault {
            return defaultLocale
        } else {
            return .init(identifier: Constants.LanguageLocale[language]!)
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
