//
//  AboutView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/7/21.
//

import SwiftUI

struct AboutView: View {
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        List {
            Section {
                SettingItem(
                    title: "Version",
                    detail: appVersion
                )
            }
            SupportSection()
            Section {
                NavigationLink(destination: AboutView()) {
                    Text("Licenses")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
