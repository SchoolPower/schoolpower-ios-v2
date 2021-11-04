//
//  AssignmentDetailView.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-02.
//

import SwiftUI

struct AssignmentDetailView: View {
    var assignment: Assignment
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                InfoItem(
                    leadingCircleText: assignment.grade.letter,
                    label: "Grade",
                    text: assignment.grade.percentage.rounded(digits: 2).asPercentage()
                )
                Divider()
                InfoItem(
                    label: "Score",
                    text: assignment.getMarksForDisplay()
                )
                Divider()
                InfoItem(
                    label: "Date",
                    text: assignment.getDateString()
                )
                Divider()
                InfoItem(
                    label: "Type",
                    text: assignment.category
                )
                if (assignment.weight != nil) {
                    Divider()
                    InfoItem(
                        label: "Weight",
                        text: assignment.weight!.rounded(digits: 1)
                    )
                }
            }
            .padding()
        }
        .navigationTitle(assignment.title)
    }
}

struct AssignmentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentDetailView(assignment: fakeAssignment)
    }
}
