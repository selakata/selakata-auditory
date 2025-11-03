//
//  AppColor.swift
//  selakata
//
//  Created by ais on 03/11/25.
//


import SwiftUI

/// Kumpulan warna global yang digunakan di seluruh aplikasi.
/// Gunakan `AppColor.primary`, `AppColor.background`, dll.
struct AppColor {
    // MARK: - Brand Colors
    static let primary = Color(hex: 0x5E43E8)
    static let secondary = Color(hex: 0x007AFF)
    static let accent = Color(hex: 0x34C759)
    
    // MARK: - Backgrounds
    static let background = Color.white
    static let backgroundAlt = Color(hex: 0xf9f9f9)
    static let headerBackground = Color(hex: 0xf5bc53)
    
    // MARK: - Text
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    
    // MARK: - Status
    static let success = Color(hex: 0x34C759)
    static let warning = Color(hex: 0xFFCC00)
    static let danger = Color(hex: 0xFF3B30)
    
    static let gray = Color(hex: 0xF0F0F0)
}
