import SwiftUI

struct DialogueView: View {
    @StateObject private var viewModel = DialogueViewModel()

    private let sampleText = """
    A: Hey, kamu udah makan?
    B: Belum, lagi nunggu delivery.
    A: Wah, jangan kelamaan ya!
    """

    var body: some View {
        VStack(spacing: 20) {
            Text("Percakapan TTS")
                .font(.title)
                .bold()

            VStack {
                Text("Sedang dibacakan oleh:")
                    .font(.headline)
                Text(viewModel.currentSpeaker)
                    .font(.title2)
                    .foregroundColor(.blue)
//                Text("“\(viewModel.currentLine)”")
//                    .font(.body)
//                    .italic()
            }
            .padding()
            .frame(maxWidth: .infinity) 
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)

            Button(action: {
                viewModel.playDialogue(from: sampleText)
            }) {
                Label("Play Dialogue", systemImage: "play.circle.fill")
                    .font(.title2)
            }
            .buttonStyle(.borderedProminent)
            .padding()

            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.reader.onLineStart = { line in
                Task { @MainActor in
                    viewModel.currentSpeaker = line.speaker
                    viewModel.currentLine = line.text
                }
            }
        }
    }
}

#Preview {
    DialogueView()
}
