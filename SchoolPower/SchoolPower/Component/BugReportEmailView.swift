//
//  BugReportEmailView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/7/21.
//

import SwiftUI

struct BugReportEmailView: View {
    @Environment(\.locale) var locale
    
    var body: some View {
        let version = Utils.getFormattedAppVersionBuild()
        let message = String(
            format: "Email.BugReport.Body".localized(locale.identifier),
            version
        )
        MailView(data: ComposeMailData(
            subject: "Email.BugReport.Subject".localized(locale.identifier),
            recipients: Constants.bugReportEmails,
            message: message,
            attachments: []
        )) { _ in }
    }
}
