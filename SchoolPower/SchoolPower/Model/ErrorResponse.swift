//
//  ErrorResponse.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/7/21.
//

import Foundation

struct ErrorResponse: Codable {
    var success: Bool?
    var title: String?
    var description: String?
    var code: Int?
    var code2: Int?
    
    var hasErrorMessage: Bool {
        let hasTitle = title?.isEmpty == false
        let hasDescription = description?.isEmpty == false
        return hasTitle || hasDescription
    }
}
