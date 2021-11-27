//
//  LabelStyle+Extensions.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/26/21.
//

import SwiftUI

extension LabelStyle where Self == HorizontalLabelStyle {
    public static var horizontal: HorizontalLabelStyle { HorizontalLabelStyle() }
}

public struct HorizontalLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon.font(.caption)
            configuration.title.font(.subheadline)
        }
    }
}
