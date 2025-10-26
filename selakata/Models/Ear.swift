//
//  Ear.swift
//  selakata
//
//  Created by Anisa Amalia on 25/10/25.
//


import Foundation

enum Ear {
    case left
    case right
    
    var title: String {
        switch self {
        case .left:
            return "Left Ear"
        case .right:
            return "Right Ear"
        }
    }
}
