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
    @State private var selectTerm: Term = .all
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Radar Chart").font(.largeTitle).bold().foregroundColor(.primary).padding(.top, -12).padding(.bottom)
            RadarChart(courses: courses.filterHasGrades(selectTerm)).padding(.bottom, 100)
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

struct RadarChartStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        RadarChartStatisticsView(courses: [fakeCourse(), fakeCourse(), fakeCourse()])
            .environmentObject(SettingsStore.shared)
            .environmentObject(StudentDataStore.shared)
            .environmentObject(AuthenticationStore.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}
