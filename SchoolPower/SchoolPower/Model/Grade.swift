//
//  Grade.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import Foundation
import SwiftUI

struct Grade: Hashable, Codable {
    let percentage: Double
    let letter: String
    
    func color() -> Color {
        return letter.getLetterGradeColor()
    }
}

let fakeGrade = Grade(percentage: 84.0, letter: "B")
