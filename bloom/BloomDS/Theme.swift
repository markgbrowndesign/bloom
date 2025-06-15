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


