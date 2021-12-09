//
//  HideTitleBarOnCatalyst.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-12-08.
//
//  Credit: https://stackoverflow.com/a/65243349

import SwiftUI

extension View {
    func hideTitleBarOnCatalyst() -> some View {
        #if targetEnvironment(macCatalyst)
        self.withHostingWindow { window in
            if let titlebar = window?.windowScene?.titlebar {
                titlebar.titleVisibility = .hidden
                titlebar.toolbar = nil
            }
        }
        #else
        self
        #endif
    }
    
    fileprivate func withHostingWindow(_ callback: @escaping (UIWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

fileprivate struct HostingWindowFinder: UIViewRepresentable {
    var callback: (UIWindow?) -> ()
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
