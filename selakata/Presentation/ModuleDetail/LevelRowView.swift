import SwiftUI

struct LevelRowView: View {
    let index: Int
    let level: Level
    let isLast: Bool
    
    var body: some View {
        HStack {
            ZStack {
                if (index > 0) {
                    Rectangle()
                        .fill(Color.Default._100)
                        .frame(width: 2, height: 30)
                        .offset(y: -30)
                }
                if (!isLast) {
                    Rectangle()
                        .fill(Color.Default._100)
                        .frame(width: 2, height: 30)
                        .offset(y: 30)
                }
                Circle()
                    .fill(level.isUnlocked ? Color.Primary._500 : Color(hex: 0xF2EFFF))
                    .frame(width: 18, height: 18).padding(16)
                Circle()
                    .fill(Color.white)
                    .frame(width: 8, height: 8).padding(16)
            }.frame(maxWidth: 24)
            
            Spacer().frame(width: 8)
            
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(level.isUnlocked ? level.isPassed ? Color.Primary._500 : Color.white : Color(hex: 0xBFB4F6))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: level.isUnlocked ? "play.fill" : "lock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(level.isUnlocked ? level.isPassed ? Color.white : Color.Primary._500 : Color.white)
                }
                
                Text("Level \(level.value)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(level.isUnlocked ? level.isPassed ? Color.Primary._500 : Color.white : Color(hex: 0xA5A5A5))
                
                Spacer()
            }
            .frame(minHeight: 60, maxHeight: 60)
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(level.isUnlocked ? level.isPassed ? Color.Primary._200 : Color.Primary._500 : Color(hex: 0xFAF9FF))
            )
        }
    }
}

#Preview {
    LevelRowView(
        index: 0,
        level: Level(
            id: "Easy",
            label: "Easy",
            value: 1,
            isActive: true,
            createdAt: "2025-11-14T04:17:29.162+00:00",
            updatedAt: "2025-11-14T04:17:29.162+00:00",
            isUnlocked: true,
            isPassed: true,
            latestScore: 85.0,
            questions: []
        ),
        isLast: false
    )
    .padding()
}
