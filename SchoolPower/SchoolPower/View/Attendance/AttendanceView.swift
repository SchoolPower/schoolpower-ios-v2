//
//  AttendanceView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/6/21.
//

import SwiftUI
import Introspect

struct AttendanceView: View {
    var attendances: [Attendance]
    var disabledInfo: DisabledInfo?
    
    @State var errorResponse: ErrorResponse? = nil
    @State var showingError: Bool = false
    
    private var attendancesToDisplay: [Attendance] {
        disabledInfo != nil ? [] : attendances
    }
    
    private let refreshHelper = RefreshHelper()
    
    class RefreshHelper {
        var parent: AttendanceView?
        var refreshControl: UIRefreshControl?
        
        @objc func didRefresh() {
            guard let parent = parent, let refreshControl = refreshControl
            else { return }
            StudentDataStore.shared.refresh { success, errorResponse, error in
                refreshControl.endRefreshing()
                if success {
                    
                } else {
                    parent.errorResponse = errorResponse
                    ?? ErrorResponse(
                        title: "Failed to refresh data",
                        description: error ?? "Unknown Error"
                    )
                    parent.showingError = true
                }
            }
        }
    }
    
    private var showPlaceholder: Bool {
        disabledInfo != nil || attendancesToDisplay.isEmpty
    }
    
    private var placeholder: some View {
        if let disabledInfo = disabledInfo {
            return AnyView(DisabledInfoView(disabledInfo: disabledInfo))
        } else {
            return AnyView(NoAttendanceView())
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
                .introspectTableView { tableView in
                    guard tableView.refreshControl == nil else { return }
                    let control = UIRefreshControl()
                    refreshHelper.parent = self
                    refreshHelper.refreshControl = control
                    control.addTarget(refreshHelper, action: #selector(RefreshHelper.didRefresh), for: .valueChanged)
                    tableView.refreshControl = control
                }
                .navigationTitle("Attendances")
                if showPlaceholder {
                    placeholder
                } else {
                    Text("")
                }
            }
            if UIDevice.current.userInterfaceIdiom == .phone {
                if let disabledInfo = disabledInfo {
                    DisabledInfoView(disabledInfo: disabledInfo)
                        .userInteractionDisabled()
                } else if attendancesToDisplay.isEmpty {
                    NoAttendanceView()
                        .userInteractionDisabled()
                }
            }
            AlertIfError(showingAlert: $showingError, errorResponse: $errorResponse)
        }
    }
}

struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView(attendances: [fakeAttendance()])
        AttendanceView(attendances: [])
        AttendanceView(attendances: [fakeAttendance()], disabledInfo: fakeDisabledInfo())
    }
}
