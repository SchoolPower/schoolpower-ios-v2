//
//  LoginView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/7/21.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authentication: AuthenticationStore
    @StateObject private var viewModel = LoginViewModel()
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var removeFocus: () -> Void = {}
    
    var forceFallbackTextfield = false
    
    func showAlert(title: String, body: String) {
        alertTitle = title
        alertMessage = body
        showingAlert = true
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.accent.edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    Spacer()
                    
                    Text("Sign In")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.leading, 48)
                        .padding(.top, geometry.size.height * 0.2)
                        .padding(.bottom, 32)
                    
                    ZStack {
                        Color(UIColor.systemBackground)
                            .cornerRadius(.topLeft, 48)
                            .cornerRadius(.topRight, 48)
                            .frame(maxWidth: 496)
                            .edgesIgnoringSafeArea(.all)
                        
                        GeometryReader { geo in
                            ScrollView {
                                VStack {
                                    Group {
                                        // MARK: Inputs
                                        if #available(iOS 15.0, *),
                                           !forceFallbackTextfield{
                                            BetterFocusableInputsView(removeFocus: $removeFocus)
                                                .environmentObject(viewModel)
                                        } else {
                                            // Fallback to smaller clickable area
                                            TextField(LocalizedStringKey("Username"), text: $viewModel.loginData.username)
                                                .accessibilityIdentifier("username")
                                                .textFieldStyle(OvalTextFieldStyle())
                                                .disableAutocorrection(true)
                                                .padding(.top, 8)
                                            SecureField(LocalizedStringKey("Password"), text: $viewModel.loginData.password)
                                                .accessibilityIdentifier("password")
                                                .textFieldStyle(OvalTextFieldStyle())
                                                .disableAutocorrection(true)
                                                .padding(.top, 8)
                                        }
                                        
                                        // MARK: Login Button
                                        Button{ login() } label: {
                                            if viewModel.isLoading {
                                                ProgressView()
                                                    .loginButton(disabled: viewModel.loginData.isEmpty)
                                            } else {
                                                Image(systemName: "arrow.right")
                                                    .loginButton(disabled: viewModel.loginData.isEmpty)
                                            }
                                        }
                                        .accessibilityIdentifier("login")
                                        .disabled(viewModel.loginData.isEmpty)
                                        .alert(isPresented: $showingAlert) {
                                            Alert(
                                                title: Text(alertTitle),
                                                message: Text(alertMessage)
                                            )
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    // MARK: Footer
                                    HStack(spacing: 32) {
                                        // Website
                                        Button { open(url: Constants.websiteURL) } label: {
                                            Image(systemName: "globe.americas.fill")
                                        }
                                        .buttonStyle(.plain)
                                        .opacity(0.3)
                                        
                                        // Source Code
                                        Button { open(url: Constants.sourceCodeURL) } label: {
                                            Image(systemName: "chevron.left.forwardslash.chevron.right")
                                        }
                                        .buttonStyle(.plain)
                                        .opacity(0.3)
                                        
                                        // Bug report
                                        SendBugReportEmail {
                                            Image(systemName: "ladybug.fill")
                                        }
                                        .buttonStyle(.plain)
                                        .opacity(0.3)
                                    }
                                    .padding(.top, 48)
                                    
                                    Text("App.Copyright")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                        .padding(.vertical)
                                }
                                .frame(minHeight: geo.size.height - 96)
                                .padding(.top, 48)
                                .padding(.horizontal, 48)
                            }
                        }.frame(maxWidth: 496)
                    }
                }
                .autocapitalization(.none)
            }
        }
    }
    
    // MARK: Login
    private func login() {
        removeFocus()
        viewModel.login { success, data, errorResponse, error in
            if success {
                removeFocus()
                authentication.authenticate(data: data)
            } else if let errorResponse = errorResponse {
                showAlert(
                    title: errorResponse.title ?? "Failed to sign in".localized,
                    body: errorResponse.description ?? "Unknown error.".localized
                )
            } else {
                showAlert(
                    title: "Failed to sign in".localized,
                    body: error ?? "Unknown error.".localized
                )
            }
        }
    }
    
    private func open(url: String) {
        UIApplication.shared.open(
            URL(string: url)!,
            options: [:],
            completionHandler: nil
        )
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environment(\.locale, .init(identifier: "zh-Hans"))
        LoginView()
            .preferredColorScheme(.dark)
            .environment(\.locale, .init(identifier: "zh-Hans"))
        if #available(iOS 15.0, *) {
            LoginView()
                .environment(\.locale, .init(identifier: "zh-Hans"))
                .previewInterfaceOrientation(.landscapeLeft)
        }
        LoginView(forceFallbackTextfield: true)
            .environment(\.locale, .init(identifier: "zh-Hans"))
    }
}

@available(iOS 15.0, *)
struct BetterFocusableInputsView: View {
    @FocusState private var isUsernameFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    
    @EnvironmentObject var viewModel: LoginViewModel
    
    @Binding private var removeFocus: () -> Void
    
    init(removeFocus: Binding<() -> Void>) {
        self._removeFocus = removeFocus
    }
    
    var body: some View {
        VStack {
            TextField(LocalizedStringKey("Username"), text: $viewModel.loginData.username)
                .accessibilityIdentifier("username")
                .textFieldStyle(OvalTextFieldStyle {
                    isUsernameFocused = true
                })
                .focused($isUsernameFocused)
                .disableAutocorrection(true)
                .padding(.top, 8)
            SecureField(LocalizedStringKey("Password"), text: $viewModel.loginData.password, prompt: nil)
                .accessibilityIdentifier("password")
                .textFieldStyle(OvalTextFieldStyle {
                    isPasswordFocused = true
                })
                .focused($isPasswordFocused)
                .disableAutocorrection(true)
                .padding(.top, 8)
        }
        .onAppear {
            self.removeFocus = {
                isUsernameFocused = false
                isPasswordFocused = false
            }
        }
    }
}

fileprivate extension View {
    func loginButton(disabled: Bool) -> some View {
        self
            .padding()
            .frame(width: 64, height: 64)
            .background(disabled ? Color.gray : Color.accent)
            .foregroundColor(.white)
            .cornerRadius(40)
            .padding(.top, 48)
    }
}
