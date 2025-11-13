//
//  EarTestView.swift
//  selakata
//
//  Created by Anisa Amalia on 25/10/25.
//

import SwiftUI

struct EarTestView: View {
    @Binding var isStartingTest: Bool
    @StateObject private var viewModel: EarTestViewModel
    
    private let audioService: AudioService
    private let repository: HearingTestRepository
    let submitEarlyTestUseCase: SubmitEarlyTestUseCase
    
    init(isStartingTest: Binding<Bool>, ear: Ear, audioService: AudioService, repository: HearingTestRepository, submitEarlyTestUseCase: SubmitEarlyTestUseCase) {
        self._isStartingTest = isStartingTest
        _viewModel = StateObject(wrappedValue: EarTestViewModel(
            initialEar: ear,
            audioService: audioService,
            repository: repository
        ))
        self.audioService = audioService
        self.repository = repository
        self.submitEarlyTestUseCase = submitEarlyTestUseCase
    }

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: "photo.fill")
                .font(.system(size: 100))
                .padding(60)
                .background(.regularMaterial, in: Circle())
            
            ProgressView(value: viewModel.progress)
                .padding(.horizontal, 40)
            
            Text("Tap the screen if you hear a sound")
                .font(.title3.weight(.semibold))
                .multilineTextAlignment(.center)
            
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .onTapGesture {
            viewModel.userHeardSound()
        }
        .onAppear {
            viewModel.startTest()
        }
        .navigationTitle(viewModel.currentEar.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $viewModel.isTestComplete) {
            if viewModel.currentEar == .left {
                EarTestView(
                    isStartingTest: $isStartingTest,
                    ear: .right,
                    audioService: audioService,
                    repository: repository,
                    submitEarlyTestUseCase: submitEarlyTestUseCase
                )
            } else {
                SNRGuideView(
                    isStartingTest: $isStartingTest,
                    repository: repository,
                    submitEarlyTestUseCase: submitEarlyTestUseCase
                )
            }
        }
    }
}

// brisik
//#Preview {
//    let audioService = AudioService()
//    let repository = HearingTestRepository()
//    
//    return NavigationStack {
//        EarTestView(
//            ear: .left,
//            audioService: audioService,
//            repository: repository
//        )
//    }
//}
