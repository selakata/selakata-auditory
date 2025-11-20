//
//  HearingTestGuideView.swift
//  selakata
//
//  Created by Anisa Amalia on 23/10/25.
//

import SwiftUI

struct HearingTestGuideView: View {
    @ScaledMetric var iconSize: CGFloat = 200
    @ScaledMetric var horizontalPadding: CGFloat = 32
    
    @Binding var isStartingTest: Bool
    let audioService: AudioService
    let repository: HearingTestRepository
    let submitEarlyTestUseCase: SubmitEarlyTestUseCase

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "airpods.gen3")
                .font(.system(size: iconSize))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 20) {
                Text("Wear your earphones comfortably")
                    .font(.title.weight(.bold))
                    .multilineTextAlignment(.center)
                
                Text("Placing your earphones in the correct ear helps to get the most accurate results.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            NavigationLink(destination: QuietPlaceGuideView(
                isStartingTest: $isStartingTest,
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
        HearingTestGuideView(
            isStartingTest: .constant(true),
             audioService: AudioService(),
             repository: HearingTestRepositoryImpl(),
             submitEarlyTestUseCase: submitUseCase
        )
    }
}
