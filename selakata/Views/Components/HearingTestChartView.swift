//
//  HearingTestChartView.swift
//  selakata
//
//  Created by Anisa Amalia on 26/10/25.
//

import SwiftUI
import Charts

struct HearingDataPoint: Identifiable {
    let id = UUID()
    let ear: Ear
    let frequency: Double
    let threshold: Float
}

struct HearingTestChartView: View {
    let leftResult: HearingTestResult?
    let rightResult: HearingTestResult?
    
    @State private var chartData: [HearingDataPoint] = []
    
    let yDomain: ClosedRange<Float> = 0 ... 100
    let xDomain: ClosedRange<Double> = 400 ... 6000
    
    private let minDBFS: Float = -80
    private let maxDBFS: Float = -6

    var body: some View {
        Chart(chartData) { dataPoint in
            LineMark(
                x: .value("Frequency (Hz)", dataPoint.frequency),
                y: .value("Threshold (%)", dataPoint.threshold)
            )
            .foregroundStyle(by: .value("Ear", dataPoint.ear.title))
            
            PointMark(
                x: .value("Frequency (Hz)", dataPoint.frequency),
                y: .value("Threshold (%)", dataPoint.threshold)
            )
            .foregroundStyle(by: .value("Ear", dataPoint.ear.title))
            .symbol(by: .value("Ear", dataPoint.ear.title))
        }
        .chartXScale(domain: xDomain, type: .log)
        .chartXAxis {
            AxisMarks(
                values: [500.0, 1000.0, 2000.0, 4000.0]
            ) { value in
                if let freq = value.as(Double.self) {
                    AxisValueLabel(String(format: "%.0f", freq))
                }
            }
        }
        .chartYScale(domain: yDomain)
        .chartYAxis {
            AxisMarks(position: .leading, values: [0, 25, 50, 75, 100]) { value in
                AxisValueLabel("\(value.as(Int.self) ?? 0)%")
            }
        }
        .chartForegroundStyleScale([
            Ear.left.title: Color.blue,
            Ear.right.title: Color.red
        ])
        .chartLegend(position: .top, alignment: .center)
        .frame(height: 300)
        .padding()
        .background(.thinMaterial)
        .cornerRadius(16)
        .onAppear {
            self.chartData = createChartData()
        }
        .onChange(of: leftResult?.pta) {
            self.chartData = createChartData()
        }
    }
    
    private func convertDBFSToPercentage(dbfs: Float) -> Float {
        let clampedDBFS = min(max(dbfs, minDBFS), maxDBFS)
        let hearingRange = abs(minDBFS - maxDBFS)
        let distanceFromWorst = abs(clampedDBFS - maxDBFS)
        let percentage = (distanceFromWorst / hearingRange) * 100
        return percentage
    }
    
    // Converts the result dictionaries into an array for the chart
    private func createChartData() -> [HearingDataPoint] {
        var data: [HearingDataPoint] = []
        
        if let left = leftResult {
            left.thresholds.forEach { freq, threshold in
                let percent = convertDBFSToPercentage(dbfs: threshold)
                data.append(HearingDataPoint(
                    ear: .left,
                    frequency: freq,
                    threshold: percent
                ))
            }
        }
        
        if let right = rightResult {
            right.thresholds.forEach { freq, threshold in
                let percent = convertDBFSToPercentage(dbfs: threshold)
                data.append(HearingDataPoint(
                    ear: .right,
                    frequency: freq,
                    threshold: percent
                ))
            }
        }
        return data.sorted(by: { $0.frequency < $1.frequency })
    }
}

#Preview {
    let repo = HearingTestRepository()
    let leftData = HearingTestResult(
        thresholds: [500: -45, 1000: -45, 2000: -50, 4000: -55],
        pta: -46.6,
        snr: 12.2
    )
    let rightData = HearingTestResult(
        thresholds: [500: -50, 1000: -45, 2000: -50, 4000: -60],
        pta: -48.3,
        snr: 12.6
    )
    
    repo.saveResult(for: .left, result: leftData)
    repo.saveResult(for: .right, result: rightData)
    
    let viewModel = HearingTestResultsViewModel(repository: repo)
    viewModel.loadResults()
    
    return HearingTestChartView(
        leftResult: viewModel.leftResult,
        rightResult: viewModel.rightResult
    )
}
