//
//  Utils.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/3/21.
//

import Foundation

extension Double {
    func rounded(digits: Int) -> String {
        return String(format: "%.\(digits)f", self)
    }
}

extension String {
    func asPercentage() -> String {
        if (self.hasSuffix("%")) {
            return self
        } else {
            return "\(self)%"
        }
    }
    
    func localized(_ localeString: String) -> String {
        var locale = localeString
        if !Constants.SupportedLocales.contains(localeString) {
            locale = Constants.LanguageLocale[.english]!
        }
        let path = Bundle.main.path(forResource: locale, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

extension Int64 {
    func asMillisDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self) / 1000)
    }
}

extension Date {
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: self)
    }
}

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
    
    static func getLocale(language: Constants.Language, defaultLocale: Locale) -> Locale {
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
}
