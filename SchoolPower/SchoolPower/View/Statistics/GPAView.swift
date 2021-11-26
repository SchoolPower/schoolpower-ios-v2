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
    @State private var initialized = false
    
    @EnvironmentObject var studentDataStore: StudentDataStore
    
    private var coursesWithGrade: [Course] {
        courses.filterHasGrades()
    }
    
    var body: some View {
        GeometryReader { geo in
        VStack {
            WaveView(progressFraction: gpaPercentFraction, maxSize: min(400, geo.size.width * 0.6)).padding()
                ZStack {
                    Color(.systemGroupedBackground)
                        .edgesIgnoringSafeArea(.all)
                    List(coursesWithGrade, selection: $selectedCourseIds) { course in
                        SettingItem(
                            title: LocalizedStringKey(course.name),
                            detail: course.displayGrade()?
                                .percentage.rounded(digits: 2).asPercentage(),
                            image: nil,
                            description: nil
                        )
                            .listRowBackground(Color(.systemBackground))
                    }
                    .onChange(of: selectedCourseIds) { _ in
                        updateWaveView()
                    }
                    .onAppear {
                        guard !initialized else { return }
                        initialized = true
                        DispatchQueue.main.async {
                            selectedCourseIds.formUnion(coursesWithGrade.mapToIds())
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
                    ).frame(height: 0.05 * minSide(geo)),
                    alignment: .top
                )
            }
        .navigationTitle("GPA")
        }
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
