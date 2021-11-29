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
    
    @State private var informationCard: InformationCard? = nil
    @State internal var errorResponse: ErrorResponse? = nil
    @State internal var showingError: Bool = false
    @State private var showingSelectTermMenu = true
    @State private var showingBirthday = false
    @State private var selectTerm: Term = SettingsStore.shared.courseViewingTerm
    
    private let refreshHelper = RefreshHelper<CoursesListView>()
    
    // MARK: List content
    private var content: some View {
        ForEach(viewModel.coursesToDisplay.filterHasGrades(selectTerm)) { course in
            DashboardCourseItem(course: course, term: selectTerm)
                .background(NavigationLink(
                    destination: CourseDetailView(course: course)
                ) {}.opacity(0).accessibilityIdentifier("course_\(course.name)"))
                .listRowInsets(EdgeInsets())
        }
    }
    
    var body: some View {
        ZStack {
            if horizontalSizeClass == .regular {
                // MARK: Wide screen
                List {
                    if let infoCard = informationCard {
                        InfoCard(content: infoCard)
                    }
                    content
                }
                .withRefresh(parent: self, refreshHelper: refreshHelper)
                .listStyle(.sidebar)
                .listRowInsets(EdgeInsets())
                .navigationTitle("Courses")
            } else {
                // MARK: Narrow screen
                List {
                    if let infoCard = informationCard {
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
            // MARK: Error alert
            AlertIfError(
                showingAlert: $showingError,
                errorResponse: $errorResponse
            )
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                HStack {
                    // MARK: Birthday
                    if studentDataStore.isBirthdayToday() {
                        Button {
                            showingBirthday = true
                        } label: {
                            GeometryReader { geo in
                                LottieView(name: "cheer", loopMode: .loop)
                                    .frame(
                                        width: 24,
                                        height: 24
                                    )
                                    .padding(.leading, -8)
                                    .padding(.top, -6)
                            }
                        }
                        .sheet(isPresented: $showingBirthday) {
                            BirthdayView()
                        }
                    }
                    // MARK: Select term
                    if !viewModel.showPlaceholder {
                        Menu {
                            Picker(selection: $selectTerm, label: Text("Select term")) {
                                Text(verbatim: .all.displayText()).tag(Term.all)
                                ForEach(studentDataStore.availableTerms, id: \.self) { term in
                                    Text(term).tag(term)
                                }
                            }
                        } label: { Label(selectTerm.displayText(), systemImage: "chevron.down").labelStyle(.horizontal) }
                        .padding(.leading, 8)
                    }
                }
            }
        }
        .onReceive(InfoCardStore.shared.$infoCardToShow) { informationCard in
            withAnimation {
                self.informationCard = informationCard
            }
        }
        .onChange(of: selectTerm) { newValue in
            settings.courseViewingTerm = newValue
        }
    }
}
