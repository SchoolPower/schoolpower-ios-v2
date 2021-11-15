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
    var horizontalSizeClass: UserInterfaceSizeClass?
    
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
                        description: error ?? "Unknown error."
                    )
                    parent.showingError = true
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            if horizontalSizeClass == .regular {
                
                List {
                    InfoCard()
                    ForEach(coursesToDisplay) { course in
                        DashboardCourseItem(course: course)
                            .background(NavigationLink(
                                destination: CourseDetailView(course: course)
                            ) {}.opacity(0))
                            .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(.sidebar)
                .listRowInsets(EdgeInsets())
                .introspectTableView { tableView in
                    guard tableView.refreshControl == nil else { return }
                    let control = UIRefreshControl()
                    refreshHelper.parent = self
                    refreshHelper.refreshControl = control
                    control.addTarget(refreshHelper, action: #selector(RefreshHelper.didRefresh), for: .valueChanged)
                    tableView.refreshControl = control
                }
                .navigationTitle("Courses")
            } else {
                List {
                    Section {
                        InfoCard()
                    }
                    .padding(0)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color(.systemGroupedBackground))
                    Section {
                        ForEach(coursesToDisplay) { course in
                            DashboardCourseItem(course: course)
                                .background(NavigationLink(
                                    destination: CourseDetailView(course: course)
                                ) {}.opacity(0))
                                .listRowInsets(EdgeInsets())
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .listRowInsets(EdgeInsets())
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
            AlertIfError(showingAlert: $showingError, errorResponse: $errorResponse)
        }
    }
}

struct DashboardView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
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
            return AnyView(DisabledInfoView(disabledInfo: disabledInfo).userInteractionDisabled())
        } else {
            return AnyView(NoGradesView().userInteractionDisabled())
        }
    }
    
    var body: some View {
        ZStack {
            switch (UIDevice.current.userInterfaceIdiom) {
            case .pad:
                NavigationView {
                    if showPlaceholder {
                        CoursesList(courses: coursesToDisplay, horizontalSizeClass: horizontalSizeClass)
                        placeholder
                    } else {
                        CoursesList(courses: coursesToDisplay, horizontalSizeClass: horizontalSizeClass)
                        Text("")
                        Text("")
                    }
                }
            default:
                NavigationView {
                    CoursesList(courses: coursesToDisplay, horizontalSizeClass: horizontalSizeClass)
                    if showPlaceholder {
                        placeholder
                    } else {
                        Text("")
                    }
                }
            }
            if horizontalSizeClass == .compact {
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
            .environment(\.locale, .init(identifier: "ja"))
        DashboardView(courses: [])
            .environmentObject(SettingsStore.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
        DashboardView(courses: [fakeCourse()], disabledInfo: fakeDisabledInfo())
            .environmentObject(SettingsStore.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
        if #available(iOS 15.0, *) {
            DashboardView(courses: [fakeCourse()], disabledInfo: fakeDisabledInfo())
                .environmentObject(SettingsStore.shared)
                .environment(\.locale, .init(identifier: "zh-Hans"))
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
