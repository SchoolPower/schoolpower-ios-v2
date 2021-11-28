//
//  GetDataAction.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/28/21.
//

enum GetDataAction: String, CaseIterable {
    case manual = "user_triggered"
    case job = "job_triggered"
    case login = "login"
    case getAvatar = "get_avatar"
}
