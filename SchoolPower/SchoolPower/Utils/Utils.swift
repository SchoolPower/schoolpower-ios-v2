//
//  Utils.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/3/21.
//

import Foundation

extension Double {
    func rounded(digits: Int) -> String {
        return String(format: "%.\(digits)f", self)
    }
}

extension String {
    func asPercentage() -> String {
        if (self.hasSuffix("%")) {
            return self
        } else {
            return "\(self)%"
        }
    }
}
