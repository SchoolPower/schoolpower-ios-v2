//
//  Attendance.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-02.
//

import Foundation

struct Attendance: Hashable, Codable, Identifiable {
    let code: String
    let date: Date
    let description: String
    let courseName: String
    let courseBlock: String
    
    internal var id: String { "\(courseName):\(code):\(String(date.timeIntervalSince1970))" }
}
