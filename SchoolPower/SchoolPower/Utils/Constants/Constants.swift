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
    
    public static let websiteURL = "https://schoolpower.tech"
//    public static let supportUsURL = "https://schoolpower.tech/support"
    public static let sourceCodeURL = "https://github.com/schoolpower"
    public static let imageUploadURL = "https://sm.ms/api/v2/upload"
    
    public static let bugReportEmails = [
        "carbonylgp@gmail.com",
        "harryyunull@gmail.com"
    ]
}
