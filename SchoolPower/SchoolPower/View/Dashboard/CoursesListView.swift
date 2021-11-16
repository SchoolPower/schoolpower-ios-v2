//
//  CoursesList.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/15/21.
//

import SwiftUI

struct CoursesListView: View, ErrorHandler {
    @ObservedObject var viewModel: DashboardViewModel
    var horizontalSizeClass: UserInterfaceSizeClass?
    
    @EnvironmentObject var settings: SettingsStore
    
    @State var infoCardContent: InfoCardContent? = nil
    @State var errorResponse: ErrorResponse? = nil
    @State var showingError: Bool = false
    
    private let refreshHelper = RefreshHelper<CoursesListView>()
    
    private var content: some View {
        ForEach(viewModel.coursesToDisplay) { course in
            DashboardCourseItem(course: course)
                .background(NavigationLink(
                    destination: CourseDetailView(course: course)
                ) {}.opacity(0))
                .listRowInsets(EdgeInsets())
        }
    }
    
    var body: some View {
        ZStack {
            if horizontalSizeClass == .regular {
                List {
                    if let infoCard = infoCardContent {
                        InfoCard(content: infoCard)
                    }
                    content
                }
                .withRefresh(parent: self, refreshHelper: refreshHelper)
                .listStyle(.sidebar)
                .listRowInsets(EdgeInsets())
                .navigationTitle("Courses")
            } else {
                List {
                    if let infoCard = infoCardContent {
                        Section {
                            InfoCard(content: infoCard)
                                .padding(.horizontal, -20)
                                .padding(.vertical, -20)
                        }
                        .listRowBackground(Color(.systemGroupedBackground))
                    }
                    Section() {
                        content
                    }
                }
                .withRefresh(parent: self, refreshHelper: refreshHelper)
                .transition(.slide)
                .listStyle(.insetGrouped)
                .listRowInsets(EdgeInsets())
                .navigationTitle("Courses")
            }
            AlertIfError(
                showingAlert: $showingError,
                errorResponse: $errorResponse
            )
        }
        .onReceive(InfoCardStore.shared.$infoCardToShow) { infoCardContent in
            withAnimation {
                self.infoCardContent = infoCardContent
            }
        }
    }
}
