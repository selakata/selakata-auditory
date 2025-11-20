import SwiftUI

struct ReportView: View {
    @StateObject private var viewModel: ReportViewModel
    
    init() {
        let vm = DependencyContainer.shared.makeReportViewModel()
        _viewModel = StateObject(wrappedValue: vm)
    }

    @Environment(\.dismiss) private var dismiss
    @State private var isShowingShareSheet: Bool = false
    @State private var itemsToShare: [Any] = []

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .center, spacing: 20) {
                        Text("Listening performance")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        LazyVGrid(columns: columns, spacing: 15) {
                            PerformanceCard(
                                title: "Word comprehension",
                                value: viewModel.reportData.wordComp,
                                unit: "%",
                                isLoading: viewModel.isLoading
                            )
                            PerformanceCard(
                                title: "Sentence comprehension",
                                value: viewModel.reportData.sentenceComp,
                                unit: "%",
                                isLoading: viewModel.isLoading
                            )
                            PerformanceCard(
                                title: "Speech-in-noise (Environment)",
                                value: viewModel.reportData.speechInNoiseEnv,
                                unit: "%",
                                isLoading: viewModel.isLoading
                            )
                            PerformanceCard(
                                title: "Speech-in-noise (Conversation)",
                                value: viewModel.reportData.speechInNoiseConvo,
                                unit: "%",
                                isLoading: viewModel.isLoading
                            )
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    
                    VStack(spacing: 15) {
                        StatRowCard(
                            icon: "photo",
                            title: "Typical SNR Level",
                            value: viewModel.reportData.snrLevel,
                            unit: "db",
                            isLoading: viewModel.isLoading
                        )
                        StatRowCard(
                            icon: "photo",
                            title: "Repetition Rate",
                            value: viewModel.reportData.repetitionRate != nil ? Double(viewModel.reportData.repetitionRate!) : nil,
                            unit: "",
                            isLoading: viewModel.isLoading
                        )
                        StatRowCard(
                            icon: "photo",
                            title: "Response Time",
                            value: viewModel.reportData.responseTime,
                            unit: "s",
                            isLoading: viewModel.isLoading
                        )
                    }
                }
                .padding()
            }
            .background(Color(.white))
            .navigationTitle("Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.exportToPDF()
                        self.itemsToShare = [""]
                        
                        self.isShowingShareSheet = true
                    }) {
                        Image(systemName: "arrow.down.to.line.circle")
                            .foregroundStyle(.primary)
                    }
                }
            }
            .sheet(isPresented: $isShowingShareSheet) {
                
            }
            .toolbar(.hidden, for: .tabBar)
            .onAppear {
                viewModel.fetchReportData()
            }
        }
    }
}

private struct PerformanceCard: View {
    let title: String
    let value: Int?
    let unit: String
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            if isLoading {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 100, height: 34)
            } else {
                Text(value != nil ? "\(value!)" : "--")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.primary)
                + Text(value != nil ? unit : "")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
        .background(Color.clear)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

private struct StatRowCard: View {
    let icon: String
    let title: String
    let value: Double?
    let unit: String
    let isLoading: Bool
    
    private var formattedValue: String {
        if let value = value {
            if value.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", value)
            } else {
                return String(format: "%.1f", value)
            }
        }
        return "--"
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(.secondary)
                .frame(width: 40, height: 40)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            if isLoading {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 80, height: 34)
            } else {
                Text(formattedValue)
                    .font(.title)
                    .foregroundStyle(.primary)
                + Text(unit)
                    .font(.body)
                    .foregroundStyle(.primary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(Color.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    ReportView()
}

