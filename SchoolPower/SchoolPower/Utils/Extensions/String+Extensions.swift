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
            let locale = SettingsStore.shared.language.localeIdentifier ?? "en"
            if let path = Bundle.main.path(forResource: locale, ofType: "lproj") {
                bundle = Bundle(path: path) ?? .main
            } else {
                bundle = .main
            }
        }
        let attempted = NSLocalizedString(
            self,
            tableName: nil,
            bundle: bundle,
            value: "",
            comment: ""
        )
        if self == attempted {
            // Two cases:
            // 1. system default language is English,
            // original string is also (human readable) English (development language).
            // 2. system default language is not supported,
            // original string could be Engligh or a (not human readable) key.
            // In all cases, fallback to English is the desired behaviour
            let locale = "en"
            let path = Bundle.main.path(forResource: locale, ofType: "lproj")
            return NSLocalizedString(
                self,
                tableName: nil,
                bundle: Bundle(path: path!) ?? .main,
                value: "",
                comment: ""
            )
        }
        return attempted
    }
    
    func localized(_ with: CVarArg...) -> String {
        return String(format: self.localized, arguments: with)
    }
    
    func deletedWithMarkup(_ start: String = "<del>", _ end: String = "</del>") -> String {
        replacingOccurrences(of: "(?:\(start))(.*?)(?:\(end))", with: "", options: .regularExpression)
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
