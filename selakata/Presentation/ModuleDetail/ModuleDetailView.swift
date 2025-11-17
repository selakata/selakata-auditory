import SwiftUI

struct ModuleDetailView: View {
    let module: Module
    @StateObject private var viewModel: ModuleDetailViewModel
    
    init(module: Module) {
        self.module = module
        _viewModel = StateObject(
            wrappedValue: DependencyContainer.shared.makeModuleDetailViewModel(moduleId: module.id)
        )
    }
    
    @EnvironmentObject var mainVM: MainViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack(spacing: 0) {
                Color(hex: 0x6A4BFF)
                    .frame(height: UIScreen.main.bounds.height * 0.5)
                
                Color.white
                    .frame(height: UIScreen.main.bounds.height * 0.5)
            }
            .ignoresSafeArea()
            
            VStack {
                Color.clear.frame(height: UIScreen.main.bounds.height * 0.05)
                Image(safe: "mascot-\(module.label.slugified)", default: "mascot")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 250, height: 250)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    Color.clear.frame(height: UIScreen.main.bounds.height * 0.3)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(module.label)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.Default._950)
                            
                            Text(module.description)
                                .font(.callout)
                                .foregroundColor(Color.Default._950)
                        }
                        
                        Text("Exercise")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.Default._950)
                        
                        if viewModel.isLoading {
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(0..<4, id: \.self) { _ in
                                    SkeletonView(height: 70, cornerRadius: 20)
                                }
                            }
                        } else {
                            if !viewModel.levels.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    ForEach(viewModel.levels.indices, id: \.self) { index in
                                        if viewModel.levels[index].isUnlocked {
                                            NavigationLink {
                                                QuizView(levelId: viewModel.levels[index].id)
                                            } label: {
                                                LevelRowView(
                                                    index: index,
                                                    level: viewModel.levels[index],
                                                    isLast: index == viewModel.levels.count - 1
                                                )
                                            }
                                        } else {
                                            Button {
                                                mainVM.showModal(
                                                    image: Image("icon-love"),
                                                    title: "Complete Previous Level",
                                                    description: "Finish the previous level to unlock this one!",
                                                    ctaText: "Continue"
                                                )
                                            } label: {
                                                LevelRowView(
                                                    index: index,
                                                    level: viewModel.levels[index],
                                                    isLast: index == viewModel.levels.count - 1
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(
                        Color.white
                            .clipShape(RoundedCorner(radius: 28, corners: [.topLeft, .topRight]))
                    )
                }
            }
        }
        .onAppear {
            viewModel.fetchLevels()
        }
    }
}

#Preview {
    let sample = Module(
        id: "1",
        label: "Comprehension",
        value: 1,
        description: "Listen to short audio clips and choose the correct one. This helps improve your sensitivity to subtle sound changes and background noise",
        isActive: true,
        createdAt: "2025-01-01T00:00:00Z",
        updatedAt: "2025-01-02T00:00:00Z",
        updatedBy: nil,
        isUnlocked: true,
        percentage: 75.0
    )
    
    return NavigationStack {
        ModuleDetailView(module: sample)
    }
}

