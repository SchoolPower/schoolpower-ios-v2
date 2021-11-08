//
//  TermGrade.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/5/21.
//

import Foundation

extension TermGrade: Identifiable, Hashable {
    internal var id: String { "\(term):\(grade)" }
}

func fakeTermGrade() -> TermGrade {
    var termGrade = TermGrade()
    termGrade.term = "F1"
    termGrade.grade = fakeGrade()
    termGrade.evaluation = "M(Good)"
    termGrade.comment = "Good."
    return termGrade
}
