//
//  DashboardView.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import SwiftUI

fileprivate struct CoursesList: View {
    @EnvironmentObject var settings: SettingsStore
    
    var courses: [Course]
    
    private var coursesToDisplay: [Course] {
        if !settings.showInactiveCourses {
            return courses.filter { course in
                !course.grades.isEmpty || !course.assignments.isEmpty
            }
        }
        return courses
    }
    
    private let refreshHelper = RefreshHelper()
    
    class RefreshHelper {
        var parent: CoursesList?
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
        List {
            ForEach(coursesToDisplay) { course in
                DashboardCourseItem(course: course)
                    .background(NavigationLink(
                        destination: CourseDetailView(course: course)
                    ) {}.opacity(0))
                    .listRowInsets(EdgeInsets())
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
        .navigationTitle("Courses")
    }
}

struct DashboardView: View {
    var courses: [Course]
    var disabledInfo: DisabledInfo?
    
    var body: some View {
        ZStack {
            switch (UIDevice.current.userInterfaceIdiom) {
            case .pad, .mac:
                NavigationView {
                    CoursesList(courses: courses)
                    Text("AAA")
                    Text("BBB")
                }
            default:
                NavigationView {
                    CoursesList(courses: courses)
                    Text("AAA")
                }
            }
            if courses.isEmpty {
                if let disabledInfo = disabledInfo {
                    DisabledInfoView(disabledInfo: disabledInfo)
                        .userInteractionDisabled()
                } else {
                    NoGradesView()
                        .userInteractionDisabled()
                }
            }
        }
    }
}


extension UISplitViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        preferredDisplayMode = .oneBesideSecondary
        preferredSplitBehavior = .tile
        show(.primary)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(courses: [Course](repeating: fakeCourse(), count: 10))
            .environmentObject(SettingsStore.shared)
        DashboardView(courses: [])
            .environmentObject(SettingsStore.shared)
        DashboardView(courses: [], disabledInfo: fakeDisabledInfo())
            .environmentObject(SettingsStore.shared)
    }
}
