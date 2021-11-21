//
//  NoAttendanceView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/12/21.
//

import SwiftUI

struct NoAttendanceView: View {
    @Environment(\.colorScheme) var colorScheme
    var imageOnly: Bool? = nil
    
    var image: Image {
        colorScheme == .dark ? Image("perfect_attendance_dark") : Image("perfect_attendance")
    }
    
    var body: some View {
        PlaceholderInfoView(title: imageOnly == true ? nil : "Perfect attendance", message: nil, image: image, opacity: 0.8)
    }
}

struct NoAttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        NoAttendanceView()
        NoAttendanceView()
            .preferredColorScheme(.dark)
    }
}
