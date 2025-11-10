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
        case "Identification": return moduleImages[0]
        case "Discrimination": return moduleImages[1]
        case "Comprehension": return moduleImages[2]
        default: return moduleImages[3]
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 0) {
                    headerView
                    VStack(spacing: 24) {
                        moduleInfoView
                        levelsView
                    }
                    .padding(22)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .background(
                        Color.white
                            .cornerRadius(24, corners: [.topLeft, .topRight])
                    )
                    .offset(y: -20)
                }
            }
        }
        .background(
            VStack {
                Color(hex: 0xEFECFC)
                    .ignoresSafeArea()
                Color.white
            }
        )
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
        VStack{
            Image(systemName: moduleImage)
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .frame(width: 100, height: 100)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(20)
        }
        .frame(maxWidth: .infinity, minHeight: 220)
    }

    // MARK: - Module Info View
    private var moduleInfoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(module.label)
                .font(.app(.headline))
                .fontWeight(.bold)
            Text(module.desc)
                .font(.app(.subhead))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Levels View
    private var levelsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Exercises")
                    .font(.app(.headline))
                    .fontWeight(.bold)
                Spacer()
                HStack {
                    Image(systemName: "folder")
                    Text("3 Levels")
                        .font(.app(.body))
                }
                .foregroundStyle(Color.green)
            }

            ForEach(module.levelList, id: \.id) { level in
                LevelRowView(
                    level: level,
                    moduleLabel: module.label
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationView {
        ModuleDetailView(
            module: QuizData.dummyModule[0]
        )
    }
}
