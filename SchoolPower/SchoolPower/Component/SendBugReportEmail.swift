//
//  CannotSendEmailAlert.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/14/21.
//

import SwiftUI

fileprivate let CannotSendEmailAlert: Alert = Alert(
    title: Text("Email.CannotSendEmail.Title"),
    message: Text("Email.CannotSendEmail.Message \(Constants.bugReportEmails.joined(separator: "\n"))"),
    primaryButton: .default(Text("Copy email addresses")) {
        UIPasteboard.general.string = Constants.bugReportEmails.joined(separator: ", ")
    },
    secondaryButton: .cancel()
)

struct SendBugReportEmail<Label>: View where Label: View {
    @State var showBugReport: Bool = false
    @State var showingCannotSendEmailAlert: Bool = false
    
    @ViewBuilder var child: () -> Label
    
    var body: some View {
        Button(action: {
            guard MailView.canSendMail else {
                showingCannotSendEmailAlert = true
                return
            }
            showBugReport = true
        }) {
            child()
        }
        .alert(isPresented: $showingCannotSendEmailAlert) {
            CannotSendEmailAlert
        }
        .sheet(isPresented: $showBugReport) {
            BugReportEmailView()
        }
    }
}
