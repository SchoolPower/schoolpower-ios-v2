//
//  StatisticsView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/24/21.
//

import SwiftUI

struct StatisticsView: View {
    var courses: [Course]
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    private var shouldPreSelect: Bool {
        return horizontalSizeClass == .regular
    }
    @State private var selection: Int? = 1
    
    var gpaLabel: some View {
        Label {
            Text("GPA")
        } icon: {
            Image(systemName: "sleep")
                .rotationEffect(.degrees(180))
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    if shouldPreSelect {
                        NavigationLink(
                            tag: 1,
                            selection: $selection,
                            destination: { GPAView(courses: courses) }
                        ) { gpaLabel }
                        .accessibilityIdentifier("gpa")
                    } else {
                        NavigationLink {
                            GPAView(courses: courses)
                        } label: { gpaLabel }
                        .accessibilityIdentifier("gpa")
                    }
                }
                Section {
                    NavigationLink {
                        RadarChartStatisticsView(courses: courses)
                    } label: {
                        Label {
                            Text("Radar Chart")
                        } icon: {
                            Image(systemName: "hexagon")
                        }
                    }
                    NavigationLink {
                        BarChartStatisticsView(courses: courses)
                    } label: {
                        Label {
                            Text("Bar Chart")
                        } icon: {
                            Image(systemName: "chart.bar")
                        }
                    }
                    .accessibilityIdentifier("barChart")
                }
            }
            .navigationTitle("Statistics")
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(courses: [fakeCourse() ,fakeCourse(), fakeCourse()])
            .environmentObject(SettingsStore.shared)
            .environmentObject(StudentDataStore.shared)
            .environmentObject(AuthenticationStore.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}

