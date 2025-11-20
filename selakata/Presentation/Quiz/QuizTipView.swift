//
//  QuizTipView.swift
//  selakata
//
//  Created by Anisa Amalia on 19/11/25.
//

import SwiftUI

struct QuizTipView: View {
    let levelValue: Int
    @State private var isOverlayVisible = true
    var onDismissHardTip: () -> Void
    
    var body: some View {
        switch levelValue {
        case 1:
            if isOverlayVisible {
                ZStack {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Image("replay-audio")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 325, height: 325)
                            .padding(.top, 360)
                            .padding(.trailing, 70)
                        
                        Spacer()
                        
                        Text("Tap anywhere to continue")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .padding(.bottom, 40)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isOverlayVisible = false
                    }
                }
                .transition(.opacity)
            } else {
                Color.clear
            }
            
        case 3:
            VStack {
                Image("no-replay-audio")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 325, height: 325)
                    .padding(.top, 300)
                    .padding(.trailing, 110)
                
                Spacer()
                
                UtilsButton(title: "Continue", variant: .primary) {
                    onDismissHardTip()
                }
                .padding(.bottom, 40)
                .padding(.horizontal, 24)
                .frame(width: 350, height: 45)
            }
            .background(Color.white.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            
        default:
            Color.clear
        }
    }
}

