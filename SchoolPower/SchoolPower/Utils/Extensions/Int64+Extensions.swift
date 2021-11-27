//
//  Int64+Extensions.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/25/21.
//

import Foundation

extension Int64 {
    func asMillisDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self) / 1000)
    }
}
