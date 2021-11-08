//
//  LoginData.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/5/21.
//

import Foundation

struct RequestData: Codable {
    var username: String = ""
    var password: String = ""
    
    var isEmpty : Bool {
        username.isEmpty || password.isEmpty
    }
}

