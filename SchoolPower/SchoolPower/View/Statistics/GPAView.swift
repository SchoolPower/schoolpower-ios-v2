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
            if !coursesWithGrade.isEmpty {
                WaveView(progressFraction: gpaPercentFraction)
                    .padding(.horizontal, 64)
                    .padding(.vertical, 24)
                ZStack {
                    Color(.systemGroupedBackground)
                        .edgesIgnoringSafeArea(.all)
                    List(coursesWithGrade, selection: $selectedCourseIds) { course in
                        SettingItem(
                            title: LocalizedStringKey(course.name),
                            detail: course.displayGrade(selectTerm)?
                                .percentage.rounded(digits: 0).asPercentage(),
                            image: nil,
                            description: nil
                        )
                            .listRowBackground(Color(.systemBackground))
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
            } else {
                VStack {
                    Text("No Data")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if selectTerm != .all {
                    Picker(selection: $selectTerm, label: Text("")) {
                        ForEach(studentDataStore.availableTerms, id: \.self) { term in
                            Text(term).tag(term)
                        }
                    }
                    .pickerStyle(.menu)
                } else {
                    EmptyView()
                }
            }
        }
        .onChange(of: selectedCourseIds) { _ in
            var temp = SettingsStore.shared.selectedGPACourseIdsByTerm as? [Term: [String]] ?? [:]
            temp[selectTerm] = Array(selectedCourseIds)
            SettingsStore.shared.selectedGPACourseIdsByTerm = temp
            updateWaveView()
        }
        .onChange(of: selectTerm) { _ in
            SettingsStore.shared.selectedGPAViewingTerm = selectTerm
            let selectedGPACourseIdsByTerm = SettingsStore.shared
                .selectedGPACourseIdsByTerm as? [Term: [String]] ?? [:]
            let selectedGPACourseIds = selectedGPACourseIdsByTerm[selectTerm]
            
            if let stored = selectedGPACourseIds {
                selectedCourseIds = Set(stored)
            } else {
                selectedCourseIds = Set(courseIdsWithGrade)
            }
        }
        .onAppear {
            let selectedGPAViewingTerm = SettingsStore.shared.selectedGPAViewingTerm
            if studentDataStore.availableTerms.contains(selectedGPAViewingTerm) {
                selectTerm = selectedGPAViewingTerm
            } else {
                selectTerm = studentDataStore.availableTerms.first ?? .all
            }
            
            let selectedGPACourseIdsByTerm = SettingsStore.shared
                .selectedGPACourseIdsByTerm as? [Term: [String]] ?? [:]
            let selectedGPACourseIds = selectedGPACourseIdsByTerm[selectTerm]
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let stored = selectedGPACourseIds {
                    selectedCourseIds = Set(stored)
                } else {
                    selectedCourseIds = Set(courseIdsWithGrade)
                }
                updateWaveView()
            }
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
        GPAView(courses: [fakeCourse(), fakeCourse(name: "English 12")])
            .environmentObject(SettingsStore.shared)
            .environmentObject(StudentDataStore.shared)
            .environmentObject(AuthenticationStore.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}
