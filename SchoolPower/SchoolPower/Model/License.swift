//
//  License.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/14/21.
//

import Foundation

struct License: Codable, Identifiable {
    var libraryName: String
    var text: String
    var id: String {
        libraryName
    }
}

struct Licenses: Codable {
    var licenses: [License]
}
