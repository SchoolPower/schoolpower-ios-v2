//
//  CourseDetailView.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import SwiftUI

struct CourseDetailView: View {
    var course: Course
    
    init(course: Course) {
        self.course = course
        UITableViewCell.appearance().selectionStyle = .gray
    }
    
    var body: some View {
        List {
            Section(header: VStack(alignment: .leading) {
                Text(course.name).font(.largeTitle).bold().foregroundColor(.primary).padding(.bottom).lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                HStack {
                    if (!course.block.isEmpty) {
                        Text("Block").font(.body).opacity(0.6).foregroundColor(.primary)
                        Text(course.block).font(.body).bold().foregroundColor(.primary)
                    }
                    if (!course.room.isEmpty) {
                        Text("Room").font(.body).opacity(0.6).padding(.leading, 8).foregroundColor(.primary)
                        Text(course.room).font(.body).bold().foregroundColor(.primary)
                    }
                }
                Spacer().frame(height: 6).fixedSize()
                HStack {
                    Text("Instructor").font(.body).opacity(0.6).foregroundColor(.primary)
                    Text(course.instructor)
                        .foregroundColor(.primary)
                        .font(.body)
                        .bold()
                }
                
                if (!course.grades.isEmpty) {
                    Text("Grades")
                        .font(.headline)
                        .opacity(0.6)
                        .foregroundColor(.primary)
                        .padding(.top, 16)
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(course.grades) { termGrade in
                                NavigationLink(destination: TermDetailView(termGrade: termGrade, assignments: course.assignments)) {
                                    TermItem(termGrade: termGrade)
                                }
                            }
                        }
                    }
                }
                if (!course.assignments.isEmpty) {
                    Text("Assignments")
                        .font(.headline)
                        .opacity(0.6)
                        .foregroundColor(.primary)
                        .padding(.top, 32)
                }
            }.padding(.leading, -16).padding(.trailing, -16)
            ) {
                ForEach(course.assignments) { assignment in
                    AssignmentItem(assignment: assignment)
                }
            }
            .textCase(nil)
        }
        .accentColor(Color(UIColor.systemGray5))
        .listStyle(.insetGrouped)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CourseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetailView(course: fakeCourse())
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}
