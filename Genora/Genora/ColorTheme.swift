//
//  ColorTheme.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 14/12/2025.
//

import SwiftUI

extension Color {
    // MARK: - Hex Initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor(light: UIColor(light), dark: UIColor(dark)))
    }
}

extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return dark
            default:
                return light
            }
        }
    }
}

// MARK: - App Color Palette
extension Color {
    // MARK: - Background Colors
    static let backgroundPrimary = Color(
        light: Color(hex: "#f6b1b1"),
        dark: Color(hex: "#0C0E10")
    )
    
    static let backgroundSecondary = Color(
        light: Color(hex: "#F5F5F5"),
        dark: Color(hex: "#1A1F23")
    )
    
    static let backgroundTertiary = Color(
        light: Color(hex: "#EBEBEB"),
        dark: Color(hex: "#23292F")
    )
    
    // MARK: - Text Colors
    static let textPrimary = Color(
        light: Color(hex: "#000000"),
        dark: Color(hex: "#C1DEEA")
    )
    
    static let textSecondary = Color(
        light: Color(hex: "#666666"),
        dark: Color(hex: "#8B9BAD")
    )
    
    static let textTertiary = Color(
        light: Color(hex: "#999999"),
        dark: Color(hex: "#5A6475")
    )
    
    static let textPositive = Color(
        light: Color(hex: "#1C9B75"),
        dark: Color(hex: "#1C9B75")
    )
    
    static let textNegative = Color(
        light: Color(hex: "#C44B5A"),
        dark: Color(hex: "#C44B5A")
    )
    
    // MARK: - Button Colors
    static let buttonPrimary = Color(
        light: Color(hex: "#007AFF"),
        dark: Color(hex: "#454B5C")
    )
    
    static let buttonSecondary = Color(
        light: Color(hex: "#E5E5E5"),
        dark: Color(hex: "#252A38")
    )
    
    // MARK: - UI Elements
    static let border = Color(
        light: Color(hex: "#D1D1D6"),
        dark: Color(hex: "#586674")
    )
    
    static let divider = Color(
        light: Color(hex: "#E5E5E5"),
        dark: Color(hex: "#1E2230")
    )
    
    static let element = Color(
        light: Color(hex: "#E5E5E5"),
        dark: Color(hex: "#16A085")
    )
}

extension ShapeStyle where Self == Color {
    static var buttonPrimary: Color { Color.buttonPrimary }
    static var buttonSecondary: Color { Color.buttonSecondary }
    static var backgroundPrimary: Color { Color.backgroundPrimary }
    static var backgroundSecondary: Color { Color.backgroundSecondary }
    static var backgroundTertiary: Color { Color.backgroundTertiary }
    static var textPrimary: Color { Color.textPrimary }
    static var textSecondary: Color { Color.textSecondary }
    static var element: Color { Color.element }
    static var border: Color { Color.border }
    static var textPositive: Color { Color.textPositive }
    static var textNegative: Color { Color.textNegative }

}
