//
//  SNRGuideView.swift
//  selakata
//
//  Created by Anisa Amalia on 02/11/25.
//

import SwiftUI

struct SNRGuideView: View {
    @Binding var isStartingTest: Bool
    let repository: HearingTestRepository
    let submitEarlyTestUseCase: SubmitEarlyTestUseCase
    
    @State private var audioPlayerService = AudioPlayerService()
    
    @ScaledMetric var horizontalPadding: CGFloat = 32
    @ScaledMetric var iconSize: CGFloat = 200
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "waveform.path")
                .font(.system(size: iconSize))
                .foregroundStyle(.secondary)
                .padding(.bottom, 24)
            
            Text("SNR Test Required")
                .font(.title.weight(.bold))
            
            Text("Before starting your training, please complete a quick SNR (Signal-to-Noise Ratio) test.\n\nThis helps us track your progress.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            NavigationLink(destination: SNRTestView(
                isStartingTest: $isStartingTest,
                repository: repository,
                audioPlayerService: audioPlayerService,
                submitEarlyTestUseCase: submitEarlyTestUseCase
            )) {
                Text("Get Started")
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
        .padding(.bottom)
        .navigationTitle("SNR Test")
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
        SNRGuideView(
            isStartingTest: .constant(true),
            repository: HearingTestRepositoryImpl(),
            submitEarlyTestUseCase: submitUseCase
        )
    }
}
