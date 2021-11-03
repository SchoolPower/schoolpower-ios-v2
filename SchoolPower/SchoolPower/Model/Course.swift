//
//  Course.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-02.
//

import Foundation

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
    
    struct TermGrade: Hashable, Codable, Identifiable {
        let term: Term
        let grade: Grade
        
        internal var id: String { "\(term.id):\(grade.percentage)" }
    }
}
