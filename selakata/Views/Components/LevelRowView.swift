import SwiftUI

struct LevelRowView: View {
    let level: Level
    let module: Module
    
    var difficultyColor: Color {
        switch level.value {
        case 1:
            return .green
        case 2:
            return .orange
        case 3:
            return .red
        default:
            return .blue
        }
    }
    
    var difficultyText: String {
        switch level.value {
        case 1:
            return "Easy"
        case 2:
            return "Medium"
        case 3:
            return "Hard"
        default:
            return level.label
        }
    }
    
    var questionCategory: QuestionCategory {
        switch module.label {
        case "identification":
            return .identification
        case "discrimination":
            return .discrimination
        case "comprehension":
            return .comprehension
        case "competing_speaker":
            return .competingSpeaker
        default:
            return .identification
        }
    }
    
    var body: some View {
        NavigationLink(
            destination: QuizView(
                module: module,
                level: level,
                questionCategory: questionCategory
            )
        ) {
            HStack(spacing: 16) {
                // Level Number Circle
                ZStack {
                    Circle()
                        .fill(level.isActive ? difficultyColor : Color.gray)
                        .frame(width: 50, height: 50)
                    
                    if !level.isActive {
                        Image(systemName: "lock.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    } else {
                        Text("\(level.value)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                
                // Level Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(level.label)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(level.isActive ? .primary : .gray)
                        
                        Spacer()
                        
                        // Difficulty Badge
                        Text(difficultyText)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(difficultyColor.opacity(0.2))
                            .foregroundColor(difficultyColor)
                            .cornerRadius(8)
                    }
                    
                    Text("\(difficultyText) \(module.label.lowercased()) exercises")
                        .font(.subheadline)
                        .foregroundColor(level.isActive ? .secondary : .gray)
                        .lineLimit(2)
                    
                    HStack {
                        Text("\(level.question.count) questions")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("0%")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(difficultyColor)
                    }
                    
                    // Progress Bar (placeholder)
                    ProgressView(value: 0.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: difficultyColor))
                        .frame(height: 4)
                }
                
                // Arrow or Status
                Group {
                    if level.isActive {
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
                    .stroke(level.isActive ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(!level.isActive)
        .opacity(level.isActive ? 1.0 : 0.6)
    }
}

#Preview {
    VStack(spacing: 12) {
        LevelRowView(
            level: QuizData.dummyModule[0].levelList[0],
            module: QuizData.dummyModule[0],
        )
    }
    .padding()
}
