//
//  Course.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-02.
//

import Foundation

extension Course: Identifiable, Hashable {
    internal var id: String { self.name }
    
    func displayGrade(_ term: Term = .all) -> Grade? {
        let termGrade = grades.first(where: { it in
            term != .all && it.term == term
        }) ?? grades.filter {
            // Do not include "--" grades
            it in it.reallyHasGrade
        }.first
        
        if let termGrade = termGrade, termGrade.reallyHasGrade {
            return termGrade.grade
        }
        
        return nil
    }
    
    func hasGradeInTerm(_ term: Term = .all) -> Bool {
        guard term != .all else { return true }
        return grades.first { it in
            // Include "--" grades
            it.hasGrade && it.term == term
        } != nil
    }
    
    func reallyHasGradeInTerm(_ term: Term = .all) -> Bool {
        guard term != .all else { return true }
        return grades.first { it in
            // Do not nclude "--" grades
            it.reallyHasGrade && it.term == term
        } != nil
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
