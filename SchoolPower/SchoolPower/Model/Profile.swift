//
//  Profile.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-02.
//

import Foundation

extension Profile: Hashable {
    func fullName() -> String { "\(lastName), \(firstName) \(middleName)" }
}

func fakeProfile() -> Profile {
    var profile = Profile()
    profile.firstName = "John"
    profile.lastName = "Doe"
    profile.middleName = "von"
    profile.dob = 0
    profile.gender = Profile.Gender.male
    profile.gpa = 84.625
    profile.id = 19050069
    return profile
}
