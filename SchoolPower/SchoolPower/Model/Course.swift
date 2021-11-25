//
//  Course.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-02.
//

import Foundation

extension Course: Identifiable, Hashable {
    internal var id: String { self.name }
    
    func displayGrade() -> Grade? {
        // TODO
        return grades.first?.grade
    }
    
    func toScheduleEventId(with schedule: Course.Schedule) -> String {
        "\(id)::\(schedule.id)"
    }
    
    static func idFromScheduleEventId(_ scheduleEventId: String) -> String? {
        return scheduleEventId.components(separatedBy: "::").first
    }
}


extension Course.Schedule: Identifiable, Hashable {
    var id: String {
        "\(startTime):\(endTime)"
    }
}

func fakeCourse() -> Course {
    var course = Course()
    course.name = "Calculus 12"
    course.instructor = "John Doe"
    course.instructorEmail = "123@abc.com"
    course.block = "1(A-E)"
    course.room = "N-506"
    course.assignments = [fakeAssignment()]
    course.grades = [fakeTermGrade(),fakeTermGrade(),fakeTermGrade(),fakeTermGrade()]
    course.startDate = 0
    course.endDate = 0
    return course
}
