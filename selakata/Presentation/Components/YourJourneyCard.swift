//
//  YourJourneyCard.swift
//  selakata
//
//  Created by Anisa Amalia on 16/11/25.
//

import SwiftUI

struct YourJourneyCard: View {
    let state: HomeViewModel.JourneyCardState
    let onRetry: () -> Void
    let startImageName = "journey-start-image"
    
    var body: some View {
        VStack(spacing: 0) {
            switch state {
            case .loading:
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 15) {
                            SkeletonView(height: 26).frame(width: 96)
                            SkeletonView(height: 22).frame(width: 180)
                            SkeletonView(height: 15).frame(width: 220)
                        }
                        Spacer()
                        SkeletonView(width: 80, height: 80, cornerRadius: 12)
                    }
                    SkeletonView(height: 54, cornerRadius: 10)
                        .frame(width: 300)
                }
                .padding(20)
                .frame(width: 345)
                
            case .newUser(let firstModule):
                NavigationLink(destination: ModuleDetailView(module: firstModule)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Begin your auditory journey!")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.leading)
                            
                            UtilsButton(title: "Start", variant: .primary) {}
                                .frame(width: 100, height: 30)
                                .cornerRadius(10)
                        }
                        .padding(.leading, 24)
                        
                        Spacer()
                        
                        Image(startImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 165, height: 141)
                    }
                    .frame(width: 345, height: 150)
                    .padding(20)
                }
                
            case .inProgress(let module):
                VStack(spacing: 0) {
                    NavigationLink(destination: ModuleDetailView(module: module)) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 15) {
                                Chip(text: "In progress")
                                    .frame(minWidth: 96, minHeight: 26)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color(hex: 0xE7E7E7), lineWidth: 1)
                                    }
                                
                                Text(module.label)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                                
                                Text(module.description)
                                    .font(.body)
                                    .foregroundStyle(.gray)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            
                            Image(safe: "mascot-\(module.label.slugified)", default: "mascot")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 130, height: 130)
                                .alignmentGuide(.bottom) { d in d[.bottom] }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        }
                        .padding(20)
                        .frame(height: 150)
                        .background(Color(hex: 0xF6F6F6))
                    }
                        
                    Divider()
                    
                    VStack(spacing: 16) {
                        VStack(spacing: 8) {
                            HStack {
                                Text("Progress")
                                Spacer()
                                Text("\(Int(module.percentage * 100))% completed")
                            }
                            .font(.footnote)
                            .foregroundStyle(.gray)

                            ProgressView(value: module.percentage)
                                .progressViewStyle(.linear)
                                .frame(height: 8)
                                .tint(Color.accentColor)
                                .clipShape(Capsule())
                        }
                        
                        NavigationLink(destination: ModuleDetailView(module: module)) {
                            Text("Continue")
                                .fontWeight(.semibold)
                                .frame(width: 300, height: 54)
                                .foregroundColor(.white)
                                .background(Color.accentColor)
                                .cornerRadius(10)
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                }
            
            case .error(let message):
                ErrorStateView(
                    title: "Couldn't Load Journey",
                    description: message,
                    ctaText: "Retry"
                ) {
                    onRetry()
                }
                .padding()
            
            case .noModules:
                Text("No modules are available right now.")
                    .padding()
            }
        }
        .frame(width: 345)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: 0xE7E7E7), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    let sampleModule = Module(
        id: "1",
        label: "Identification",
        value: 1,
        description: "Tell the difference between similar sounds",
        isActive: true,
        createdAt: "",
        updatedAt: "",
        updatedBy: nil,
        isUnlocked: true,
        percentage: 0.5
    )
    
    YourJourneyCard(state: .newUser(firstModule: sampleModule), onRetry: {})
        .padding()
    
    YourJourneyCard(state: .inProgress(module: sampleModule), onRetry: {})
        .padding()
}
