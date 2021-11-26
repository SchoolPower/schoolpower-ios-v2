//
//  GPAView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/25/21.
//

import SwiftUI

struct GPAView: View {
    var courses: [Course]
    
    @State private var gpaPercentFraction: Double = 0
    @State private var selectedCourseIds: Set<String> = Set()
    @State private var editMode: EditMode = .active
    @State private var selectTerm: Term = .all
    
    @EnvironmentObject var studentDataStore: StudentDataStore
    
    private var coursesWithGrade: [Course] {
        courses.filterReallyHasGrades(selectTerm)
    }
    
    private var courseIdsWithGrade: [String] {
        coursesWithGrade.mapToIds()
    }
    
    var body: some View {
        VStack {
            WaveView(progressFraction: gpaPercentFraction)
                .padding(.horizontal, 64)
                .padding(.vertical, 24)
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                List(coursesWithGrade, selection: $selectedCourseIds) { course in
                    SettingItem(
                        title: LocalizedStringKey(course.name),
                        detail: course.displayGrade()?
                            .percentage.rounded(digits: 0).asPercentage(),
                        image: nil,
                        description: nil
                    )
                        .listRowBackground(Color(.systemBackground))
                }
                .animation(nil)
                .introspectTableView(customize: { tableView in
                    tableView.showsVerticalScrollIndicator = false
                    tableView.showsHorizontalScrollIndicator = false
                })
                .onChange(of: selectedCourseIds) { _ in
                    SettingsStore.shared.selectedGPACourseIds = Array(selectedCourseIds)
                    updateWaveView()
                }
                .onAppear {
                    let selectedGPACourseIds = SettingsStore.shared.selectedGPACourseIds
                    let intersection = Set(courseIdsWithGrade).intersection(selectedGPACourseIds)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if intersection.isEmpty {
                            selectedCourseIds = Set(courseIdsWithGrade)
                        } else {
                            selectedCourseIds = Set(intersection)
                        }
                        updateWaveView()
                    }
                }
                .listStyle(.insetGrouped)
                .frame(maxWidth: 600)
                .environment(\.editMode, $editMode)
            }
            .overlay(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            .gray.opacity(0.2),
                            .gray.opacity(0.0),
                            .clear
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                ).frame(height: 10),
                alignment: .top
            )
            .edgesIgnoringSafeArea(.all)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if selectTerm != .all {
                    Menu {
                        Picker(selection: $selectTerm, label: Text("Select term")) {
                            ForEach(studentDataStore.availableTerms, id: \.self) { term in
                                Text(term).tag(term)
                            }
                        }
                    } label: { Text(selectTerm.displayText()) }
                } else {
                    EmptyView()
                }
            }
        }
        .onChange(of: selectTerm) { _ in
            selectedCourseIds.formIntersection(courseIdsWithGrade)
        }
        .onAppear {
            selectTerm = studentDataStore.availableTerms.first ?? .all
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("GPA")
    }
    
    func minSide(_ geo: GeometryProxy) -> CGFloat {
        CGFloat(3) * min(geo.size.width, geo.size.height) / 2
    }
    
    func updateWaveView() {
        withAnimation(.easeInOut(duration: 0.75)) {
            gpaPercentFraction = selectedCourseIds
                .compactMap { courseId in
                    studentDataStore
                        .courseById[courseId]?
                        .displayGrade()?
                        .percentage
                }
                .map({ it in it.normalizePercentage() })
                .average
        }
    }
}

struct GPAView_Previews: PreviewProvider {
    static var previews: some View {
        GPAView(courses: [fakeCourse()])
            .environmentObject(SettingsStore.shared)
            .environmentObject(StudentDataStore.shared)
            .environmentObject(AuthenticationStore.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}
