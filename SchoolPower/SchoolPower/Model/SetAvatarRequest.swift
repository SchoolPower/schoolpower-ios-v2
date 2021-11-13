//
//  SetAvatarRequest.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/13/21.
//

import Foundation

struct SetAvatarResponse: Codable {
    var username: String
    var password: String
    var new_avatar: String
    var remove_code: String
}
