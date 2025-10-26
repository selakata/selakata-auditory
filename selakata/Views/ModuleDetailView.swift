import SwiftUI

struct ModuleDetailView: View {
    let module: Module
    @StateObject private var viewModel = ModuleDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerView
                
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
        .onAppear {
            viewModel.loadLevels(for: module)
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 16) {
            // Module Icon
            Image(systemName: module.image)
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .frame(width: 100, height: 100)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(20)
            
            // Module Title
            Text(module.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Module Info View
    private var moduleInfoView: some View {
        VStack(spacing: 16) {
            // Description
            Text(module.details)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            // Progress
            if module.progress > 0 {
                VStack(spacing: 8) {
                    HStack {
                        Text("Overall Progress")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text("\(Int(module.progress))%")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                    
                    ProgressView(value: module.progress / 100.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Levels View
    private var levelsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Levels")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                ForEach(viewModel.levels) { level in
                    LevelRowView(
                        level: level,
                        module: module,
                        isUnlocked: viewModel.isLevelUnlocked(level)
                    )
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ModuleDetailView(
            module: Module(
                id: "identification",
                name: "Identification",
                details: "Learn to identify and recognize key sounds and speech patterns in various environments.",
                progress: 45.0,
                image: "ear.fill",
                orderIndex: 0
            )
        )
    }
}
