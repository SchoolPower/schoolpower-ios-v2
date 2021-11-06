//
//  AttendanceView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/6/21.
//

import SwiftUI

struct AttendanceView: View {
    var attendances: [Attendance]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(attendances) { attendance in
                    AttendanceItem(attendance: attendance)
                        .background(NavigationLink(
                        destination: AttendanceDetailView(attendance: attendance)
                    ) {}.opacity(0))
                }
            }
            .navigationTitle("Attendances")
        }
    }
}

struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView(attendances: [fakeAttendance()])
    }
}
