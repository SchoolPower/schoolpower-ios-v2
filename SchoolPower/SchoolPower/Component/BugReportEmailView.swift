//
//  BugReportEmailView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/7/21.
//

import SwiftUI

struct BugReportEmailView: View {
    @State private var data = ComposeMailData(
        subject: "Subject",
        recipients: ["a@b.com"],
        message: "Message",
        attachments: []
    )
    var body: some View {
        MailView(data: $data) { _ in
            
        }
    }
}
