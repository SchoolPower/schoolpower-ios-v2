//
//  SchoolPowerApp.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import SwiftUI

@main
struct SchoolPowerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.locale) private var defaultLocale
    
    @StateObject var authentication = AuthenticationStore.shared
    @StateObject var settingsStore = SettingsStore.shared
    @StateObject var studentDataStore = StudentDataStore.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if authentication.authenticated {
                    SchoolPowerAppView()
                        .transition(.move(edge: .trailing))
                        .animation(.easeInOut)
                } else {
                    LoginView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .leading)
                        ))
                        .animation(.easeInOut)
                }
            }
            .environmentObject(authentication)
            .environmentObject(settingsStore)
            .environmentObject(studentDataStore)
            .environment(
                \.locale,
                 Utils.getLocale(
                    language: settingsStore.language,
                    defaultLocale: defaultLocale
                 )
            )
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
        }
    }
}
