//  Created by ais on 03/11/25.

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
    enum Primary {
        static let _100 = Color(hex: 0xF9F8FE)
        static let _200 = Color(hex: 0xF2EFFF)
        static let _300 = Color(hex: 0xEEEBFF)
        static let _400 = Color(hex: 0xC8BDFC)
        static let _500 = Color(hex: 0x5E43E8)
        static let _600 = Color(hex: 0x5135CD)
    }
    
    enum Tertiary {
        static let _100 = Color(hex: 0xFFF9EB)
        static let _200 = Color(hex: 0xFCECBD)
        static let _300 = Color(hex: 0xFFE7A6)
        static let _400 = Color(hex: 0xFFDD80)
        static let _500 = Color(hex: 0xFFC645)
        static let _600 = Color(hex: 0xFFB91A)
    }
    
    enum Default {
        static let _50 = Color(hex: 0xF6F6F6)
        static let _100 = Color(hex: 0xE7E7E7)
        static let _200 = Color(hex: 0xD1D1D1)
        static let _300 = Color(hex: 0xB0B0B0)
        static let _400 = Color(hex: 0x888888)
        static let _500 = Color(hex: 0x6D6D6D)
        static let _600 = Color(hex: 0x5D5D5D)
        static let _700 = Color(hex: 0x4F4F4F)
        static let _800 = Color(hex: 0x454545)
        static let _900 = Color(hex: 0x3D3D3D)
        static let _950 = Color(hex: 0x1E1E1E)
    }
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
    static let success = Color(hex: 0x44BA70)
    //    static let warning = Color(hex: 0xFFCC00)
    static let danger = Color(hex: 0xFF6363)
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
