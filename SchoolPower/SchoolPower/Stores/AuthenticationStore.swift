//
//  AuthenticationStore.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/7/21.
//

import SwiftUI
import KeychainAccess

class AuthenticationStore: ObservableObject {
    static let shared = AuthenticationStore()
    
    @Published var authenticated: Bool
    
    private let settingsStore = SettingsStore.shared
    private let keychain = Keychain(service: "studio.schoolpower.SchoolPower")
    private static let passwordKey = "password"
    
    var username: String? {
        settingsStore.username
    }
    
    private var password: String? {
        try? keychain.get(AuthenticationStore.passwordKey)
    }
    
    var requestData: RequestData? {
        guard authenticated else {
            return nil
        }
        if let username = username, let password = password {
            return RequestData(username: username, password: password)
        }
        // Force log out if cannot get credentials
        logout()
        return nil
    }
    
    private init() {
        authenticated = settingsStore.authenticated
    }
    
    func login(data: RequestData) {
        authenticate(data: data)
        settingsStore.lastLoggedInAt = Date()
        settingsStore.appLaunchesCountSinceLastLogin = 1
    }
    
    func logout() {
        settingsStore.lastLoggedInAt = Date(timeIntervalSince1970: 0)
        settingsStore.appLaunchesCountSinceLastLogin = 0
        settingsStore.lastShownAppStoreReviewPromptAppVersion = ""
        revokeAuthentication()
    }
    
    private func authenticate(data: RequestData) {
        keychain[AuthenticationStore.passwordKey] = data.password
        settingsStore.username = data.username
        settingsStore.authenticated = true
        self.authenticated = true
    }
    
    private func revokeAuthentication() {
        keychain[AuthenticationStore.passwordKey] = nil
        settingsStore.username = ""
        settingsStore.authenticated = false
        StudentDataStore.clearLocal()
        self.authenticated = false
    }
}
