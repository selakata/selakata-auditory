import SwiftUI

struct DialogueView: View {
    @StateObject private var viewModel = DialogueViewModel()
    private let tracks = DummyData.shared.tracks

    var body: some View {
        VStack(spacing: 20) {
            Text("Daftar Percakapan")
                .font(.title)
                .bold()

            List(tracks, id: \.title) { track in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(track.title)
                            .font(.headline)
                        Spacer()
                        Button(action: {
                            viewModel.playDialogue(track.dialogues, from: track.title)
                        }) {
                            Label("Play", systemImage: "play.circle.fill")
                                .labelStyle(.iconOnly)
                                .font(.title2)
                        }
                        .buttonStyle(.borderless)
                    }

                    if viewModel.currentTrackTitle == track.title {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Sedang dibacakan oleh:")
                                .font(.subheadline)
                            Text(viewModel.currentSpeaker)
                                .font(.headline)
                                .foregroundColor(.blue)
                            Text(viewModel.currentLine)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.vertical, 6)
            }
            .listStyle(.insetGrouped)
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
