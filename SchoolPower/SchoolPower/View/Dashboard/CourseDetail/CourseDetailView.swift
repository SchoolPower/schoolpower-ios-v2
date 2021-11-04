//
//  CourseDetailView.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import SwiftUI

struct CourseDetailView: View {
    var course: Course
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Block").font(.body).opacity(0.6).foregroundColor(.primary)
                    Text(course.block).font(.body).bold().foregroundColor(.primary)
                    Text("Room").font(.body).opacity(0.6).padding(.leading, 8).foregroundColor(.primary)
                    Text(course.room).font(.body).bold().foregroundColor(.primary)
                }
                Spacer().frame(height: 6).fixedSize()
                HStack {
                    Text("Instructor").font(.body).opacity(0.6).foregroundColor(.primary)
                    Text(course.instructor)
                        .foregroundColor(.primary)
                        .font(.body)
                        .bold()
                }
                Text("Grades")
                    .font(.headline)
                    .opacity(0.6)
                    .foregroundColor(.primary)
                    .padding(.top, 16)
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(1..<10) { _ in
                            NavigationLink(destination: TermDetailView()) {
                                TermItem(termGrade: fakeTermGrade)
                            }
                        }
                    }
                }
                Text("Assignments")
                    .font(.headline)
                    .opacity(0.6)
                    .foregroundColor(.primary)
                    .padding(.top, 32)
                LazyVStack {
                    ForEach(1..<10) { _ in
                        NavigationLink(
                            destination: AssignmentDetailView(assignment: fakeAssignment)
                        ) {
                            AssignmentItem(assignment: fakeAssignment)
                        }
                        Divider()
                    }
                }
            }
            .padding()
        }
        .navigationTitle(course.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct CourseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetailView(course: fakeCourse)
    }
}
