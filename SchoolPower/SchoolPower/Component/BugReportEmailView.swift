//
//  BugReportEmailView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/7/21.
//

import SwiftUI

struct BugReportEmailView: View {
    var body: some View {
        let appVersion = Utils.getFormattedAppVersionBuild()
        let systemName = Utils.getOSName()
        let systemVersion = UIDevice.current.systemVersion
        let debugInfo = "\(appVersion), \(systemName) \(systemVersion)"
        let message = "Email.BugReport.Body".localized(debugInfo)
        MailView(data: ComposeMailData(
            subject: "Email.BugReport.Subject".localized,
            recipients: Constants.bugReportEmails,
            message: message,
            attachments: []
        )) { _ in }
    }
}
