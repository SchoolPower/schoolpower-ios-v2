//
//  Assignment.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import Foundation

struct Assignment: Hashable, Codable, Identifiable {
    let title: String
    let date: Date
    let grade: Grade
    let mark: Double?
    let fullMark: Double?
    let category: String
    let includeInFinalGrade: Bool
    let weight: Double?
    let terms: Set<Term>
    let flags: [String: Bool]
    
    internal var id: String { self.title }
    
    
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    func getMarksForDisplay() -> String {
        markString() + "/" + fullMarkString()
    }

    private func markString() -> String {
        mark?.rounded(digits: 2) ?? "--"
    }
    private func fullMarkString() -> String {
        fullMark?.rounded(digits: 2) ?? "--"
    }
}

let fakeAssignment = Assignment(title: "Unit 7 Quiz", date: Date.init(), grade: Grade(percentage: 84.0, letter: "B"), mark: 5.0, fullMark: 6.0, category: "Homework", includeInFinalGrade: true, weight: 1.0, terms: Set(), flags: [:])

