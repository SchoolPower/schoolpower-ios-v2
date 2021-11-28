//
//  StudentData.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/9/21.
//

import Foundation

extension StudentData {
    func isValid() -> Bool {
        self.hasProfile || self.hasDisabledInfo || self.hasExtraInfo
    }
}

func fakeStudentData() -> StudentData {
    var studentData = StudentData()
    studentData.profile = fakeProfile()
    studentData.attendances = [fakeAttendance()]
    studentData.courses = [fakeCourse()]
    studentData.extraInfo = fakeExtraInfo()
    return studentData
}
