//
//  ContentView.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import SwiftUI

private struct AppView: View {
    @EnvironmentObject private var studentDataStore: StudentDataStore
    
    var courses: some View {
        DashboardView(
            courses: studentDataStore.studentData.courses,
            disabledInfo: studentDataStore.tryGetDisabledInfo()
        )
            .tabItem {
                Image(systemName: "list.bullet.circle")
                Text("Courses")
            }.tag(1)
    }
    
    var attendance: some View {
        AttendanceView(
            attendances: studentDataStore.studentData.attendances,
            disabledInfo: studentDataStore.tryGetDisabledInfo()
        )
            .tabItem {
                Image(systemName: "clock")
                Text("Attendances")
            }.tag(2)
            .animation(.none)
    }
    
    var schedule: some View {
        ScheduleView(schedule: studentDataStore.schedule)
            .tabItem {
                Image(systemName: "calendar.circle")
                Text("Schedule")
            }.tag(2)
            .animation(.none)
    }
    
    var statistics: some View {
        StatisticsView()
            .tabItem {
                Image(systemName: "chart.pie")
                Text("Statistics")
            }.tag(2)
    }
    
    var profile: some View {
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
    
    var body: some View {
        VStack {
            TabView {
                courses
                attendance
                schedule
                statistics
                profile
            }
        }
    }
}

struct SchoolPowerAppView: View {
    var body: some View {
        AppView()
    }
}

struct SchoolPowerAppView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolPowerAppView()
            .environmentObject(SettingsStore.shared)
            .environmentObject(StudentDataStore.shared)
            .environmentObject(AuthenticationStore.shared)
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}
