//
//  ModuleDetailView.swift
//  selakata
//
//  Created by Anisa Amalia on 21/10/25.
//

import SwiftUI
import SwiftData

struct ModuleDetailView: View {
    let module: Module
    
    @StateObject private var viewModel = ModuleDetailViewModel()

    @ScaledMetric var contentHorizontalPadding: CGFloat = 24
    @ScaledMetric var topImageHeight: CGFloat = 362
    @ScaledMetric var overlapAmount: CGFloat = 50

    var body: some View {
        ZStack(alignment: .top) {
            Image("sampleImage")
                .resizable()
                .frame(height: topImageHeight)
                .frame(maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea(edges: .top)

            infoCardContent
        }
        .background(Color(.systemBackground))
        .toolbar(.hidden, for: .tabBar)
    }
    
    private var infoCardContent: some View {
        ScrollView {
            Spacer().frame(height: topImageHeight - overlapAmount)
            
            VStack(alignment: .leading, spacing: 20) {
                // header
                VStack(alignment: .leading, spacing: 8) {
                    Text(module.name)
                        .font(.title.weight(.bold))
                    Text(module.details)
                        .foregroundStyle(.secondary)
                }
                
                // exercise
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Exercise")
                            .font(.title3.weight(.semibold))
                        Spacer()
                        Image(systemName: "folder")
                        Text("\(module.levels.count) levels")
                    }
                    
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 2)
                            .padding(.leading, 9)

                        VStack(spacing: 16) {
                            let sortedLevels = module.levels.sorted { $0.orderIndex < $1.orderIndex }
                            ForEach(sortedLevels) { level in
                                let isUnlocked = viewModel.isLevelUnlocked(level, in: sortedLevels)
                                LevelRowView(level: level, isUnlocked: isUnlocked)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(contentHorizontalPadding)
            .padding(.top, 20)
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .cornerRadius(20, corners: [.topLeft, .topRight])
        }
        .ignoresSafeArea()
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    let idModule = Module(id: "identification", name: "Identification", details: "Learn to identify and recognize key sounds.", progress: 0.0, image: "ear", orderIndex: 0)
        
    let l1 = Level(name: "Level 1", orderIndex: 0, isCompleted: true, module: idModule)
    let l2 = Level(name: "Level 2", orderIndex: 1, isCompleted: false, module: idModule)
    let l3 = Level(name: "Level 3", orderIndex: 2, isCompleted: false, module: idModule)
    
    NavigationStack {
        ModuleDetailView(module: idModule)
    }
}
