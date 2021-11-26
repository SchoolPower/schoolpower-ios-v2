//
//  StatisticsView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/24/21.
//

import SwiftUI

struct StatisticsView: View {
    var courses: [Course]
    var body: some View {
        NavigationView {
            NavigationLink {
                GPAView(courses: courses)
            } label: {
                Text("GPA")
            }
        }
        .navigationTitle("Statistics")
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(courses: [fakeCourse()])
            .environmentObject(SettingsStore.shared)
            .environmentObject(StudentDataStore.shared)
            .environmentObject(AuthenticationStore.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}

