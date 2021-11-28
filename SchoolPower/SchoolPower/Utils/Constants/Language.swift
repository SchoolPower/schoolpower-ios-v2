//
//  Language.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/28/21.
//

enum Language: String, CaseIterable {
    case systemDefault = "System Default"
    case english = "English"
    case chineseSimplified = "简体中文"
    case chineseTraditional = "繁体中文"
    case japanese = "日本語"
}

fileprivate let localeIdentifierByLanguage: [Language: String] = [
    .english: "en",
    .chineseSimplified: "zh-Hans",
    .chineseTraditional: "zh-Hant",
    .japanese: "ja"
]

extension Language {
    var localeIdentifier: String? {
        localeIdentifierByLanguage[self]
    }
}
