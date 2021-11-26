//
//  TermDetail.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-02.
//

import SwiftUI

struct TermDetailView: View {
    var termGrade: TermGrade
    var assignments: [Assignment]
    var body: some View {
        List {
            Section(header: Text(termGrade.term).font(.largeTitle).bold().padding(.bottom).foregroundColor(.primary)) {
                InfoItem(
                    leadingCircleColor: termGrade.grade.color(),
                    leadingCircleText: termGrade.grade.letter,
                    label: "Grade",
                    text: termGrade.reallyHasGrade
                    ? termGrade.grade.percentage.rounded(digits: 2)
                    : "--"
                )
                if !termGrade.evaluation.isEmpty {
                    InfoItem(
                        label: "Evaluation",
                        text: termGrade.evaluation
                    )
                }
                if !termGrade.comment.isEmpty {
                    InfoItem(
                        label: "Comment",
                        text: termGrade.comment
                    )
                }
            }
            if !assignments.isEmpty {
                Section(header: Text("Assignments")
                            .font(.headline)
                            .opacity(0.6)
                            .foregroundColor(.primary)) {
                    ForEach(assignments.filter({ assignment in
                        assignment.terms.contains(termGrade.term)
                    })) { assignment in
                        AssignmentItem(assignment: assignment)
                    }
                }.textCase(nil)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TermDetail_Previews: PreviewProvider {
    static var previews: some View {
        TermDetailView(termGrade: fakeTermGrade(), assignments: [fakeAssignment()])
    }
}
