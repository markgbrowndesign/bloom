//
//  Theme.swift
//  bloom
//
//  Created by Mark Brown on 17/05/2025.
//

import Foundation
import SwiftUI

enum BloomColor {
    enum Bronze {
        static let bronze100 = Color(hex: "F2E1CA")
        static let bronze200 = Color(hex: "DBB594")
        static let bronze300 = Color(hex: "B88C67")
        static let bronze400 = Color(hex: "AD7F58")
        static let bronze500 = Color(hex: "7C5F46")
        static let bronze600 = Color(hex: "614A39")
        static let bronze700 = Color(hex: "4D3C2F")
        static let bronze800 = Color(hex: "3E3128")
        static let bronze900 = Color(hex: "322922")
        static let bronze1000 = Color(hex: "28211D")
        static let bronze1100 = Color(hex: "1C1816")
        static let bronze1200 = Color(hex: "1A0D08")
    }
    
    enum Red {
        static let red100 = Color(hex: "F6F3F3")
        static let red200 = Color(hex: "F5EFED")
        static let red300 = Color(hex: "F4E1DC")
        static let red400 = Color(hex: "F9D1C8")
        static let red500 = Color(hex: "F6C2B6")
        static let red600 = Color(hex: "F0B1A3")
        static let red700 = Color(hex: "E89D8C")
        static let red800 = Color(hex: "DE826E")
        static let red900 = Color(hex: "E54D2E")
        static let red1000 = Color(hex: "D73D1D")
        static let red1100 = Color(hex: "C22800")
        static let red1200 = Color(hex: "5C281C")
    }
    
}

enum Theme {
    static let primaryBackground = BloomColor.Bronze.bronze1200
    static let buttonBackground = BloomColor.Bronze.bronze400
    static let actionBackground = BloomColor.Bronze.bronze800
    static let fillBackground = BloomColor.Bronze.bronze600
    static let sectionBackground = BloomColor.Bronze.bronze700.opacity(0.25)
    
    static let textButton = BloomColor.Bronze.bronze200
    
    static let textPrimary = BloomColor.Bronze.bronze100
    static let textSecondary = BloomColor.Bronze.bronze100.opacity(0.6)
    
    enum Destructive {
        enum Text {
            static let primary = BloomColor.Red.red200
            static let secondary = BloomColor.Red.red100.opacity(0.75)
        }
        enum Background {
            static let strong = BloomColor.Red.red1100
            static let weak = BloomColor.Red.red1200.opacity(0.25)
        }
    }
}

enum Layout {
    static let headerHeight: CGFloat = 375
    static let buttonPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 12
}

// Extension for hex color
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
