//
//  Array+Extensions.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/25/21.
//

import Foundation

extension Array where Element: BinaryInteger {
    var average: Double {
        if self.isEmpty {
            return 0.0
        } else {
            let sum = self.reduce(0, +)
            return Double(sum) / Double(self.count)
        }
    }

}

extension Array where Element: BinaryFloatingPoint {
    var average: Double {
        if self.isEmpty {
            return 0.0
        } else {
            let sum = self.reduce(0, +)
            return Double(sum) / Double(self.count)
        }
    }
}

extension Array where Element == Course {
    func filterHasGrades(_ term: Term = .all) -> [Course] {
        self.filter { it in it.hasGradeInTerm(term) }
    }
    func filterReallyHasGrades(_ term: Term = .all) -> [Course] {
        self.filter { it in it.reallyHasGradeInTerm(term) }
    }
    func mapToIds() -> [String] {
        self.map { it in it.id }
    }
}
