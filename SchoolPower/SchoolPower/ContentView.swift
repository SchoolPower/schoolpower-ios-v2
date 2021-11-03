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
            DashboardView().tabItem {
                Text("Dashboard")
            }.tag(1)
            
            Text("Tab Content 2")
                .tabItem {
                    Text("Chart")
                    
                }.tag(2)
            
            Text("Tab Content 2")
                .tabItem {
                    Text("Attendance")
                    
                }.tag(2)
            
            Text("Tab Content 2")
                .tabItem {
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
