//
//  LicensesView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/14/21.
//

import SwiftUI

struct LicensesView: View {
    var body: some View {
        List {
            ForEach(Utils.licenses) { license in
                NavigationLink(destination: LicenseView(license: license)) {
                    Text(license.libraryName)
                }
            }
        }
        .navigationTitle("Licenses")
        .navigationBarTitleDisplayMode(.large)
    }
}

fileprivate struct LicenseView: View {
    var license: License
    
    var body: some View {
        ScrollView {
            Text(license.text).font(.footnote)
        }
        .padding()
        .navigationTitle(license.libraryName)
    }
}

struct LicensesView_Previews: PreviewProvider {
    static var previews: some View {
        LicensesView()
    }
}
