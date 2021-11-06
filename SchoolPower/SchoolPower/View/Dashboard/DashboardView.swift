//
//  DashboardView.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import SwiftUI

fileprivate struct CoursesList: View {
    var courses: [Course]
    var body: some View {
        List {
            ForEach(courses) { course in
                DashboardCourseItem(course: course)
                    .background(NavigationLink(
                        destination: CourseDetailView(course: course)
                    ) {}.opacity(0))
                .listRowInsets(EdgeInsets())
            }
        }
        .navigationTitle("Courses")
    }
}

struct DashboardView: View {
    var courses: [Course]
    
    var body: some View {
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
    }
}


extension UISplitViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        preferredDisplayMode = .oneBesideSecondary
        show(.primary)
        
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(courses: [Course](repeating: fakeCourse(), count: 10))
    }
}
