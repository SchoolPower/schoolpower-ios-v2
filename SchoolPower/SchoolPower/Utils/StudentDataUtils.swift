//
//  StudentDataUtils.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/7/21.
//

import Foundation

class StudentDataUtils {
    // M: old size
    // N: new size
    // Time: O(M + N)
    // Space: O(M + N)
    static func diff(
        oldData: StudentData,
        newData: StudentData
    ) -> (
        newAssignments: [Assignment],
        newAttendences: [Attendance]
    ) {
        let oldAssignments = Set(oldData.courses.flatMap({ it in it.assignments}))
        
        // We can't assume title + date will be unique
        let oldIdToAssignments = Dictionary(grouping: oldAssignments) { it in it.id }
        
        let oldAttendances = Set(oldData.attendances)
        
        var newAssignments: [Assignment] = []
        var newAttendences: [Attendance] = []
        
        for newAssignment in newData.courses.flatMap({ it in it.assignments}) {
            guard !oldAssignments.contains(newAssignment) else { continue }
            if let oldAssignmentsWithSameId = oldIdToAssignments[newAssignment.id] {
                // Take the first one in case there is "ID" collision
                if let oldAssignmentWithSameId = oldAssignmentsWithSameId.first {
                    let newHasGrade = newAssignment.hasGrade
                    let oldHasNoGrade = !oldAssignmentWithSameId.hasGrade
                    let gradeChanged = newAssignment.grade != oldAssignmentWithSameId.grade
                    if newHasGrade && (oldHasNoGrade || gradeChanged) {
                        newAssignments.append(newAssignment)
                    }
                }
            } else {
                newAssignments.append(newAssignment)
            }
        }
        
        for newAttendence in newData.attendances {
            guard !oldAttendances.contains(newAttendence) else { continue }
            newAttendences.append(newAttendence)
        }
        
        return (newAssignments, newAttendences)
    }
}
