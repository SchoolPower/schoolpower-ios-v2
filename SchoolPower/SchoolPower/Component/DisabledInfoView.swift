//
//  DisabledInfoView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/12/21.
//

import SwiftUI

struct DisabledInfoView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var disabledInfo: DisabledInfo
    
    var image: Image {
        colorScheme == .dark ? Image("no_grades_dark") : Image("no_grades")
    }
    
    var body: some View {
        PlaceholderInfoView(title: disabledInfo.title, message: disabledInfo.message, image: Image(systemName: "nosign"), opacity: 0.2)
    }
}

struct DisabledInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DisabledInfoView(disabledInfo: fakeDisabledInfo())
        DisabledInfoView(disabledInfo: fakeDisabledInfo())
            .preferredColorScheme(.dark)
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}
