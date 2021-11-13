//
//  DashboardView.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import SwiftUI

fileprivate struct CoursesList: View {
    @EnvironmentObject var settings: SettingsStore
    
    @State var errorResponse: ErrorResponse? = nil
    @State var showingError: Bool = false
    
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
    
    var body: some View {
        ZStack {
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
            AlertIfError(showingAlert: $showingError, errorResponse: $errorResponse)
        }
    }
}

struct DashboardView: View {
    var courses: [Course]
    var disabledInfo: DisabledInfo?
    
    private var coursesToDisplay: [Course] {
        disabledInfo != nil ? [] : courses
    }
    
    private var showPlaceholder: Bool {
        disabledInfo != nil || coursesToDisplay.isEmpty
    }
    
    private var placeholder: some View {
        if let disabledInfo = disabledInfo {
            return AnyView(DisabledInfoView(disabledInfo: disabledInfo))
        } else {
            return AnyView(NoGradesView())
        }
    }
    
    var body: some View {
        switch (UIDevice.current.userInterfaceIdiom) {
        case .pad, .mac:
            NavigationView {
                if showPlaceholder {
                    CoursesList(courses: coursesToDisplay)
                    placeholder
                } else {
                    CoursesList(courses: coursesToDisplay)
                    Text("")
                    Text("")
                }
            }
        default:
            ZStack {
                NavigationView {
                    CoursesList(courses: coursesToDisplay)
                    Text("")
                }
                if showPlaceholder {
                    placeholder
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
        DashboardView(courses: [fakeCourse()], disabledInfo: fakeDisabledInfo())
            .environmentObject(SettingsStore.shared)
    }
}
