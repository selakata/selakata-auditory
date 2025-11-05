//
//  AppColor.swift
//  selakata
//
//  Created by ais on 03/11/25.
//

import SwiftUI

/// Kumpulan warna global yang digunakan di seluruh aplikasi.
/// Contoh penggunaan:
/// ```swift
/// Text("Hello, Selakata!")
///     .foregroundColor(.textPrimary)
///     .background(.backgroundAlt)
/// ```
extension Color {
    // MARK: - Brand Colors
//    static let primary = Color(hex: 0x5E43E8)
//    static let secondary = Color(hex: 0x007AFF)
//    static let accent = Color(hex: 0x34C759)
//    
//    // MARK: - Backgrounds
//    static let background = Color.white
//    static let backgroundAlt = Color(hex: 0xF9F9F9)
//    static let headerBackground = Color(hex: 0xF5BC53)
//    
//    // MARK: - Text
//    static let textPrimary = Color.primary
//    static let textSecondary = Color.secondary
//    
//    // MARK: - Status
//    static let success = Color(hex: 0x34C759)
//    static let warning = Color(hex: 0xFFCC00)
//    static let danger = Color(hex: 0xFF3B30)
//    
//    static let gray = Color(hex: 0xF0F0F0)
//    
//    static let slColor = Color(hex: 0x34C759)
    
    static let slColor = Color(hex: 0x5E43E8)
}

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
