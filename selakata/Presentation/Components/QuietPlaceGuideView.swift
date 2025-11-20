//
//  QuietPlaceGuideView.swift
//  selakata
//
//  Created by Anisa Amalia on 25/10/25.
//

import SwiftUI

struct QuietPlaceGuideView: View {
    @ScaledMetric var iconSize: CGFloat = 200
    @ScaledMetric var horizontalPadding: CGFloat = 32

    @Binding var isStartingTest: Bool
    
    let audioService: AudioService
    let repository: HearingTestRepository
    let submitEarlyTestUseCase: SubmitEarlyTestUseCase
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "dot.radiowaves.left.and.right")
                .font(.system(size: iconSize))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 20) {
                Text("Settle in a quiet place where you can focus.")
                    .font(.title.weight(.bold))
                    .multilineTextAlignment(.center)
                
                Text("Background noise can affect your results. Move to a calmer place for the most accurate result.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            NavigationLink(destination: EarTestView(
                isStartingTest: $isStartingTest,
                ear: .left,
                audioService: audioService,
                repository: repository,
                submitEarlyTestUseCase: submitEarlyTestUseCase
            )) {
                Text("Next")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
        }
        .padding(horizontalPadding)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    class MockProgressDataSource: ProgressDataSource {
        func fetchReport(completion: @escaping (Result<ReportAPIResponse, any Error>) -> Void) {
            
        }
        
        func submitEarlyTest(data: EarlyTestSubmitRequest, completion: @escaping (Result<EmptyResponse, Error>)->Void) {
            completion(.success(EmptyResponse()))
        }
    }
    let mockDataSource = MockProgressDataSource()
    let mockProgressRepo = ProgressRepositoryImpl(dataSource: mockDataSource)
    let submitUseCase = SubmitEarlyTestUseCase(repository: mockProgressRepo)

    return NavigationStack {
        QuietPlaceGuideView(
            isStartingTest: .constant(true),
            audioService: AudioService(),
            repository: HearingTestRepositoryImpl(),
            submitEarlyTestUseCase: submitUseCase
        )
    }
}
