//
//  UIApplication+Extensions.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-12-15.
//

import Foundation
import UIKit

extension UIApplication {
    var firstForgroundActiveScene: UIWindowScene? {
        connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
    }
}
