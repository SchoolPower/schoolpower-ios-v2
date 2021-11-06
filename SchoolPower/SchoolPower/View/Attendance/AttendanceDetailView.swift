//
//  AttendanceDetailView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/6/21.
//

import SwiftUI

struct AttendanceDetailView: View {
    var attendance: Attendance
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text(attendance.code)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .foregroundColor(attendance.color())
                        )
                    Text(attendance.description_p).font(.largeTitle).bold().padding(.leading)
                }
                Divider()
                InfoItem(
                    label: "Date",
                    text: attendance.date.asMillisDate().formatted()
                )
                Divider()
                InfoItem(
                    label: "Course",
                    text: attendance.courseName
                )
                Divider()
                InfoItem(
                    label: "Block",
                    text: attendance.courseBlock
                )
                if (!attendance.comment.isEmpty) {
                    Divider()
                    InfoItem(
                        label: "Comment",
                        text: attendance.comment
                    )
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AttendanceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceDetailView(attendance: fakeAttendance())
    }
}
