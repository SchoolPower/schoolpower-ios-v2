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
            switch (UIDevice.current.userInterfaceIdiom) {
            case .pad:
                NavigationView {
                    if viewModel.showPlaceholder {
                        coursesList
                        viewModel.placeholder
                    } else {
                        coursesList
                        Text("")
                        Text("")
                    }
                }
            default:
                NavigationView {
                    coursesList
                    if viewModel.showPlaceholder {
                        viewModel.placeholder
                    } else {
                        Text("")
                    }
                }
            }
            if horizontalSizeClass == .compact,
               viewModel.showPlaceholder {
                viewModel.placeholder
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
            .environmentObject(InfoCardStore.shared)
            .environment(\.locale, .init(identifier: "ja"))
        DashboardView(courses: [])
            .environmentObject(SettingsStore.shared)
            .environmentObject(InfoCardStore.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
        DashboardView(courses: [fakeCourse()], disabledInfo: fakeDisabledInfo())
            .environmentObject(SettingsStore.shared)
            .environmentObject(InfoCardStore.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
        if #available(iOS 15.0, *) {
            DashboardView(courses: [fakeCourse()], disabledInfo: fakeDisabledInfo())
                .environmentObject(SettingsStore.shared)
                .environment(\.locale, .init(identifier: "zh-Hans"))
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
