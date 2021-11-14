//
//  Assignment.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import Foundation

extension Assignment: Identifiable, Hashable {
    internal var id: String { "\(self.title):\(getDateString())" }
    
    func trueFlags() -> [String] {
        var result: [String] = []
        for key in flags.keys {
            if flags[key] == true {
                result.append(key)
            }
        }
        return result
    }
    
    func getDateString() -> String {
        date.asMillisDate().formatted()
    }
    
    func getGradeString() -> String {
        if !hasGrade {
            return "--"
        }
        return grade.percentage.rounded(digits: 2).asPercentage()
    }
    
    func getLetter() -> String {
        if !hasGrade {
            return "--"
        }
        return grade.letter
    }
}

func fakeAssignment() -> Assignment {
    var assignment = Assignment()
    assignment.title = "Unit 7 Quiz"
    assignment.date = 0
    assignment.grade = fakeGrade()
    assignment.markForDisplay = "5.0/6.0"
    assignment.category = "Homework"
    assignment.includeInFinalGrade = true
    assignment.weight = 1.0
    assignment.terms = [fakeTermGrade().term]
    assignment.flags = [
        "exempt": true,
        "late": false,
        "missing": true,
        "includeInFinalGrade": true
    ]
    return assignment
}
