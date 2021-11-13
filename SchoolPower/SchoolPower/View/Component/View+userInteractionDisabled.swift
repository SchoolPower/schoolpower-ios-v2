//
//  View+userInteractionDisabled.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/12/21.
//

import SwiftUI

struct NoHitTesting: ViewModifier {
    func body(content: Content) -> some View {
        SwiftUIWrapper { content }.allowsHitTesting(false)
    }
}
extension View {
    func userInteractionDisabled() -> some View {
        self.modifier(NoHitTesting())
    }
}
struct SwiftUIWrapper<T: View>: UIViewControllerRepresentable {
    let content: () -> T
    func makeUIViewController(context: Context) -> UIHostingController<T> {
        let vc = UIHostingController(rootView: content())
        vc.view.backgroundColor = .clear
        return vc
    }
    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {}
}

