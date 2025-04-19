//
//  ContentView.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import SwiftUI

private struct AppView: View {
    @EnvironmentObject private var studentDataStore: StudentDataStore
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    enum Tab {
        case courses, attendance, schedule, statistics, profile
    }
    
    @State var selectedTab = Tab.courses
    
    var courses: some View {
        DashboardView(
            courses: studentDataStore.studentData.courses,
            disabledInfo: studentDataStore.tryGetDisabledInfo()
        )
        .tabItem {
            Image(systemName: "list.bullet.circle")
            Text("Courses")
        }.tag(Tab.courses)
    }
    
    var attendance: some View {
        AttendanceView(
            attendances: studentDataStore.studentData.attendances,
            disabledInfo: studentDataStore.tryGetDisabledInfo()
        )
        .tabItem {
            Image(systemName: "clock")
            Text("Attendances")
        }.tag(Tab.attendance)
    }
    
    var schedule: some View {
        ScheduleView()
            .tabItem {
                Image(systemName: "calendar.circle")
                Text("Schedule")
            }.tag(Tab.schedule)
    }
    
    var statistics: some View {
        StatisticsView(courses: studentDataStore.studentData.courses)
            .tabItem {
                Image(systemName: "chart.pie")
                Text("Statistics")
            }.tag(Tab.statistics)
    }
    
    var profile: some View {
        ProfileView(
            profile: studentDataStore.studentData.profile,
            extraInfo: studentDataStore.studentData.extraInfo
        )
        .tabItem {
            Image(systemName: "person.crop.circle")
            Text("Profile")
        }.tag(Tab.profile)
    }
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                courses
                attendance
                schedule
                statistics
                profile
            }
            .introspect(.tabView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { tvc in
                if #available(iOS 15.0, *),
                   horizontalSizeClass == .regular {
                    let appearance = UITabBarAppearance()
                    appearance.configureWithDefaultBackground()
                    tvc.tabBar.scrollEdgeAppearance = appearance
                }
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
