import SwiftUI

struct QuizResultsView: View {
    let score: Int
    let totalQuestions: Int
    let onRestart: () -> Void
    let onDismiss: () -> Void

    private var percentage: Double {
        Double(score) / Double(totalQuestions) * 100
    }

    private var resultMessage: String {
        switch percentage {
        case 90...100:
            return "Excellent!"
        case 70..<90:
            return "Great job!"
        case 50..<70:
            return "Good effort!"
        default:
            return "Keep practicing!"
        }
    }

    private var resultColor: Color {
//        switch percentage {
//        case 90...100:
//            return .green
//        case 70..<90:
//            return .blue
//        case 50..<70:
//            return .orange
//        default:
//            return .red
//        }
        return .gray
    }

    var body: some View {
        VStack(spacing: 24) {
            // Header with drag indicator space
            VStack(spacing: 16) {
                // Result Icon and Message
                HStack(spacing: 16) {
                    Image(systemName: percentage >= 70 ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(resultColor)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(resultMessage)
                            .font(.title2)
                            .fontWeight(.bold)
//                            .foregroundColor(resultColor)
                        
                        Text("Score: \(score)/\(totalQuestions) (\(Int(percentage))%)")
                            .font(.subheadline)
//                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                // Compact Progress Bar
                VStack(spacing: 8) {
                    HStack {
                        Text("Your Progress")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(percentage))%")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(resultColor)
                    }
                    
                    ProgressView(value: percentage / 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: resultColor))
                        .frame(height: 8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            // Action Buttons
            VStack(spacing: 12) {
                Button(action: onRestart) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Try Again")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                }
                .background(
//                    Capsule().fill(Color(.systemIndigo))
                    Capsule().fill(Color(.darkGray))
                )
                
                Button(action: onDismiss) {
                    HStack {
                        Image(systemName: "house.fill")
                        Text("Back to Menu")
                    }
                    .font(.headline)
                    .foregroundStyle(Color(.darkGray))
//                    .foregroundStyle(Color(.systemIndigo))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                }
                .background(
//                    Capsule().stroke(Color(.systemIndigo), lineWidth: 2)
                    Capsule().stroke(Color(.darkGray), lineWidth: 2)
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(Color(.systemBackground))
    }
}

#Preview {
    QuizResultsView(
        score: 2,
        totalQuestions: 3,
        onRestart: {},
        onDismiss: {}
    )
}
