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
    @EnvironmentObject var studentDataStore: StudentDataStore
    
    @State private var infoCardContent: InfoCardContent? = nil
    @State internal var errorResponse: ErrorResponse? = nil
    @State internal var showingError: Bool = false
    @State private var showingSelectTermMenu = true
    @State private var selectTerm: Term = SettingsStore.shared.courseViewingTerm
    
    private let refreshHelper = RefreshHelper<CoursesListView>()
    
    private var content: some View {
        ForEach(viewModel.coursesToDisplay.filterHasGrades(selectTerm)) { course in
            DashboardCourseItem(course: course, term: selectTerm)
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
                                .padding(.horizontal, -16)
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
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Picker(selection: $selectTerm, label: Text("Select term")) {
                        Text(verbatim: .all.displayText()).tag(Term.all)
                        ForEach(studentDataStore.availableTerms, id: \.self) { term in
                            Text(term).tag(term)
                        }
                    }
                } label: { Text(selectTerm.displayText()) }
            }
        }
        .onReceive(InfoCardStore.shared.$infoCardToShow) { infoCardContent in
            withAnimation {
                self.infoCardContent = infoCardContent
            }
        }
        .onChange(of: selectTerm) { newValue in
            settings.courseViewingTerm = newValue
        }
    }
}
