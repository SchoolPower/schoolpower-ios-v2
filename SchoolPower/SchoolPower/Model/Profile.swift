//
//  Profile.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-02.
//

import Foundation

struct Profile: Hashable, Codable {
    let GPA: Double?
    let id: Int64
    let gender: Gender
    let dob: Date
    let firstName: String
    let middleName: String
    let lastName: String
    let photoDate: Date
    
    func fullName() -> String { "\(lastName), \(firstName) \(middleName)" }
}
