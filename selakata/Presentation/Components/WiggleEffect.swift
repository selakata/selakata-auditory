//
//  WiggleEffect.swift
//  selakata
//
//  Created by Anisa Amalia on 05/11/25.
//


import SwiftUI

struct WiggleEffect: ViewModifier {
    @Binding var wiggleCount: Int
    
    func body(content: Content) -> some View {
        content
            .modifier(Shake(animatableData: CGFloat(wiggleCount)))
    }
}

private struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translationX = amount * sin(animatableData * .pi * CGFloat(shakesPerUnit))
        return ProjectionTransform(CGAffineTransform(translationX: translationX, y: 0))
    }
}
