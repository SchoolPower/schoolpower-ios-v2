//
//  AttendanceView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/6/21.
//

import SwiftUI
import Introspect

struct AttendanceView: View, ErrorHandler {
    var attendances: [Attendance]
    var disabledInfo: DisabledInfo?
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @State var errorResponse: ErrorResponse? = nil
    @State var showingError: Bool = false
    
    private let refreshHelper = RefreshHelper<AttendanceView>()
    
    private var attendancesToDisplay: [Attendance] {
        disabledInfo != nil ? [] : attendances
    }
    
    
    private var showPlaceholder: Bool {
        disabledInfo != nil || attendancesToDisplay.isEmpty
    }
    
    private var placeholder: some View {
        if let disabledInfo = disabledInfo {
            return AnyView(DisabledInfoView(disabledInfo: disabledInfo).userInteractionDisabled())
        } else {
            return AnyView(NoAttendanceView().userInteractionDisabled())
        }
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(attendancesToDisplay) { attendance in
                        AttendanceItem(attendance: attendance)
                            .background(NavigationLink(
                                destination: AttendanceDetailView(attendance: attendance)
                            ) {}.opacity(0))
                    }
                }
                .withRefresh(parent: self, refreshHelper: refreshHelper)
                .navigationTitle("Attendances")
                if showPlaceholder {
                    placeholder
                } else {
                    NoAttendanceView(imageOnly: true)
                }
            }
            if horizontalSizeClass == .compact {
                if showPlaceholder {
                    placeholder
                }
            }
            AlertIfError(showingAlert: $showingError, errorResponse: $errorResponse)
        }
    }
}

struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView(attendances: [fakeAttendance()])
            .environment(\.locale, .init(identifier: "zh-Hans"))
        AttendanceView(attendances: [])
            .environment(\.locale, .init(identifier: "zh-Hans"))
        AttendanceView(attendances: [fakeAttendance()], disabledInfo: fakeDisabledInfo())
            .environment(\.locale, .init(identifier: "zh-Hans"))
        if #available(iOS 15.0, *) {
            AttendanceView(attendances: [fakeAttendance()], disabledInfo: fakeDisabledInfo())
                .environment(\.locale, .init(identifier: "zh-Hans"))
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
