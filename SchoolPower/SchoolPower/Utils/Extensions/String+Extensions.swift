//
//  String+Extensions.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/25/21.
//

import Foundation

extension String {
    func asPercentage() -> String {
        if (self.hasSuffix("%")) {
            return self
        } else {
            return "\(self)%"
        }
    }
    
    var localized: String {
        var bundle = Bundle.main
        if SettingsStore.shared.language != .systemDefault {
            let locale = Constants.LanguageLocale[
                SettingsStore.shared.language
            ] ?? "en"
            let path = Bundle.main.path(forResource: locale, ofType: "lproj")
            bundle = Bundle(path: path!) ?? Bundle.main
        }
        return NSLocalizedString(
            self,
            tableName: nil,
            bundle: bundle,
            value: "",
            comment: ""
        )
    }
    
    func localized(_ with: CVarArg...) -> String {
        return String(format: self.localized, arguments: with)
    }
    
    func truncate(_ length: Int, trailing: String = "…") -> String {
        return (count > length)
        ? prefix(length - 1) + trailing
        : self
    }
    
    func truncateMiddle(_ length: Int, middle: String = "…") -> String {
        return (count > length)
        ? "\(prefix((length + 1) / 2))\(middle)\(suffix(length / 2))"
        : self
    }
    
    func softBreakEvery(_ tolerate: Int, hardBreak: Int = .max) -> String {
        var broken = ""
        var lastLineLength = 0
        for part in self.split(separator: " ") {
            if part.count < tolerate, lastLineLength + part.count + 1 < hardBreak {
                broken.append(" " + part)
                lastLineLength += part.count + 1
            } else {
                broken.append("\n" + part)
                lastLineLength = part.count
            }
        }
        return broken
    }
}
