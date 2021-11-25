//
//  Grade.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import Foundation
import SwiftUI


extension Grade: Hashable {
    func color() -> Color {
        return letter.getLetterGradeColor()
    }
}

extension Optional where Wrapped == Grade {
    func color() -> Color {
        return (self?.letter).getLetterGradeColor()
    }
}

extension Double {
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


func fakeGrade() -> Grade {
    var grade = Grade()
    grade.percentage = 84.0
    grade.letter = "B"
    return grade
}
