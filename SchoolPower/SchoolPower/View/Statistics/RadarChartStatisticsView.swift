//
//  RadarChartStatisticsView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/26/21.
//

import SwiftUI

struct RadarChartStatisticsView: View {
    var courses: [Course]
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @EnvironmentObject var studentDataStore: StudentDataStore
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var selectTerm: Term = .all
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Radar Chart")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.primary)
                .padding(.top, -16)
                .padding(.bottom)
            let courses = courses.filterHasGrades(selectTerm)
            if !courses.isEmpty {
                GeometryReader { geo in
                    RadarChart(
                        courses: courses,
                        frame: geo.frame(in: .local)
                    ).padding(.bottom, 100)
                }
            } else {
                VStack {
                    Text("No Data")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding()
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
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectTerm, perform: { newValue in
            settingsStore.selectedRadarChartViewingTerm = newValue
        })
        .onAppear {
            let stored = settingsStore.selectedRadarChartViewingTerm
            if studentDataStore.availableTerms.contains(stored) {
                selectTerm = stored
            } else {
                selectTerm = studentDataStore.availableTerms.first ?? .all
            }
        }
    }
}

struct RadarChartStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        RadarChartStatisticsView(courses: [])
            .environmentObject(SettingsStore.shared)
            .environmentObject(StudentDataStore.shared)
            .environmentObject(AuthenticationStore.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}
