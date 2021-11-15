//
//  Colors.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/3/21.
//

import Foundation
import SwiftUI

fileprivate let letterGradeToColor: [String: Color] = [
    "A": .A_score_green,
    "B": .B_score_green,
    "C+": .Cp_score_yellow,
    "C": .C_score_orange,
    "C-": .Cm_score_red,
    "F": .F_score_purple,
    "I": .F_score_purple,
]

fileprivate let assignmentCodeToColor: [String: Color] = [
    "A": .primary_dark,
    "E": .A_score_green_dark,
    "L": .Cp_score_yellow,
    "R": .Cp_score_yellow_dark,
    "H": .C_score_orange_dark,
    "T": .C_score_orange,
    "S": .F_score_purple,
    "I": .Cm_score_red,
    "X": .A_score_green,
    "M": .Cm_score_red_dark,
    "C": .B_score_green_dark,
    "D": .B_score_green,
    "P": .A_score_green,
    "NR": .C_score_orange,
    "TW": .F_score_purple,
    "RA": .Cp_score_yellow_darker,
    "NE": .Cp_score_yellow_light,
    "U": .Cp_score_yellow_lighter,
    "RS": .primary_light,
    "ISS": .F_score_purple,
    "FT": .B_score_green_dark
]

extension Optional where Wrapped == String {
    func getLetterGradeColor() -> Color {
        switch self {
        case .none:
            return .F_score_purple
        case .some(let wrapped):
            return wrapped.getLetterGradeColor()
        }
    }
}

extension String {
    func getLetterGradeColor() -> Color {
        return letterGradeToColor[self] ?? .F_score_purple
    }
    
    func getAssignmentCodeColor() -> Color {
        return assignmentCodeToColor[self] ?? .F_score_purple
    }
}

public extension UIColor {
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F", "F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
}

public extension Color {
    init?(hexString: String?) {
        guard let hexString = hexString,
              let uiColor = UIColor(hexString: hexString) else { return nil }
        self.init(uiColor)
    }
    
    func uiColor() -> UIColor {
        return UIColor(self)
    }
}

extension Color {
    public static let surface: Color = Color(UIColor.systemGroupedBackground)
    
    public static let A_score_green = Color(hexString: "#00796B")!
    public static let A_score_green_dark = Color(hexString: "#006156")!
    public static let B_score_green = Color(hexString: "#388E3C")!
    public static let B_score_green_dark = Color(hexString: "#2D7230")!
    public static let Cp_score_yellow_lighter = Color(hexString: "#ffd180")!
    public static let Cp_score_yellow_light = Color(hexString: "#ffd740")!
    public static let Cp_score_yellow = Color(hexString: "#ffb300")!
    public static let Cp_score_yellow_dark = Color(hexString: "#cc8f00")!
    public static let Cp_score_yellow_darker = Color(hexString: "#827717")!
    public static let C_score_orange = Color(hexString: "#FF5722")!
    public static let C_score_orange_dark = Color(hexString: "#cc461b")!
    public static let Cm_score_red = Color(hexString: "#D32F2F")!
    public static let Cm_score_red_dark = Color(hexString: "#a92626")!
    public static let F_score_purple = Color(hexString: "#9c27b0")!
    public static let primary_light = Color(hexString: "#EEEEEE")!
    public static let primary_dark = Color(hexString: "#07263b")!
    public static let primary_darker = Color(hexString: "#061d2f")!
    public static let accent = Color(hexString: "#00c4cf")!
    public static let foreground_material_dark = Color(hexString: "#eeeeee")!
    public static let text_primary_black = Color(hexString: "#383838")!
    public static let text_secondary_black = Color(hexString: "#787878")!
    public static let text_tertiary_black = Color(hexString: "#909090")!
    public static let cardview_dark_background = Color(hexString: "#424242")!
    public static let nothing_light = Color(hexString: "#FAFAFA")!
}
