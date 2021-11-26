//
//  Term.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/6/21.
//

import Foundation

typealias Term = String

extension Term {
    static let all: Term = "ALL_TERMS"
    
    func displayText() -> String {
        switch (self) {
        case .all:
            return "All terms".localized
        default:
            return self
        }
    }
}
