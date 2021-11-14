//
//  AboutView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/7/21.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            Section {
                SettingItem(
                    title: "Version",
                    detail: Utils.getFormattedAppVersionBuild()
                )
            }
            
            SupportSection()
            Section {
                NavigationLink(destination: LicensesView()) {
                    Text("Licenses")
                }
            }
            
            VStack {
                Text("App.Copyright")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.top)
                    .frame(maxWidth: .infinity)
            }
            .listRowBackground(Color(.systemGroupedBackground))
        }
        
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
