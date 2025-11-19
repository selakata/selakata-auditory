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
    
    @State private var showHeadphoneCheck = false
    @State private var pendingLevelId: String? = nil
    @State private var goToQuiz = false
    
    let backgrounds: [Int: String] = [
        1: "0x5E43E8",
        2: "0x277DFF",
        3: "0xFAC53E",
        4: "0xFF6363",
    ]
    var color: Color {
        let value = backgrounds[module.value] ?? backgrounds[1]!
        let hexValue = Int(value.replacingOccurrences(of: "0x", with: ""), radix: 16)!
        return Color(hex: hexValue)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack(spacing: 0) {
                Color(color)
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
                                exerciseList
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            viewModel.fetchLevels()
        }
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $showHeadphoneCheck) {
            HeadphoneCheckView(
                levelId: pendingLevelId!,
                onSuccess: {
                    showHeadphoneCheck = false
                    goToQuiz = true
                }
            )
        }
        .navigationDestination(isPresented: $goToQuiz) {
            if let id = pendingLevelId {
                QuizView(levelId: id)
            } else {
                EmptyView()
            }
        }
    }
    
    private var exerciseList: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(viewModel.levels.indices, id: \.self) { index in
                if viewModel.levels[index].isUnlocked {
                    Button {
                        pendingLevelId = viewModel.levels[index].id
                        showHeadphoneCheck = true
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
