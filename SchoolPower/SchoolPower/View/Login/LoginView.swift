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
    
    func showAlert(title: String, body: String) {
        alertTitle = title
        alertMessage = body
        showingAlert = true
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.accent
                    .edgesIgnoringSafeArea(.all)
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
                                    if #available(iOS 15.0, *) {
                                        BetterFocusableInputsView()
                                            .environmentObject(viewModel)
                                    } else {
                                        // Fallback to smaller clickable area
                                        TextField("Username", text: $viewModel.loginData.username)
                                            .textFieldStyle(OvalTextFieldStyle())
                                            .padding(.top, 8)
                                        SecureField("Password", text: $viewModel.loginData.password)
                                            .textFieldStyle(OvalTextFieldStyle())
                                            .padding(.top, 8)
                                    }
                                    Button(action: {
                                        viewModel.login { success, data, errorResponse, error in
                                            if success {
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
                                    }) {
                                        if viewModel.isLoading {
                                            ProgressView()
                                                .loginButton(disabled: viewModel.loginData.isEmpty)
                                        } else {
                                            Image(systemName: "arrow.right")
                                                .loginButton(disabled: viewModel.loginData.isEmpty)
                                        }
                                    }
                                    .alert(isPresented: $showingAlert) {
                                        Alert(
                                            title: Text(alertTitle),
                                            message: Text(alertMessage)
                                        )
                                    }
                                    .disabled(viewModel.loginData.isEmpty)
                                    Spacer()
                                    HStack(spacing: 32) {
                                        Button {
                                            UIApplication.shared.open(
                                                URL(string: Constants.websiteURL)!,
                                                options: [:],
                                                completionHandler: nil
                                            )
                                        } label: { Image(systemName: "globe.americas.fill") }
                                        .buttonStyle(.plain)
                                        .opacity(0.3)
                                        Button {
                                            UIApplication.shared.open(
                                                URL(string: Constants.sourceCodeURL)!,
                                                options: [:],
                                                completionHandler: nil
                                            )
                                        } label: { Image(systemName: "chevron.left.forwardslash.chevron.right") }
                                        .buttonStyle(.plain)
                                        .opacity(0.3)
                                        SendBugReportEmail {
                                            Image(systemName: "ladybug.fill")
                                        }
                                        .buttonStyle(.plain)
                                        .opacity(0.3)
                                    }
                                    .padding(.top, 48)
                                    Text("App.Copyright").font(.caption2).foregroundColor(.gray)
                                        .padding(.vertical)
                                }
                                .frame(minHeight: geo.size.height - 96)
                                .padding(.top, 48)
                                .padding(.leading, 48)
                                .padding(.trailing, 48)
                            }
                        }.frame(maxWidth: 496)
                    }
                }
                .autocapitalization(.none)
            }
        }
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
    }
}

@available(iOS 15.0, *)
struct BetterFocusableInputsView: View {
    @FocusState private var isUsernameFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    
    @EnvironmentObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack {
            TextField("Username", text: $viewModel.loginData.username)
                .textFieldStyle(OvalTextFieldStyle {
                    isUsernameFocused = true
                })
                .focused($isUsernameFocused)
                .padding(.top, 8)
            SecureField(text: $viewModel.loginData.password) {
                Text("Password")
            }
                .textFieldStyle(OvalTextFieldStyle {
                    isPasswordFocused = true
                })
                .focused($isPasswordFocused)
                .padding(.top, 8)
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
