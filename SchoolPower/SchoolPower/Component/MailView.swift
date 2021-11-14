//
//  MailView.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/7/21.
//
//  Credit: https://swiftuirecipes.com/blog/send-mail-in-swiftui

import SwiftUI
import UIKit
import MessageUI

typealias MailViewCallback = ((Result<MFMailComposeResult, Error>) -> Void)?

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    var data: ComposeMailData
    let callback: MailViewCallback
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        var data: ComposeMailData
        let callback: MailViewCallback
        
        init(
            presentation: Binding<PresentationMode>,
            data: ComposeMailData,
            callback: MailViewCallback
        ) {
            _presentation = presentation
            self.data = data
            self.callback = callback
        }
        
        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            if let error = error {
                callback?(.failure(error))
            } else {
                callback?(.success(result))
            }
            $presentation.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(presentation: presentation, data: data, callback: callback)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setSubject(data.subject)
        vc.setToRecipients(data.recipients)
        vc.setMessageBody(data.message, isHTML: false)
        data.attachments?.forEach {
            vc.addAttachmentData($0.data, mimeType: $0.mimeType, fileName: $0.fileName)
        }
        vc.accessibilityElementDidLoseFocus()
        return vc
    }
    
    func updateUIViewController(
        _ uiViewController: MFMailComposeViewController,
        context: UIViewControllerRepresentableContext<MailView>
    ) { }
    
    static var canSendMail: Bool {
        MFMailComposeViewController.canSendMail()
    }
}
