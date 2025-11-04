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
    let leftThresholds: [Double: Float]?
    let rightThresholds: [Double: Float]?
    
    @State private var chartData: [HearingDataPoint] = []
    
    let yDomain: ClosedRange<Float> = 0 ... 100
    let xDomain: ClosedRange<Double> = 400 ... 6000
    
    private let minDBFS: Float = -80
    private let maxDBFS: Float = -6

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            let leftPTA = HearingTestCalculator.calculatePTA(from: leftThresholds)
            let rightPTA = HearingTestCalculator.calculatePTA(from: rightThresholds)
            let leftPercent = HearingTestCalculator.convertDBFSToPercentage(dbfs: leftPTA)
            let rightPercent = HearingTestCalculator.convertDBFSToPercentage(dbfs: rightPTA)

            Text("Est. hearing level (dbfs)")
                .font(.headline.weight(.medium))
            
            HStack {
                Text(String(format: "L %.0f%%", leftPercent))
                    .font(.largeTitle.weight(.medium))
                    .foregroundStyle(.accent)
                
                Spacer()
                
                Text(String(format: "%.0f%% R", rightPercent))
                    .font(.largeTitle.weight(.medium))
                    .foregroundStyle(.red)
            }
            
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
            }
            .chartXScale(domain: xDomain, type: .log)
            .chartXAxis {
                AxisMarks(values: [500.0, 1000.0, 2000.0, 4000.0]) { value in
                    if let freq = value.as(Double.self) {
                        AxisValueLabel(String(format: "%.0f", freq))
                    }
                    AxisGridLine(stroke: StrokeStyle(dash: [2, 3]))
                }
            }
            .chartYScale(domain: yDomain)
            .chartYAxis {
                AxisMarks(position: .leading, values: [0, 25, 50, 75, 100]) { value in
                    AxisValueLabel("\(value.as(Int.self) ?? 0)%")
                    AxisGridLine(stroke: StrokeStyle(dash: [2, 3]))
                }
            }
//            .chartXAxisLabel("Frequency (Hz)", alignment: .center)
//            .chartYAxisLabel("Hearing Level (%)", position: .leading, alignment: .center)
            .chartForegroundStyleScale([
                Ear.left.title: Color.accent,
                Ear.right.title: Color.red
            ])
            .chartLegend(.hidden)
            .frame(height: 150)
            
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(16)
        .onAppear {
            self.chartData = createChartData()
        }
        .onChange(of: leftThresholds) {
            self.chartData = createChartData()
        }
    }
    
    // Converts the result dictionaries into an array for the chart
    private func createChartData() -> [HearingDataPoint] {
        var data: [HearingDataPoint] = []
        
        if let left = leftThresholds {
            left.forEach { freq, threshold in
                let percent = HearingTestCalculator.convertDBFSToPercentage(dbfs: threshold)
                data.append(HearingDataPoint(ear: .left, frequency: freq, threshold: percent))
            }
        }
        
        if let right = rightThresholds {
            right.forEach { freq, threshold in
                let percent = HearingTestCalculator.convertDBFSToPercentage(dbfs: threshold)
                data.append(HearingDataPoint(ear: .right, frequency: freq, threshold: percent))
            }
        }
        
        return data.sorted(by: { $0.frequency < $1.frequency })
    }
}

#Preview {
    let dataLeftThresholds: [Double: Float] = [
        500: -50, 1000: -55, 2000: -45, 4000: -40
    ]
    let dataRightThresholds: [Double: Float] = [
        500: -30, 1000: -35, 2000: -30, 4000: -25
    ]
    
    return HearingTestChartView(
        leftThresholds: dataLeftThresholds,
        rightThresholds: dataRightThresholds
    )
    .padding()
}
