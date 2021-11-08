//
//  ProfileView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/6/21.
//

import SwiftUI

private struct HeaderView: View {
    var profile: Profile
    var body: some View {
        HStack(alignment: .center) {
            Text(profile.lastName.first?.uppercased() ?? String(profile.id).first?.uppercased() ?? "")
                .frame(width: 65, height: 65)
                .foregroundColor(.white)
                .font(.title3)
                .background(
                    Circle()
                        .foregroundColor(.purple)
                )
            VStack(alignment: .leading) {
                Text(profile.fullName()).foregroundColor(.primary).font(.title2).bold()
                Spacer().frame(width: 2).fixedSize()
                Text(String(profile.id)).foregroundColor(.primary).font(.subheadline)
            }.padding(.leading)
        }
        .padding(.top)
        .padding(.bottom)
    }
}

struct ProfileView: View {
    @EnvironmentObject var authentication: AuthenticationStore
    @State var showBugReport: Bool = false
    @State private var selection: Int? = 1
    private var shouldPreSelect: Bool {
        switch (UIDevice.current.userInterfaceIdiom) {
        case .pad, .mac:
            return true
        default:
            return false
        }
    }
    
    var profile: Profile
    
    var body: some View {
        NavigationView {
            List {
                Section() { HeaderView(profile: profile) }
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
                    Button(action: {
                        showBugReport = true
                    }) {
                        Label("Report a Bug", systemImage: "ladybug")
                    }
                    .disabled(!MailView.canSendMail)
                    .sheet(isPresented: $showBugReport) {
                        BugReportEmailView()
                    }
                }
                Section() {
                    Button(action: {
                        authentication.revokeAuthentication()
                    }) {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                    .accentColor(.red)
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profile: fakeProfile())
    }
}
