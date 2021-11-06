//
//  ContentView.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import SwiftUI

struct SchoolPowerAppView: View {
    @ObservedObject var viewModel = SchoolPowerAppViewModel()
    
    var body: some View {
        TabView {
            DashboardView(courses: viewModel.studentData.courses)
                .tabItem {
                    Image(systemName: "list.bullet.circle")
                    Text("Courses")
                }.tag(1)
            
            Text("Tab Content 2")
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Chart")
                }.tag(2)
            
            AttendanceView(attendances: viewModel.studentData.attendances)
                .tabItem {
                    Image(systemName: "clock")
                    Text("Attendances")
                }.tag(2)
            
            Text("Tab Content 2")
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                    
                }.tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolPowerAppView()
    }
}
