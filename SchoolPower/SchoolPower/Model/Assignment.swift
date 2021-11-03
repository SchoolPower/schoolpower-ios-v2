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
}

