//
//  Int+Extensions.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/28/21.
//

import Foundation

extension Int {
    func ordinal() -> String {
        let ordinalFormatter = NumberFormatter()
        ordinalFormatter.locale = Utils.getLocale()
        ordinalFormatter.numberStyle = .ordinal
        return ordinalFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    func toString() -> String {
        String(self)
    }
}
