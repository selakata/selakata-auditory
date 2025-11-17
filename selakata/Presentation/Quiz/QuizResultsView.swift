import SwiftUI

struct QuizResultsView: View {
    let score: Int
    let totalQuestions: Int
    let repetitions: Int
    let onRestart: () -> Void
    let onDismiss: () -> Void

    private var perfectHits: Int {
        score
    }

    private var oopsMoments: Int {
        totalQuestions - score
    }

    private var averageResponseTime: String {
        "2.5s"  // Mock data - can be calculated later
    }

    var body: some View {
        Spacer().frame(height: 100)
        VStack(spacing: 16) {
            // Title
            Text("Level has completed!")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)

            // Brain illustration
            Image(score * 10 >= 80 ? "quiz_completed" : "quiz_notpass")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(height: 220)

            // Score
            VStack() {
                Text("Score:")
                    .font(.title3)
                    .foregroundColor(.secondary)

                Text("\(score * 10)")
                    .font(.system(size: 72, weight: .bold))
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 10)

            // Stats Card
            HStack(spacing: 0) {
                // Perfect hits
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.yellow.opacity(0.2))
                            .frame(width: 50, height: 50)
                        Image(systemName: "star.fill")
                            .font(.title3)
                            .foregroundColor(.yellow)
                    }

                    Text("Perfect hits")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("\(perfectHits)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)

                Divider()
                    .frame(height: 80)

                // Oops moments
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.2))
                            .frame(width: 50, height: 50)
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.red)
                    }

                    Text("Oops moments")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("\(oopsMoments)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)

                Divider()
                    .frame(height: 80)

                // Repetition
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 50, height: 50)
                        Image(systemName: "arrow.clockwise")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }

                    Text("Repetition")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("\(repetitions)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.white).opacity(0))
                    .border(Color(.secondarySystemBackground), width: 1)
            )

            .padding(.horizontal, 24)

            // Response time
            HStack(spacing: 4) {
                Text("Your response times")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(averageResponseTime)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
            }

            Spacer().frame(height: 16)
            // Go to Module Detail Button
            UtilsButton(
                title: "Go to Module Detail",
                leftIcon: nil,
                isLoading: false,
                variant: .primary,
                action: onDismiss
            )
            .padding(.horizontal, 24)
            
            Spacer().frame(height: 100)
            Spacer().frame(height: 100)


        .background(Color(.systemBackground))
    }
}

#Preview {
        score: 13,
        score: 7,
        totalQuestions: 15,
        repetitions: 5,
        onRestart: {},
        onDismiss: {}
    )
}
