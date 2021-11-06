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
                Text(assignment.title).font(.largeTitle).bold().padding(.bottom)
                InfoItem(
                    leadingCircleColor: assignment.grade.color(),
                    leadingCircleText: assignment.getLetter(),
                    label: "Grade",
                    text: assignment.getGradeString()
                )
                Divider()
                InfoItem(
                    label: "Score",
                    text: assignment.markForDisplay
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
                if (assignment.weight > 0) {
                    Divider()
                    InfoItem(
                        label: "Weight",
                        text: assignment.weight.rounded(digits: 1)
                    )
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AssignmentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentDetailView(assignment: fakeAssignment())
    }
}
