//
//  DashboardView.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import SwiftUI

struct DashboardView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @ObservedObject private var viewModel: DashboardViewModel
    
    init(courses: [Course], disabledInfo: DisabledInfo? = nil) {
        viewModel = DashboardViewModel(
            courses: courses,
            disabledInfo: disabledInfo
        )
    }
    
    var coursesList: some View {
        CoursesListView(
            viewModel: viewModel,
            horizontalSizeClass: horizontalSizeClass
        )
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                coursesList
                if viewModel.showPlaceholder {
                    viewModel.placeholder
                } else {
                    NoGradesView(imageOnly: true)
                }
            }
            .introspect(.navigationSplitView, on: .iOS(.v16, .v17, .v18)) { svc in
                svc.minimumPrimaryColumnWidth = 300
                svc.maximumPrimaryColumnWidth = .infinity
                svc.preferredPrimaryColumnWidthFraction = 0.4
            }
            if horizontalSizeClass == .compact,
               viewModel.showPlaceholder,
               !InfoCardStore.shared.shouldShowInfoCard {
                viewModel.placeholder
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(courses: [Course](repeating: fakeCourse(), count: 10))
            .environmentObject(SettingsStore.shared)
            .environmentObject(InfoCardStore.shared)
            .environmentObject(StudentDataStore.shared)
            .environment(\.locale, .init(identifier: "ja"))
        DashboardView(courses: [])
            .environmentObject(SettingsStore.shared)
            .environmentObject(InfoCardStore.shared)
            .environmentObject(StudentDataStore.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
        DashboardView(courses: [fakeCourse()], disabledInfo: fakeDisabledInfo())
            .environmentObject(SettingsStore.shared)
            .environmentObject(InfoCardStore.shared)
            .environmentObject(StudentDataStore.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
        if #available(iOS 15.0, *) {
            DashboardView(courses: [fakeCourse()], disabledInfo: fakeDisabledInfo())
                .environmentObject(SettingsStore.shared)
                .environmentObject(StudentDataStore.shared)
                .environment(\.locale, .init(identifier: "zh-Hans"))
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
