//
//  AssignmentDetailView.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-02.
//

import SwiftUI

struct AssignmentDetailView: View {
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
                    label: "Score",
                    text: "5.0 / 6.0"
                )
                Divider()
                InfoItem(
                    label: "Date",
                    text: "2021/10/31"
                )
                Divider()
                InfoItem(
                    label: "Type",
                    text: "Homework"
                )
                Divider()
                InfoItem(
                    label: "Weight",
                    text: "1.0"
                )
            }
            .padding()
        }
        .navigationTitle("Unit 7 Quiz")
    }
}

struct AssignmentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentDetailView()
    }
}
