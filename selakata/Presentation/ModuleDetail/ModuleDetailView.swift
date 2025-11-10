import SwiftUI

struct ModuleDetailView: View {
    let category: Category
    @StateObject private var viewModel: ModuleDetailViewModel
    
    init(category: Category) {
        self.category = category
        
        let apiClient = APIClient()
        let appConfiguration = AppConfiguration()
        let apiConfiguration = LevelAPIConfiguration(configuration: appConfiguration)
        let dataSource: LevelDataSource = RemoteLevelDataSource(apiClient: apiClient, apiConfiguration: apiConfiguration)
        let repository = LevelRepositoryImpl(dataSource: dataSource)
        let levelUseCase = LevelUseCase(repository: repository)
        
        // Buat ViewModel sekali di init
        _viewModel = StateObject(wrappedValue: ModuleDetailViewModel(levelUseCase: levelUseCase, moduleId: category.id))
    }
    
    @Environment(\.dismiss) private var dismiss

    let moduleImages = [
        "waveform.path.ecg","ear.fill","brain.head.profile",
        "person.2.wave.2",
    ]

    var body: some View {
//        Text(viewModel.levelResponse.debugDescription)
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 0) {
                    VStack{
                        Image(systemName: moduleImages[category.value-1])
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                            .frame(width: 100, height: 100)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(20)
                    }
                    .frame(maxWidth: .infinity, minHeight: 220)
                    
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(category.label)
                                .font(.app(.headline))
                                .fontWeight(.bold)
                            Text(category.label)
                                .font(.app(.subhead))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if viewModel.levelResponse != nil {
                            LevelView(levels: viewModel.levelResponse!.data, moduleLabel: category.label)
                        }
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
    
}

#Preview {
    NavigationView {
        ModuleDetailView(
            category: Category(
                id: "1",
                label: "Matematika",
                value: 10,
                description: "Kategori untuk latihan soal matematika dasar.",
                isActive: true,
                createdAt: "2025-01-01T10:00:00Z",
                updatedAt: "2025-01-05T15:00:00Z",
                updatedBy: "admin"
            )
        )
    }
}
