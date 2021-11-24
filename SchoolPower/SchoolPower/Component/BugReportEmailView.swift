//
//  BugReportEmailView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/7/21.
//

import SwiftUI

struct BugReportEmailView: View {
    var body: some View {
        let version = Utils.getFormattedAppVersionBuild()
        let message = "Email.BugReport.Body".localized(version)
        MailView(data: ComposeMailData(
            subject: "Email.BugReport.Subject".localized,
            recipients: Constants.bugReportEmails,
            message: message,
            attachments: []
        )) { _ in }
    }
}
