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
    @State private var selectTerm: Term = .all
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Bar Chart").font(.largeTitle).bold().foregroundColor(.primary).padding(.bottom).padding(.top, -12)
            BarChart(courses: courses.filterHasGrades(selectTerm)).padding(.vertical)
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
                    } label: { Text(selectTerm.displayText()) }
                } else {
                    EmptyView()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectTerm = studentDataStore.availableTerms.first ?? .all
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
