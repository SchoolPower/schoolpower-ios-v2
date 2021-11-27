//
//  JSONDecodingOptions+Extension.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/27/21.
//

import SwiftProtobuf

extension JSONDecodingOptions {
    public static let ignoreUnknown: JSONDecodingOptions = {
        var option = JSONDecodingOptions()
        option.ignoreUnknownFields = true
        return option
    }()
}
