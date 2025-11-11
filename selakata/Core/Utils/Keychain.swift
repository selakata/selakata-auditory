//
//  Keychain.swift
//  selakata
//
//  Created by ais on 11/11/25.
//

import Foundation
import Security

func saveToKeychain(value: String, for key: String) {
    if let data = value.data(using: .utf8) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Hapus dulu kalau sudah ada
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
}

func getFromKeychain(for key: String) -> String? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecReturnData as String: true,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    var dataTypeRef: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
    
    if status == errSecSuccess, let data = dataTypeRef as? Data {
        return String(data: data, encoding: .utf8)
    }
    return nil
}

func deleteFromKeychain(for key: String) {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key
    ]
    SecItemDelete(query as CFDictionary)
}
