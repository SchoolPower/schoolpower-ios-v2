//
//  SupportSection.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/7/21.
//

import SwiftUI

struct SupportSection: View {
    var body: some View {
        Section() {
            SendBugReportEmail {
                SettingItem(
                    title: "Report Bugs",
                    description: "Contact us via Email"
                )
            }
            Button(action: {
                UIApplication.shared.open(
                    URL(string: Constants.websiteURL)!,
                    options: [:],
                    completionHandler: nil
                )
            }) {
                SettingItem(
                    title: "Website"
                )
            }
            Button(action: {
                UIApplication.shared.open(
                    URL(string: Constants.sourceCodeURL)!,
                    options: [:],
                    completionHandler: nil
                )
            }) {
                SettingItem(
                    title: "Source Code"
                )
            }
        }
    }
}

struct SupportSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SupportSection()
        }
    }
}
