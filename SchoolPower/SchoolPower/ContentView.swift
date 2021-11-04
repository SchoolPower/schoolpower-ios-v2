//
//  ContentView.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import SwiftUI

struct ContentView: View {
    init() {
        UINavigationBar
            .appearance()
            .largeTitleTextAttributes = [
                .font : UIFont(
                    name: "Poppins-Regular",
                    size: 32
                )!
            ]
    }
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "list.bullet.circle")
                    Text("Courses")
                }.tag(1)
            
            Text("Tab Content 2")
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Chart")
                }.tag(2)
            
            Text("Tab Content 2")
                .tabItem {
                    Image(systemName: "clock")
                    Text("Attendance")
                    
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
        ContentView()
    }
}
