//
//  SchoolPowerApp.swift
//  SchoolPower
//
//  Created by Carbonyl on 2021-11-01.
//

import SwiftUI

@main
struct SchoolPowerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension Font {
    
    /// Create a font with the large title text style.
    public static var largeTitle: Font {
        return Font.custom("Poppins-Regular", size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
    }
    
    /// Create a font with the title text style.
    public static var title: Font {
        return Font.custom("Poppins-Regular", size: UIFont.preferredFont(forTextStyle: .title1).pointSize)
    }
    
    /// Create a font with the title text style.
    public static var title2: Font {
        return Font.custom("Poppins-Regular", size: UIFont.preferredFont(forTextStyle: .title2).pointSize)
    }
    
    /// Create a font with the headline text style.
    public static var headline: Font {
        return Font.custom("Poppins-Regular", size: UIFont.preferredFont(forTextStyle: .headline).pointSize)
    }
    
    /// Create a font with the subheadline text style.
    public static var subheadline: Font {
        return Font.custom("Poppins-Regular", size: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
    }
    
    /// Create a font with the body text style.
    public static var body: Font {
        return Font.custom("Poppins-Regular", size: UIFont.preferredFont(forTextStyle: .body).pointSize)
    }
    
    /// Create a font with the callout text style.
    public static var callout: Font {
        return Font.custom("Poppins-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize)
    }
    
    /// Create a font with the footnote text style.
    public static var footnote: Font {
        return Font.custom("Poppins-Regular", size: UIFont.preferredFont(forTextStyle: .footnote).pointSize)
    }
    
    /// Create a font with the caption text style.
    public static var caption: Font {
        return Font.custom("Poppins-Regular", size: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
    }
    
    public static func system(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        var font = "Poppins-Regular"
        switch weight {
        case .bold: font = "Poppins-SemiBold"
        case .heavy: font = "Poppins-SemiBold"
        case .light: font = "Poppins-Light"
        case .medium: font = "Poppins-Regular"
        case .semibold: font = "Poppins-SemiBold"
        case .thin: font = "Poppins-Regular"
        case .ultraLight: font = "Poppins-Regular"
        default: break
        }
        return Font.custom(font, size: size)
    }
}
