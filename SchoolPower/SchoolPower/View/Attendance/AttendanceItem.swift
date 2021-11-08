//
//  AttendanceItem.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/6/21.
//

import SwiftUI

struct AttendanceItem: View {
    var attendance: Attendance
    var body: some View {
        HStack {
            Text(attendance.code)
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .background(
                    Circle()
                        .foregroundColor(attendance.color())
                )
            Spacer().frame(width: 16).fixedSize()
            VStack(alignment: .leading) {
                Text(attendance.description_p)
                    .foregroundColor(.primary)
                    .font(.body)
                    .bold()
                Spacer().frame(height: 6).fixedSize()
                Text(attendance.courseName)
                    .foregroundColor(.primary)
                    .font(.footnote)
                Text(attendance.date.asMillisDate().formatted())
                    .foregroundColor(.primary)
                    .font(.footnote)
            }
        }
        .padding(.top)
        .padding(.bottom)
    }
}

struct AttendanceItem_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceItem(attendance: fakeAttendance())
        .previewLayout(.fixed(width: 383, height: 90))
    }
}

