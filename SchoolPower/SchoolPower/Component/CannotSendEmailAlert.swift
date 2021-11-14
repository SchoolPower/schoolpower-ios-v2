//
//  CannotSendEmailAlert.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/14/21.
//

import SwiftUI

let CannotSendEmailAlert: Alert = Alert(
    title: Text("Email.CannotSendEmail.Title"),
    message: Text("Email.CannotSendEmail.Message \(Constants.bugReportEmails.joined(separator: "\n"))"),
    primaryButton: .default(Text("Copy email addresses")) {
        UIPasteboard.general.string = Constants.bugReportEmails.joined(separator: ", ")
    },
    secondaryButton: .cancel()
)
