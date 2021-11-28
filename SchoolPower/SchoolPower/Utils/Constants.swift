//
//  Constants.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/6/21.
//

import Foundation

class Constants {
    public static let serverBaseURL = "https://api-fc.schoolpower.tech/v3"
    public static var getStudentDataURL: String { "\(serverBaseURL)/get_data" }
    public static var registerAPNSDeviceTokenURL: String { "\(serverBaseURL)/register_device" }
    public static var setAvatarURL: String { "\(serverBaseURL)/set_avatar" }
    
    public static let bugReportEmails = [
        "carbonylgp@gmail.com",
        "harryyunull@gmail.com"
    ]
    
    public static let websiteURL = "https://schoolpower.tech"
    public static let sourceCodeURL = "https://github.com/schoolpower"
    public static let imageUploadURL = "https://sm.ms/api/v2/upload"
    
    enum Language: String, CaseIterable {
        case systemDefault = "System Default"
        case english = "English"
        case chineseSimplified = "简体中文"
        case chineseTraditional = "繁体中文"
        case japanese = "日本語"
    }
    
    enum GetDataAction: String, CaseIterable {
        case manual = "user_triggered"
        case job = "pull_data_job"
        case login = "login"
        case getAvatar = "get_avatar"
    }
    
    public static let LanguageLocale: [Language: String] = [
        .english: "en",
        .chineseSimplified: "zh-Hans",
        .chineseTraditional: "zh-Hant",
        .japanese: "ja"
    ]
}
