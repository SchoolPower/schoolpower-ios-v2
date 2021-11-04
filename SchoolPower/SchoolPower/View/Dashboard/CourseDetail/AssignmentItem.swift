//
//  AssignmentItem.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/3/21.
//

import SwiftUI

struct AssignmentItem: View {
    var assignment: Assignment
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(assignment.title)
                    .foregroundColor(.primary)
                    .font(.body)
                    .bold()
                Spacer().frame(height: 6).fixedSize()
                Text(assignment.getDateString())
                    .foregroundColor(.primary)
                    .font(.subheadline)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(assignment.grade.percentage.rounded(digits: 2).asPercentage())
                    .foregroundColor(.purple)
                    .font(.title2)
                    .bold()
                Spacer().frame(height: 6).fixedSize()
                Text(assignment.getMarksForDisplay())
                    .foregroundColor(.purple)
                    .font(.caption)
            }
        }
        .frame(height: 70)
    }
}

struct AssignmentItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AssignmentItem(assignment: fakeAssignment)
        }
        .previewLayout(.fixed(width: 383, height: 80))
    }
}
