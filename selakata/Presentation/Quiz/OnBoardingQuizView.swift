//
//  OnBoardingQuizView.swift
//  selakata
//
//  Created by ais on 17/11/25.
//

import SwiftUI

struct OnBoardingQuizView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8)
                .ignoresSafeArea()
            
            ZStack {
                Image("mascot-bubble")
                    .resizable()
                    .frame(width: 260, height: 120)
            }
            
            VStack {
                Spacer()
                HStack {
                    Image("mascot-tell")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250)
                    Spacer()
                }
                .padding(.bottom, 40)
            }
            
            
        }
    }
}

#Preview {
    OnBoardingQuizView()
}
