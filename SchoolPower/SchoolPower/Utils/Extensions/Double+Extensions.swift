//
//  Double+Extensions.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/25/21.
//

import Foundation

extension Double {
    func rounded(digits: Int) -> String {
        return String(format: "%.\(digits)f", self)
    }
    
    func normalizePercentage() -> Double {
        return self / 100
    }
    
    func denormalizePercentage() -> Double {
        return self * 100
    }
    
    func toLetterGrade() -> String {
        return letterByPercentageGrade[self] ?? "--"
    }
}

fileprivate let letterByPercentageGrade : [Range<Double>: String] = [
    -.infinity  ..< 50:         "F",
     50         ..< 60:         "C-",
     60         ..< 67:         "C",
     67         ..< 73:         "C+",
     73         ..< 86:         "B",
     86         ..< .infinity:  "A",
]

fileprivate extension Dictionary where Key == Range<Double> {
    subscript(_ rawValue: Double) -> Value? {
        for k in self.keys {
            if k ~= rawValue {
                return self[k]
            }
        }
        return nil
    }
}
