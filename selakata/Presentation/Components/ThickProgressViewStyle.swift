//
//  ThickProgressViewStyle.swift
//  selakata
//
//  Created by ais on 17/11/25.
//

import SwiftUI

struct ThickProgressViewStyle: ProgressViewStyle {
    var height: CGFloat = 12
    var tint: Color = .blue

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color.gray.opacity(0.3))
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(tint)
                    .frame(width: geo.size.width * CGFloat(configuration.fractionCompleted ?? 0))
            }
        }
        .frame(height: height)
    }
}
