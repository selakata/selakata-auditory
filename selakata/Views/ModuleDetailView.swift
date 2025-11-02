import SwiftUI

struct ModuleDetailView: View {
    let module: Module
    @Environment(\.dismiss) private var dismiss

    let moduleImages = [
        "ear.fill", "waveform.path.ecg", "brain.head.profile",
        "person.2.wave.2",
    ]
    var moduleImage: String {
        switch module.label {
        case "Identification":
            return moduleImages[0]
        case "Discrimination":
            return moduleImages[1]
        case "Comprehension":
            return moduleImages[2]
        default:
            return moduleImages[3]
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                headerView

                Spacer().frame(height: 8)
                // Module Info
                moduleInfoView
                
                // Levels
                levelsView

                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.primary)
                }
            }
        }
    }

    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 16) {
            // Module Icon
            Image(systemName: moduleImage)
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .frame(width: 100, height: 100)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(20)
        }
    }

    // MARK: - Module Info View
    private var moduleInfoView: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            // Description
            Text(module.label)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            Text(module.desc)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
            Color.white.frame(height: 0)
        }
    }

    // MARK: - Levels View
    private var levelsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Exercises")
                .font(.title2)
                .fontWeight(.bold)

            ForEach(module.levelList, id: \.id) { level in
                LevelRowView(
                    level: level,
                    module: module,
                )
            }
        }
    }
}

#Preview {
    NavigationView {
        ModuleDetailView(
            module: QuizData.dummyModule[0]
        )
    }
}
