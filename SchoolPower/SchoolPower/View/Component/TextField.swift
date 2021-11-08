//
//  TextField.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/7/21.
//

import SwiftUI

struct OvalTextFieldStyle: TextFieldStyle {
    var onFocus: (() -> Void)?
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(32)
            .background(Color(UIColor.systemGroupedBackground))
            .frame(height: 64)
            .cornerRadius(32)
            .contentShape(Rectangle())
            .onTapGesture { self.onFocus?() }
    }
}
