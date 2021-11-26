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
    
    func trunc(_ length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length - 1) + trailing : self
    }
}
