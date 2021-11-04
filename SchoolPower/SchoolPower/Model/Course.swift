//
//  Course.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-02.
//

import Foundation

struct TermGrade: Hashable, Codable, Identifiable {
    let term: Term
    let grade: Grade
    
    internal var id: String { "\(term.id):\(grade.percentage)" }
}

let fakeTermGrade = TermGrade(term: fakeTerm, grade: fakeGrade)

struct Course: Hashable, Codable, Identifiable {
    let name: String
    let instructor: String
    let instructorEmail: String
    let block: String
    let room: String
    let assignments: [Assignment]
    let grades: [TermGrade]
    let startDate: Date
    let endDate: Date
    
    internal var id: String { self.name }
    
    func displayGrade() -> Grade? {
        // TODO
        return grades.first?.grade
    }
}

let fakeCourse: Course = Course(
    name: "Calculus 12",
    instructor: "John Doe",
    instructorEmail: "123@abc.com",
    block: "1(A-E)",
    room: "N-506",
    assignments: [],
    grades: [
        fakeTermGrade
    ],
    startDate: Date.init(),
    endDate: Date.init()
)
