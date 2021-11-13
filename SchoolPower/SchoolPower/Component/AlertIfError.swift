//
//  AlertIfError.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/13/21.
//

import SwiftUI

struct AlertIfError: View {
    var showingAlert: Binding<Bool>
    var errorResponse: Binding<ErrorResponse?>
    
    private var alertTitle: String {
        errorResponse.wrappedValue?.title ?? ""
    }
    private var alertMessage: String {
        errorResponse.wrappedValue?.description ?? ""
    }
    
    var body: some View {
        Text("")
            .alert(isPresented: showingAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
}
