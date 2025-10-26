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
    @ScaledMetric var horizontalPadding: CGFloat = 24
    
    init(repository: HearingTestRepository) {
        _viewModel = StateObject(wrappedValue: HearingTestResultsViewModel(repository: repository))
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 24) {
                    HearingTestChartView(
                        leftResult: viewModel.leftResult,
                        rightResult: viewModel.rightResult
                    )
                    .padding(.top, 16)
                    
                    HStack(spacing: 16) {
                        if let left = viewModel.leftResult {
                            ResultSummaryCard(
                                pta: left.pta,
                                snr: left.snr,
                                ear: .left,
                                description: viewModel.getHearingLossDescription(for: left.pta)
                            )
                        }
                        
                        if let right = viewModel.rightResult {
                            ResultSummaryCard(
                                pta: right.pta,
                                snr: right.snr,
                                ear: .right,
                                description: viewModel.getHearingLossDescription(for: right.pta)
                            )
                        }
                    }
                    
                    InfoDetailCard()
                    
                    Spacer()
                    
                    NavigationLink(destination: HomeView()){
                        Text("Continu")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, horizontalPadding)
                }
                .padding(.horizontal, horizontalPadding)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Hearing Test Result")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.loadResults()
        }
    }
}

struct ResultSummaryCard: View {
    let pta: Float
    let snr: Float
    let ear: Ear
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(String(format: "%.0f", pta))
                .font(.largeTitle.weight(.bold))
            
            Text("dBFS (PTA)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Divider().padding(.vertical, 4)
            
            Text(String(format: "%.1f", snr))
                .font(.title2.weight(.medium))
            Text("dB (Est. SNR)")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(ear.title)
                .font(.subheadline.weight(.semibold))
            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 160, alignment: .leading)
        .background(.gray.opacity(0.1))
        .cornerRadius(16)
    }
}

struct InfoDetailCard: View {
    var body: some View {
        VStack(spacing: 24) {
            HStack(alignment: .top, spacing: 16) {
                Image(systemName: "ear.trianglebadge.exclamationmark")
                    .font(.system(size: 32))
                    .foregroundStyle(.secondary)
                
                VStack(alignment: .leading) {
                    Text("Hearing Ability Overview")
                        .font(.headline.weight(.semibold))
                    Text("Your test indicates your baseline hearing ability.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            HStack(alignment: .top, spacing: 16) {
                Image(systemName: "bell")
                    .font(.system(size: 32))
                    .foregroundStyle(.secondary)
                
                VStack(alignment: .leading) {
                    Text("Recommended Actions")
                        .font(.headline.weight(.semibold))
                    Text("Try to avoid loud environments and consider using hearing protection or training tools.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.gray.opacity(0.1))
        .cornerRadius(16)
    }
}

#Preview {
    let repository = HearingTestRepository()
    let leftData = HearingTestResult(
        thresholds: [500: 45, 1000: 45, 2000: 50],
        pta: -70,
        snr: 5
    )
    let rightData = HearingTestResult(
        thresholds: [500: 50, 1000: 45, 2000: 50],
        pta: -30,
        snr: 17
    )

    repository.saveResult(for: .left, result: leftData)
    repository.saveResult(for: .right, result: rightData)
    
    return NavigationStack {
        HearingTestResultsView(repository: repository)
    }
}

