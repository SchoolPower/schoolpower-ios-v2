//
//  Attendance.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-02.
//

import Foundation
import SwiftUI

extension Attendance: Identifiable {
    internal var id: String { "\(courseName):\(code):\(String(date))" }
    
    func color() -> Color {
        return code.getAssignmentCodeColor()
    }
}

func fakeAttendance() -> Attendance {
    var attendance = Attendance()
    attendance.code = "L"
    attendance.courseName = "Calculus 12"
    attendance.comment = "Comments."
    attendance.date = 0
    attendance.description_p = "Late < 5 Minutes Lorem Ipsum Dolar"
    attendance.courseBlock = "1(A-E)"
    return attendance
}
