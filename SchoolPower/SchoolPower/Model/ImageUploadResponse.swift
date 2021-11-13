//
//  ImageUploadResponse.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/13/21.
//

import Foundation

struct ImageUploadResponse: Codable {
    struct Data: Codable {
        var url: String
        var hash: String
    }

    var success: Bool
    var code: String?
    var data: Data?
    var images: String?
}
