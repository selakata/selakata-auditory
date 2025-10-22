//
//  LevelRowView.swift
//  selakata
//
//  Created by Anisa Amalia on 21/10/25.
//


import SwiftUI

struct LevelRowView: View {
    @Bindable var level: Level
    let isUnlocked: Bool
    
    @ScaledMetric var iconBackgroundSize: CGFloat = 40
    @ScaledMetric var levelCardPadding: CGFloat = 12
    @ScaledMetric var levelCardHeight: CGFloat = 75

    var body: some View {
        HStack(spacing: 16) {
            TimelineIndicator(isCompleted: level.isCompleted)
//                .opacity(isUnlocked ? 1.0 : 0.4)

            NavigationLink(destination: Text("Question page for \(level.name)")) {
                HStack(spacing: 12) {
                    Image(systemName: isUnlocked ? "play.fill" : "lock.fill")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .frame(width: iconBackgroundSize, height: iconBackgroundSize)
                        .background(
                            Circle()
                                .fill(Color.gray.opacity(isUnlocked ? 0.2 : 0.1))
                        )
                    
                    Text(level.name)
                        .fontWeight(.semibold)
                        .foregroundStyle(isUnlocked ? .primary : .secondary)
                    
                    Spacer()
                }
                .padding(levelCardPadding)
                .frame(maxWidth: .infinity)
                .frame(height: levelCardHeight)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(12)
            }
            .disabled(!isUnlocked)
            .buttonStyle(.plain)
        }
    }
}

struct TimelineIndicator: View {
    let isCompleted: Bool
    @ScaledMetric var circleSize: CGFloat = 20

    var body: some View {
        ZStack {
            if isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: circleSize))
                    .foregroundStyle(.gray)
                    .background(Circle().fill(Color(UIColor.systemBackground)).frame(width: circleSize, height: circleSize))
            } else {
                Circle()
                    .strokeBorder(Color.gray.opacity(0.5), lineWidth: 5)
                    .background(Circle().fill(Color(UIColor.systemBackground)))
                    .frame(width: circleSize, height: circleSize)
            }
        }
        .zIndex(1)
    }
}

#Preview {
    let level1 = Level(name: "Level 1", orderIndex: 0, isCompleted: true)
    let level2 = Level(name: "Level 2", orderIndex: 1, isCompleted: false)
    let level3 = Level(name: "Level 3", orderIndex: 2, isCompleted: false)
    
    VStack(spacing: 16) {
        LevelRowView(level: level1, isUnlocked: true)
        LevelRowView(level: level2, isUnlocked: true)
        LevelRowView(level: level3, isUnlocked: false)
    }
    .padding()
}
