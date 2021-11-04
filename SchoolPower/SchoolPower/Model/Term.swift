//
//  Term.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import Foundation

struct Term: Hashable, Codable, Identifiable {
    let code: String
    let index: Int
    func string() -> String { "\(code)\(index)" }
    internal var id: String { self.string() }
}

let fakeTerm = Term(code: "F", index: 1)
