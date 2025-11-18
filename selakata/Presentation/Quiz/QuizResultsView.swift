import SwiftUI

struct QuizResultsView: View {
    let correctAnswer: Int
    let totalQuestions: Int
    let repetitions: Int
    let averageResponseTime: String
    let onRestart: () -> Void
    let onDismiss: () -> Void

    private var perfectHits: Int {
        correctAnswer
    }

    private var oopsMoments: Int {
        totalQuestions - correctAnswer
    }
    
    private var totalScore: Int {
        Int((Double(correctAnswer) / Double(totalQuestions)) * 100)
    }
    
    var body: some View {
        VStack {
            Text("Level has completed!")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Image(totalScore >= 80 ? "quiz_completed" : "quiz_notpass")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(height: 220)
            
            VStack {
                Text("Score:")
                    .font(.title3)
                    .foregroundColor(Color.Default._400)
                
                Text("\(totalScore)")
                    .font(.system(size: 72, weight: .bold))
                    .foregroundColor(Color.Default._950)
            }
            .padding(.vertical, 10)
            
            HStack(spacing: 0) {
                VStack(spacing: 12) {
                    Image("icon-hits")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    Text("Perfect hits")
                        .font(.caption)
                        .foregroundColor(Color.Default._600)
                    
                    Text("\(perfectHits)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.Default._950)
                }
                .frame(maxWidth: .infinity)

                Divider()
                    .frame(height: 120)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    Image("icon-oops")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    Text("Oops moments")
                        .font(.caption)
                        .foregroundColor(Color.Default._600)
                    
                    Text("\(oopsMoments)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.Default._950)
                }
                .frame(maxWidth: .infinity)

                Divider()
                    .frame(height: 120)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    Image("icon-repeat")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    Text("Repetition")
                        .font(.caption)
                        .foregroundColor(Color.Default._600)
                    
                    Text("\(repetitions)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.Default._950)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.secondarySystemBackground), lineWidth: 1)
            )
            
            HStack(spacing: 4) {
                Text("Your average responses time")
                    .font(.subheadline)
                    .foregroundColor(Color.Default._500)
                Text(averageResponseTime)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.Tertiary._600)
            }
            .padding(10)
            .background(Color.Tertiary._50)
            .cornerRadius(20)
            .padding()
            
            Spacer()
            
            UtilsButton(
                title: "Continue",
                action: onDismiss
            )
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    QuizResultsView(
        correctAnswer: 9,
        totalQuestions: 10,
        repetitions: 2,
        averageResponseTime: "1.2s",
        onRestart: {},
        onDismiss: {}
    )
}
