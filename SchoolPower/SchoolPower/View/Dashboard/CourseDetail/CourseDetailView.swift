//
//  CourseDetailView.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import SwiftUI

struct DynamicCourseDetailView: View {
    @Binding var course: Course?
    var body: some View {
        if let course = course {
            CourseDetailView(course: course)
        }
    }
}

struct CourseDetailView: View {
    var course: Course
    
    init(course: Course) {
        self.course = course
        UITableViewCell.appearance().selectionStyle = .gray
        UILabel
            .appearance(whenContainedInInstancesOf: [UINavigationBar.self])
            .adjustsFontSizeToFitWidth = true
    }
    
    var body: some View {
        List {
            Section(header: VStack(alignment: .leading) {
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
                        HStack {
                            ForEach(course.grades) { termGrade in
                                NavigationLink(destination: TermDetailView(termGrade: termGrade, assignments: course.assignments)) {
                                    TermItem(termGrade: termGrade)
                                }
                                .buttonStyle(.plain)
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
            }.padding(.horizontal, -16)
            ) {
                ForEach(course.assignments) { assignment in
                    AssignmentItem(assignment: assignment)
                }
            }
            .textCase(nil)
        }
        .accentColor(Color(UIColor.systemGray5))
        .listStyle(.insetGrouped)
        .navigationBarTitle(course.name, displayMode: .large)
    }
}

struct CourseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetailView(course: fakeCourse())
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}
