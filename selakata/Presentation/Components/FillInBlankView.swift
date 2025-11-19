import SwiftUI

struct FillInBlankView: View {
    let question: Question
    @Binding var userAnswer: String
    let hasAnswered: Bool
    let isCorrect: Bool?
    let onSubmit: () -> Void
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Question Text
            Text(question.text)
                .font(.app(.body))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer().frame(height: 8)
            
            // Text Field
            VStack(spacing: 12) {
                TextField("Ketik jawaban di sini...", text: $userAnswer)
                    .textFieldStyle(.plain)
                    .font(.app(.body))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(backgroundColor)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderColor, lineWidth: 2)
                    )
                    .disabled(hasAnswered)
                    .focused($isTextFieldFocused)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                // Feedback
                if hasAnswered {
                    HStack(spacing: 8) {
//                        Image(systemName: isCorrect == true ? "checkmark.circle.fill" : "xmark.circle.fill")
//                            .foregroundColor(isCorrect == true ? .Primary._200 : .red.opacity(0.1))
//                        
//                        Text(feedbackText)
//                            .font(.app(.caption))
//                            .foregroundColor(isCorrect == true ? .green : .red)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal)
            
            // Submit Button (only show if not answered)
            if !hasAnswered && !userAnswer.isEmpty {
                Button(action: {
                    isTextFieldFocused = false
                    onSubmit()
                }) {
                    Text("Submit")
                        .font(.app(.body))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.Primary._500)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onAppear {
            // Auto-focus text field when view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
        }
    }
    
    private var backgroundColor: Color {
        if hasAnswered {
            return isCorrect == true ? .Primary._200 : .red.opacity(0.1)
        }
        return Color(.systemGray6)
    }
    
    private var borderColor: Color {
        if hasAnswered {
            return isCorrect == true ? .Primary._500 : .red.opacity(0.5)
        }
        return Color(.systemGray4)
    }
    
    private var feedbackText: String {
        if isCorrect == true {
            return "Benar! 🎉"
        } else {
            // Show correct answer
            let correctAnswer = question.answerList.first(where: { $0.isCorrect })?.text ?? ""
            return "Salah. Jawaban yang benar: \(correctAnswer)"
        }
    }
}

#Preview("Not Answered") {
    FillInBlankView(
        question: Question(
            id: "1",
            text: "Ketik kata yang kamu dengar",
            urutan: 1,
            mainRMS: -15,
            noiseRMS: 0,
            isActive: true,
            snr: nil,
            poin: 10,
            type: 2,
            createdAt: "2024-11-16",
            updatedAt: "2024-11-16",
            updatedBy: "system",
            answerList: [
                Answer(
                    id: "1",
                    text: "Dasi",
                    urutan: 1,
                    isCorrect: true,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                )
            ],
            audioFile: nil,
            noiseFile: nil
        ),
        userAnswer: .constant(""),
        hasAnswered: false,
        isCorrect: nil,
        onSubmit: {
            print("Submit tapped")
        }
    )
    .padding()
}

#Preview("Answered Correct") {
    FillInBlankView(
        question: Question(
            id: "1",
            text: "Ketik kata yang kamu dengar",
            urutan: 1,
            mainRMS: -15,
            noiseRMS: 0,
            isActive: true,
            snr: nil,
            poin: 10,
            type: 2,
            createdAt: "2024-11-16",
            updatedAt: "2024-11-16",
            updatedBy: "system",
            answerList: [
                Answer(
                    id: "1",
                    text: "Dasi",
                    urutan: 1,
                    isCorrect: true,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                )
            ],
            audioFile: nil,
            noiseFile: nil
        ),
        userAnswer: .constant("Dasi"),
        hasAnswered: true,
        isCorrect: true,
        onSubmit: {}
    )
    .padding()
}

#Preview("Answered Wrong") {
    FillInBlankView(
        question: Question(
            id: "1",
            text: "Ketik kata yang kamu dengar",
            urutan: 1,
            mainRMS: -15,
            noiseRMS: 0,
            isActive: true,
            snr: nil,
            poin: 10,
            type: 2,
            createdAt: "2024-11-16",
            updatedAt: "2024-11-16",
            updatedBy: "system",
            answerList: [
                Answer(
                    id: "1",
                    text: "Dasi",
                    urutan: 1,
                    isCorrect: true,
                    createdAt: "2024-11-16",
                    updatedAt: "2024-11-16"
                )
            ],
            audioFile: nil,
            noiseFile: nil
        ),
        userAnswer: .constant("Dara"),
        hasAnswered: true,
        isCorrect: false,
        onSubmit: {}
    )
    .padding()
}
