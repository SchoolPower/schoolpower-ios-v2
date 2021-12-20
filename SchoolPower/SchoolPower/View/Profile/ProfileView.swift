//
//  ProfileView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/6/21.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @EnvironmentObject var authentication: AuthenticationStore
    @EnvironmentObject var settingsStore: SettingsStore
    @State var showBugReport: Bool = false
    @State var showingCannotSendEmailAlert: Bool = false
    @State private var selection: Int? = 1
    
    private var shouldPreSelect: Bool {
        return horizontalSizeClass == .regular
    }
    
    var profile: Profile
    var extraInfo: ExtraInfo
    
    var body: some View {
        NavigationView {
            List {
                Section() { HeaderView(profile: profile, extraInfo: extraInfo) }
                Section() {
                    if shouldPreSelect {
                        NavigationLink(
                            tag: 1,
                            selection: $selection,
                            destination: { SettingsView() }
                        ) {
                            Label("Settings", systemImage: "gear")
                        }
                    } else {
                        NavigationLink(destination: SettingsView()) {
                            Label("Settings", systemImage: "gear")
                        }
                    }
                    
                    NavigationLink(destination: AboutView()) {
                        Label("About", systemImage: "info.circle")
                    }
                }
                Section() {
                    SendBugReportEmail {
                        Label("Report a Bug", systemImage: "ladybug")
                    }
                    Button(action: {
                        UIApplication.shared.open(URL(string: Constants.supportUsURL)!)
                    }) {
                        Label("Support Us", systemImage: "heart.circle")
                    }
                }
                Section() {
                    Button(action: {
                        authentication.logout()
                    }) {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                    .accentColor(.red)
                    .accessibilityIdentifier("logout")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .introspectNavigationController { nvc in
            if let svc = nvc.splitViewController {
                svc.minimumPrimaryColumnWidth = 250
                svc.maximumPrimaryColumnWidth = .infinity
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profile: fakeProfile(), extraInfo: fakeExtraInfo())
            .environmentObject(AuthenticationStore.shared)
            .environmentObject(SettingsStore.shared)
    }
}
