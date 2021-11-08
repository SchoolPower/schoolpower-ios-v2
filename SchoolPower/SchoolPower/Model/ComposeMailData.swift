//
//  ComposeMailData.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/7/21.
//
//  Credit: https://swiftuirecipes.com/blog/send-mail-in-swiftui

import Foundation

struct ComposeMailData {
  let subject: String
  let recipients: [String]?
  let message: String
  let attachments: [AttachmentData]?
}

struct AttachmentData {
  let data: Data
  let mimeType: String
  let fileName: String
}
