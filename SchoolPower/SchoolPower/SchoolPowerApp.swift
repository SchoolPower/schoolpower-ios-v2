//
//  SchoolPowerApp.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authentication: AuthenticationStore
    @EnvironmentObject var studentDataStore: StudentDataStore
    
    @State var showLogin: Bool
    
    var body: some View {
        VStack {
            ZStack {
                if !showLogin {
                    SchoolPowerAppView()
                        .transition(.move(edge: .trailing))
                } else {
                    LoginView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .leading)
                        ))
                }
            }
        }
        .onReceive(authentication.$authenticated, perform: { authenticated in
            withAnimation(.easeInOut) {
                showLogin = !authenticated
            }
        })
    }
}

@main
struct SchoolPowerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.locale) private var defaultLocale
    
    @StateObject var authentication = AuthenticationStore.shared
    @StateObject var settingsStore = SettingsStore.shared
    @StateObject var studentDataStore = StudentDataStore.shared
    @StateObject var infoCardStore = InfoCardStore.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView(showLogin: !authentication.authenticated)
                .environmentObject(authentication)
                .environmentObject(settingsStore)
                .environmentObject(studentDataStore)
                .environmentObject(infoCardStore)
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
