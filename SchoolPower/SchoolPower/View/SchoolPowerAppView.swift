//
//  ContentView.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import SwiftUI

private struct AppView: View {
    @EnvironmentObject private var studentDataStore: StudentDataStore
    
    var body: some View {
        VStack {
            TabView {
                DashboardView(
                    courses: studentDataStore.studentData.courses,
                    disabledInfo: studentDataStore.tryGetDisabledInfo()
                )
                    .tabItem {
                        Image(systemName: "list.bullet.circle")
                        Text("Courses")
                    }.tag(1)
                
                AttendanceView(
                    attendances: studentDataStore.studentData.attendances,
                    disabledInfo: studentDataStore.tryGetDisabledInfo()
                )
                    .tabItem {
                        Image(systemName: "clock")
                        Text("Attendances")
                    }.tag(2)
                    .animation(.none)
                
                ProfileView(
                    profile: studentDataStore.studentData.profile,
                    extraInfo: studentDataStore.studentData.extraInfo
                )
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }.tag(2)
                    .animation(.none)
            }
        }
    }
}

struct SchoolPowerAppView: View {
    var body: some View {
        AppView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolPowerAppView()
            .environmentObject(SettingsStore.shared)
            .environmentObject(StudentDataStore.shared)
            .environmentObject(AuthenticationStore.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}
