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

func fakeGrade() -> Grade {
    var grade = Grade()
    grade.percentage = 84.0
    grade.letter = "B"
    return grade
}
