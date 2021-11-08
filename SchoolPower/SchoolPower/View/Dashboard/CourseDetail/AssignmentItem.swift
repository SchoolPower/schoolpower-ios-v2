//
//  AssignmentItem.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/3/21.
//

import SwiftUI

struct AssignmentItem: View {
    @State private var selected: Bool = false
    
    var assignment: Assignment
    var selectable: Bool = false
    
    private var gradeColor: Color? {
        selectable && selected ? nil : assignment.grade.color()
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(assignment.title)
                    .font(.body)
                    .lineLimit(1)
                Spacer().frame(height: 6).fixedSize()
                Text(assignment.getDateString())
                    .font(.subheadline)
                    .opacity(0.6)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(assignment.getGradeString())
                    .foregroundColor(gradeColor)
                    .font(.title2)
                    .bold()
                Spacer().frame(height: 6).fixedSize()
                Text(assignment.markForDisplay)
                    .foregroundColor(gradeColor)
                    .font(.caption)
            }
            .frame(width: 100, alignment: .trailing)
        }
        .frame(height: 70)
        .background(
            NavigationLink(
                destination: AssignmentDetailView(assignment: assignment),
                isActive: $selected
            ) {}.opacity(0)
        )
    }
}

struct AssignmentItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AssignmentItem(assignment: fakeAssignment())
        }
        .previewLayout(.fixed(width: 383, height: 80))
    }
}
