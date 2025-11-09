//
//  HearingTestResultsView.swift
//  selakata
//
//  Created by Anisa Amalia on 25/10/25.
//

import SwiftUI
import Charts

struct HearingTestResultsView: View {
    
    @StateObject private var viewModel: HearingTestResultsViewModel
    let isFromProfile: Bool
    @Binding var isStartingTest: Bool
    @ScaledMetric var horizontalPadding: CGFloat = 24
    
    init(isStartingTest: Binding<Bool>, repository: HearingTestRepository) {
        self._isStartingTest = isStartingTest
        self.isFromProfile = false
        _viewModel = StateObject(wrappedValue: HearingTestResultsViewModel(repository: repository))
    }
    
    init(isFromProfile: Bool, repository: HearingTestRepositoryProtocol) {
        self._isStartingTest = .constant(false)
        self.isFromProfile = isFromProfile
        _viewModel = StateObject(wrappedValue: HearingTestResultsViewModel(repository: repository))
    }

    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 4) {
                Text("Signal to Noise Ratio")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                if let snr = viewModel.snr {
                    Text(String(format: "%.1f", Float(snr)))
                        .font(.system(size: 40, weight: .bold))
                    + Text("db")
                        .font(.body)
                        .foregroundStyle(.primary)
                } else {
                    Text("N/A")
                        .font(.system(size: 60, weight: .bold))
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .cornerRadius(16)
            
            HearingTestChartView(
                leftThresholds: viewModel.leftThresholds,
                rightThresholds: viewModel.rightThresholds
            )
        
            if !isFromProfile {
                HStack(alignment: .top, spacing: 16) {
                    Image(systemName: "bell")
                        .font(.system(size: 32, weight: .regular))
                        .foregroundStyle(.secondary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Recommended Actions")
                            .font(.subheadline.weight(.semibold))
                        Text("Try to avoid loud environments and consider using hearing protection or training tools.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: 250, alignment: .leading)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.thinMaterial)
                .cornerRadius(16)
            }
            
            Spacer()
            
            if !isFromProfile {
                Button(action: {
                    isStartingTest = false
                }) {
                    Text("Continue")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.bottom)
            }
            
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.top)
        .navigationTitle((isFromProfile ? "Hearing Test Result" : "Result"))
        .navigationBarTitleDisplayMode(isFromProfile ? .inline : .large)
        .navigationBarBackButtonHidden(!isFromProfile)
        .onAppear {
            viewModel.loadResults()
        }
        .toolbar(isFromProfile ? .hidden : .automatic, for: .tabBar)
    }
}

#Preview {
    let repository = HearingTestRepository()
    
    let dataLeftThresholds: [Double: Float] = [
        500: -50, 1000: -55, 2000: -45, 4000: -40
    ]
    let dataRightThresholds: [Double: Float] = [
        500: -30, 1000: -35, 2000: -30, 4000: -25
    ]
    
    repository.saveThresholds(for: .left, thresholds: dataLeftThresholds)
    repository.saveThresholds(for: .right, thresholds: dataRightThresholds)
    repository.saveSNR(10)
    
    return NavigationStack {
        HearingTestResultsView(
            isStartingTest: .constant(true),
            repository: repository)
    }
}
