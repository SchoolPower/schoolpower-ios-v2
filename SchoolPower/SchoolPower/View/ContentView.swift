//
//  ContentView.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-12-08.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authentication: AuthenticationStore
    @EnvironmentObject var studentDataStore: StudentDataStore
    
    @State var showLogin: Bool
    
    var body: some View {
        VStack {
            ZStack {
                if !showLogin {
                    SchoolPowerAppView()
                        .transition(.move(edge: .trailing))
                } else {
                    LoginView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .leading)
                        ))
                }
            }
        }
        .hideTitleBarOnCatalyst()
        .onReceive(authentication.$authenticated, perform: { authenticated in
            withAnimation(.easeInOut) {
                showLogin = !authenticated
            }
        })
    }
}

// Global UISplitView behaviour
extension UISplitViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary
        presentsWithGesture = false
    }
}
