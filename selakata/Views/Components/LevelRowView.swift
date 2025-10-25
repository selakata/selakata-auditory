import SwiftUI

struct LevelRowView: View {
    let level: LevelData
    let module: Module
    let isUnlocked: Bool
        var body: some View {
        Text("aisDebug" + level.moduleId)
        NavigationLink(
            destination: QuizView(questionCategory: QuestionCategory(rawValue: QuestionCategory.RawValue(level.moduleId)) ?? QuestionCategory.identification, level: level.id)
        ) {
            HStack(spacing: 16) {
                // Level Number Circle
                ZStack {
                    Circle()
                        .fill(isUnlocked ? level.difficultyColor : Color.gray)
                        .frame(width: 50, height: 50)
                    
                    if level.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    } else if !isUnlocked {
                        Image(systemName: "lock.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    } else {
                        Text("\(level.id)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                
                // Level Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(level.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(isUnlocked ? .primary : .gray)
                        
                        Spacer()
                        
                        // Difficulty Badge
                        Text(level.difficulty.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(level.difficultyColor.opacity(0.2))
                            .foregroundColor(level.difficultyColor)
                            .cornerRadius(8)
                    }
                    
                    Text(level.description)
                        .font(.subheadline)
                        .foregroundColor(isUnlocked ? .secondary : .gray)
                        .lineLimit(2)
                    
                    HStack {
                        Text("\(level.questionCount) questions")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if level.progress > 0 {
                            Text(level.progressPercentage)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(level.difficultyColor)
                        }
                    }
                    
                    // Progress Bar
                    if level.progress > 0 {
                        ProgressView(value: level.progress / 100.0)
                            .progressViewStyle(LinearProgressViewStyle(tint: level.difficultyColor))
                            .frame(height: 4)
                    }
                }
                
                // Arrow or Status
                Group {
                    if isUnlocked {
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isUnlocked ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(!isUnlocked)
        .opacity(isUnlocked ? 1.0 : 0.6)
    }
}

#Preview {
    VStack(spacing: 12) {
        LevelRowView(
            level: LevelData(
                id: 1,
                name: "Level 1",
                description: "Basic identification exercises",
                difficulty: .easy,
                progress: 85.0,
                isUnlocked: true,
                questionCount: 4,
                moduleId: "identification"
            ),
            module: Module(
                id: "identification",
                name: "Identification",
                details: "Test module",
                progress: 0.0,
                image: "ear.fill",
                orderIndex: 0
            ),
            isUnlocked: true
        )
        
        LevelRowView(
            level: LevelData(
                id: 2,
                name: "Level 2",
                description: "Intermediate identification challenges",
                difficulty: .medium,
                progress: 45.0,
                isUnlocked: true,
                questionCount: 6,
                moduleId: "identification"
            ),
            module: Module(
                id: "identification",
                name: "Identification",
                details: "Test module",
                progress: 0.0,
                image: "ear.fill",
                orderIndex: 0
            ),
            isUnlocked: true
        )
        
        LevelRowView(
            level: LevelData(
                id: 3,
                name: "Level 3",
                description: "Advanced identification mastery",
                difficulty: .hard,
                progress: 0.0,
                isUnlocked: true,
                questionCount: 6,
                moduleId: "identification"
            ),
            module: Module(
                id: "identification",
                name: "Identification",
                details: "Test module",
                progress: 0.0,
                image: "ear.fill",
                orderIndex: 0
            ),
            isUnlocked: true
        )
    }
    .padding()
}
