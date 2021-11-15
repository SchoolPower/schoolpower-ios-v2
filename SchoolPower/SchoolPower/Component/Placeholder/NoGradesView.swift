//
//  NoGradesView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/12/21.
//

import SwiftUI

struct NoGradesView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var image: Image {
        colorScheme == .dark ? Image("no_grades_dark") : Image("no_grades")
    }
    
    var body: some View {
        PlaceholderInfoView(title: "Nothing here", message: nil, image: image, opacity: 0.8)
    }
}

struct NoGradesView_Previews: PreviewProvider {
    static var previews: some View {
        NoGradesView()
        NoGradesView()
            .preferredColorScheme(.dark)
    }
}
