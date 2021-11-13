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
    
    private let refreshHelper = RefreshHelper()
    
    class RefreshHelper {
        var parent: AttendanceView?
        var refreshControl: UIRefreshControl?
        
        @objc func didRefresh() {
            guard let _ = parent, let refreshControl = refreshControl
            else { return }
            StudentDataStore.shared.refresh { success, errorResponse, error in
                refreshControl.endRefreshing()
            }
        }
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(attendances) { attendance in
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
                Text("AAA")
            }
            if attendances.isEmpty {
                if let disabledInfo = disabledInfo {
                    DisabledInfoView(disabledInfo: disabledInfo)
                        .userInteractionDisabled()
                } else {
                    NoAttendanceView()
                        .userInteractionDisabled()
                }
            }
        }
    }
}

struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView(attendances: [fakeAttendance()])
        AttendanceView(attendances: [])
        AttendanceView(attendances: [], disabledInfo: fakeDisabledInfo())
    }
}
