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
            List {
                Section {
                    NavigationLink {
                        GPAView(courses: courses)
                    } label: {
                        Label {
                            Text("GPA")
                        } icon: {
                            Image(systemName: "sleep")
                                .rotationEffect(.degrees(180))
                        }

                    }
                }
                Section {
                    NavigationLink {
                        BarChartStatisticsView(courses: courses)
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

