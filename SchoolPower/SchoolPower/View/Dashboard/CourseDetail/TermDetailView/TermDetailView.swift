//
//  TermDetail.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-02.
//

import SwiftUI

struct TermDetailView: View {
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                InfoItem(
                    leadingCircleText: "B",
                    label: "Grade",
                    text: "83.33%"
                )
                Divider()
                InfoItem(
                    label: "Evaluation",
                    text: "M (Meeting Expectation)"
                )
                Divider()
                InfoItem(
                    label: "Comment",
                    text: "Student’s progress in class is satisfactory. Loren ipsum sit amet."
                )
                Divider()
                Text("Assignments")
                    .font(.headline)
                    .opacity(0.6)
                    .foregroundColor(.primary)
                    .padding(.top, 32)
                LazyVStack {
                    ForEach(1..<10) { _ in
                        NavigationLink(destination: AssignmentDetailView()) {
                            AssignmentItem()
                        }
                        Divider()
                    }
                }
            }
            .padding()
        }
        .navigationTitle("F1")
    }
}

struct TermDetail_Previews: PreviewProvider {
    static var previews: some View {
        TermDetailView()
    }
}
