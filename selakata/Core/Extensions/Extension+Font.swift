//
//  AppFont.swift
//  selakata
//
//  Created by ais on 03/11/25.
//


import SwiftUI

enum AppFont {
    case largeTitle
    case title
    case headline
    case body
    case callout
    case subhead
    case footnote
    case caption
    
    var font: Font {
        switch self {
        case .largeTitle: return .custom("DMSans-Bold", size: 34)
        case .title:      return .custom("DMSans-SemiBold", size: 28)
        case .headline:   return .custom("DMSans-Medium", size: 20)
        case .body:       return .custom("DMSans-Regular", size: 17)
        case .callout:    return .custom("DMSans-Regular", size: 12)
        case .subhead:    return .custom("DMSans-Medium", size: 17)
        case .footnote:   return .custom("DMSans-Regular", size: 13)
        case .caption:    return .custom("DMSans-Regular", size: 10)
        }
    }
}

extension Font {
    static func app(_ style: AppFont) -> Font {
        style.font
    }
}
