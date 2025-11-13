//
//  SNRTestView.swift
//  selakata
//
//  Created by Anisa Amalia on 02/11/25.
//

import SwiftUI

struct SNRTestView: View {
    @Binding var isStartingTest: Bool
    @StateObject private var viewModel: SNRTestViewModel
    @ObservedObject private var audioPlayerService: AudioPlayerService
    
    @ScaledMetric var horizontalPadding: CGFloat = 32
    @ScaledMetric var iconSize: CGFloat = 100
    
    init(isStartingTest: Binding<Bool>, repository: HearingTestRepository, audioPlayerService: AudioPlayerService, submitEarlyTestUseCase: SubmitEarlyTestUseCase) {
        self._isStartingTest = isStartingTest
        let vm = SNRTestViewModel(
            repository: repository,
            audioPlayerService: audioPlayerService,
            submitEarlyTestUseCase: submitEarlyTestUseCase
        )
        _viewModel = StateObject(wrappedValue: vm)
        self.audioPlayerService = vm.audioPlayerService
    }

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: "speaker.wave.2.fill")
                .font(.system(size: iconSize))
                .padding(60)
                .background(.thinMaterial, in: Circle())
                .opacity(audioPlayerService.isPlaying ? 1.0 : 0.4)
                .animation(.easeInOut, value: audioPlayerService.isPlaying)
            
            // question
            Text(viewModel.currentQuestionText)
                .font(.title2.weight(.semibold))
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                ChoiceButton(title: "Yes", action: {
                    viewModel.userTapped(answer: true)
                })
                
                ChoiceButton(title: "No", action: {
                    viewModel.userTapped(answer: false)
                })
            }
            .disabled(audioPlayerService.isPlaying) // wait for the audio to finish baru bisa pilih
            
            Spacer()
        }
        .padding(horizontalPadding)
        .onAppear {
            viewModel.startTest()
        }
        .onDisappear {
            viewModel.stopAudio()
        }
        .navigationTitle("SNR Test")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $viewModel.isTestFinished) {
            HearingTestResultsView(
                isStartingTest: $isStartingTest,
                repository: viewModel.repository,
                submitEarlyTestUseCase: viewModel.submitEarlyTestUseCase
            )
        }
    }
}

struct ChoiceButton: View {
    let title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, minHeight: 44)
        }
        .buttonStyle(.bordered)
        .tint(.secondary)
    }
}

#Preview {
    class MockProgressDataSource: ProgressDataSource {
        func submitEarlyTest(data: EarlyTestSubmitRequest, completion: @escaping (Result<EmptyResponse, Error>)->Void) {
            completion(.success(EmptyResponse()))
        }
    }
    let mockDataSource = MockProgressDataSource()
    let mockProgressRepo = ProgressRepositoryImpl(dataSource: mockDataSource)
    let submitUseCase = SubmitEarlyTestUseCase(repository: mockProgressRepo)
    
    return NavigationStack {
        SNRTestView(
            isStartingTest: .constant(true),
            repository: HearingTestRepositoryImpl(),
            audioPlayerService: AudioPlayerService(),
            submitEarlyTestUseCase: submitUseCase
        )
    }
}
