//
//  BarChartStatisticsView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/25/21.
//

import SwiftUI

struct BarChartStatisticsView: View {
    var courses: [Course]
    
    @EnvironmentObject var studentDataStore: StudentDataStore
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var selectTerm: Term = .all
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Bar Chart").font(.largeTitle).bold().foregroundColor(.primary).padding(.bottom).padding(.top, -12)
            
            if let courses = courses.filterHasGrades(selectTerm), !courses.isEmpty {
                BarChart(courses: courses).padding(.vertical)
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
                    Menu {
                        Picker(selection: $selectTerm, label: Text("Select term")) {
                            ForEach(studentDataStore.availableTerms, id: \.self) { term in
                                Text(term).tag(term)
                            }
                        }
                    } label: { Label(selectTerm.displayText(), systemImage: "chevron.down").labelStyle(.horizontal) }
                } else {
                    EmptyView()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectTerm, perform: { newValue in
            settingsStore.selectedBarChartViewingTerm = newValue
        })
        .onAppear {
            let stored = settingsStore.selectedBarChartViewingTerm
            if studentDataStore.availableTerms.contains(stored) {
                selectTerm = stored
            } else {
                selectTerm = studentDataStore.availableTerms.first ?? .all
            }
        }
    }
}

struct BarChartStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartStatisticsView(courses: [fakeCourse(), fakeCourse(), fakeCourse()])
            .environmentObject(SettingsStore.shared)
            .environmentObject(StudentDataStore.shared)
            .environmentObject(AuthenticationStore.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}
