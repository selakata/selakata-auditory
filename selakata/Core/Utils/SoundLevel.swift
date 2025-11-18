import SwiftUI
import AVFoundation
import UniformTypeIdentifiers

struct AnalysisResults {
    let averageRMS: Float
    let peakRMS: Float
    let averagedBFS: Float
    let peakdBFS: Float
    let dynamicRange: Float
    let totalSamples: Int
}

class SoundLevelMonitor: ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var audioFile: AVAudioFile?
    private var audioPlayerNode = AVAudioPlayerNode()
    
    @Published var decibels: Float = -100.0
    @Published var isPlaying: Bool = false
    @Published var currentTime: TimeInterval = 0.0
    @Published var duration: TimeInterval = 0.0
    @Published var analysisResults: AnalysisResults?
    @Published var targetdBFS: String = "-20.0"
    @Published var isExporting: Bool = false
    @Published var exportProgress: Float = 0.0
    
    // RMS tracking variables - using Double for better precision
    private var sumOfSquares: Double = 0.0
    private var peakRMS: Float = 0.0
    private var totalSamples: Int = 0
    private var bufferCount: Int = 0
    
    init() {
        setupAudioEngine()
    }
    
    private func setupAudioEngine() {
        audioEngine.attach(audioPlayerNode)
        audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: nil)
        
        // Install tap on mixer node to monitor audio levels
        let format = audioEngine.mainMixerNode.outputFormat(forBus: 0)
        audioEngine.mainMixerNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            let level = self.getSoundLevel(buffer: buffer)
            DispatchQueue.main.async {
                self.decibels = level
            }
        }
    }
    
    func loadAudioFile(url: URL) {
        do {
            audioFile = try AVAudioFile(forReading: url)
            duration = Double(audioFile!.length) / audioFile!.fileFormat.sampleRate
            print("Audio file loaded: \(url.lastPathComponent)")
            print("Duration: \(duration) seconds")
            print("Sample rate: \(audioFile!.fileFormat.sampleRate)")
            print("Channels: \(audioFile!.fileFormat.channelCount)")
            
            // Calculate RMS directly from file (like Audacity)
            calculateFileRMS()
        } catch {
            print("Error loading audio file: \(error)")
        }
    }
    
    private func calculateFileRMS() {
        guard let audioFile = audioFile else { return }
        
        let frameCount = AVAudioFrameCount(audioFile.length)
        let format = audioFile.processingFormat
        
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
        
        do {
            try audioFile.read(into: buffer)
            
            var sumOfSquares: Double = 0.0
            var totalSamples = 0
            let channelCount = Int(format.channelCount)
            
            // Process all channels
            for channel in 0..<channelCount {
                guard let channelData = buffer.floatChannelData?[channel] else { continue }
                
                for i in 0..<Int(buffer.frameLength) {
                    let sample = Double(channelData[i])
                    sumOfSquares += sample * sample
                    totalSamples += 1
                }
            }
            
            if totalSamples > 0 {
                let fileRMS = sqrt(sumOfSquares / Double(totalSamples))
                let filedBFS = fileRMS > 0 ? 20 * log10(fileRMS) : -100.0
                
                print("File Analysis - RMS: \(fileRMS)")
                print("File Analysis - dBFS: \(filedBFS)")
                
                // Store as reference for comparison
                analysisResults = AnalysisResults(
                    averageRMS: Float(fileRMS),
                    peakRMS: Float(fileRMS), // Will be updated during playback
                    averagedBFS: Float(filedBFS),
                    peakdBFS: Float(filedBFS),
                    dynamicRange: 0.0,
                    totalSamples: totalSamples
                )
            }
        } catch {
            print("Error reading audio file for RMS calculation: \(error)")
        }
    }
    
    func startPlayback() {
        guard let audioFile = audioFile else {
            print("No audio file loaded")
            return
        }
        
        // Reset analysis data
        sumOfSquares = 0.0
        peakRMS = 0.0
        totalSamples = 0
        bufferCount = 0
        analysisResults = nil
        
        do {
            try audioEngine.start()
            audioPlayerNode.scheduleFile(audioFile, at: nil) {
                DispatchQueue.main.async {
                    self.isPlaying = false
                    self.currentTime = 0.0
                    self.generateFinalResults()
                }
            }
            audioPlayerNode.play()
            isPlaying = true
            
            // Start time tracking
            startTimeTracking()
        } catch {
            print("Error starting playback: \(error)")
        }
    }
    
    func stopPlayback() {
        audioPlayerNode.stop()
        audioEngine.stop()
        isPlaying = false
        currentTime = 0.0
        decibels = -100.0  // Reset to silent state
    }
    
    private func startTimeTracking() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if self.isPlaying {
                if let nodeTime = self.audioPlayerNode.lastRenderTime,
                   let playerTime = self.audioPlayerNode.playerTime(forNodeTime: nodeTime) {
                    self.currentTime = Double(playerTime.sampleTime) / playerTime.sampleRate
                }
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func getSoundLevel(buffer: AVAudioPCMBuffer) -> Float {
        guard let channelData = buffer.floatChannelData else { return -100.0 }
        
        let frameLength = Int(buffer.frameLength)
        let channelCount = Int(buffer.format.channelCount)
        
        // Calculate RMS for current buffer (for real-time display)
        var bufferSumSquares: Double = 0.0
        var totalFrames = 0
        
        // Process all channels (mono/stereo handling)
        for channel in 0..<channelCount {
            let channelDataArray = Array(UnsafeBufferPointer(start: channelData[channel], count: frameLength))
            
            for sample in channelDataArray {
                let doubleSample = Double(sample)
                bufferSumSquares += doubleSample * doubleSample
                totalFrames += 1
            }
        }
        
        // Store data for final analysis (only if playing)
        if isPlaying && frameLength > 0 {
            sumOfSquares += bufferSumSquares
            totalSamples += totalFrames
            bufferCount += 1
            
            // Track peak RMS per buffer
            let bufferRMS = sqrt(bufferSumSquares / Double(totalFrames))
            peakRMS = max(peakRMS, Float(bufferRMS))
        }
        
        // Calculate RMS for current buffer display
        if totalFrames > 0 {
            let rms = sqrt(bufferSumSquares / Double(totalFrames))
            if rms > 0 {
                let dBFS = 20 * log10(rms)
                return max(Float(dBFS), -100.0)
            }
        }
        
        return -100.0
    }
    
    private func generateFinalResults() {
        guard totalSamples > 0 else { return }
        
        // Calculate true RMS over entire audio file (like Audacity does)
        let overallRMS = sqrt(sumOfSquares / Double(totalSamples))
        
        // Convert to dBFS using high precision
        let averagedBFS = overallRMS > 0 ? 20 * log10(overallRMS) : -100.0
        let peakdBFS = peakRMS > 0 ? 20 * log10(Double(peakRMS)) : -100.0
        
        // Calculate dynamic range (difference between peak and average)
        let dynamicRange = peakdBFS - averagedBFS
        
        print("Debug - Overall RMS: \(overallRMS)")
        print("Debug - Average dBFS: \(averagedBFS)")
        print("Debug - Total samples: \(totalSamples)")
        print("Debug - Buffer count: \(bufferCount)")
        
        analysisResults = AnalysisResults(
            averageRMS: Float(overallRMS),
            peakRMS: peakRMS,
            averagedBFS: Float(averagedBFS),
            peakdBFS: Float(peakdBFS),
            dynamicRange: Float(dynamicRange),
            totalSamples: totalSamples
        )
    }
    
    func exportAudioWithTargetdBFS(completion: @escaping (URL?) -> Void) {
        guard let audioFile = audioFile,
              let targetdBFSValue = Float(targetdBFS),
              let currentResults = analysisResults else {
            completion(nil)
            return
        }
        
        isExporting = true
        exportProgress = 0.0
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                // Calculate gain needed to reach target dBFS
                let currentdBFS = currentResults.averagedBFS
                let gainNeeded = targetdBFSValue - currentdBFS
                let linearGain = pow(10.0, gainNeeded / 20.0)
                
                print("Current dBFS: \(currentdBFS)")
                print("Target dBFS: \(targetdBFSValue)")
                print("Gain needed: \(gainNeeded) dB")
                print("Linear gain: \(linearGain)")
                
                // Create output file URL
                let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let outputURL = documentsPath.appendingPathComponent("adjusted_audio.wav")
                
                // Remove existing file if it exists
                try? FileManager.default.removeItem(at: outputURL)
                
                // Create output audio file
                let outputFile = try AVAudioFile(forWriting: outputURL, settings: [
                    AVFormatIDKey: kAudioFormatLinearPCM,
                    AVSampleRateKey: audioFile.fileFormat.sampleRate,
                    AVNumberOfChannelsKey: audioFile.fileFormat.channelCount,
                    AVLinearPCMBitDepthKey: 32,
                    AVLinearPCMIsFloatKey: true
                ])
                
                // Process audio in chunks
                let chunkSize: AVAudioFrameCount = 4096
                let totalFrames = audioFile.length
                var processedFrames: AVAudioFramePosition = 0
                
                audioFile.framePosition = 0
                
                while processedFrames < totalFrames {
                    let framesToRead = min(chunkSize, AVAudioFrameCount(totalFrames - processedFrames))
                    
                    guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: framesToRead) else {
                        break
                    }
                    
                    try audioFile.read(into: buffer, frameCount: framesToRead)
                    
                    // Apply gain to all channels
                    let channelCount = Int(buffer.format.channelCount)
                    for channel in 0..<channelCount {
                        guard let channelData = buffer.floatChannelData?[channel] else { continue }
                        
                        for i in 0..<Int(buffer.frameLength) {
                            channelData[i] *= Float(linearGain)
                            
                            // Prevent clipping
                            channelData[i] = max(-1.0, min(1.0, channelData[i]))
                        }
                    }
                    
                    try outputFile.write(from: buffer)
                    processedFrames += AVAudioFramePosition(buffer.frameLength)
                    
                    // Update progress
                    DispatchQueue.main.async {
                        self.exportProgress = Float(processedFrames) / Float(totalFrames)
                    }
                }
                
                DispatchQueue.main.async {
                    self.isExporting = false
                    self.exportProgress = 1.0
                    completion(outputURL)
                }
                
            } catch {
                print("Export error: \(error)")
                DispatchQueue.main.async {
                    self.isExporting = false
                    completion(nil)
                }
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var monitor = SoundLevelMonitor()
    @State private var showingFilePicker = false
    @State private var showingExportAlert = false
    @State private var exportedFileURL: URL?
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    HStack {
                        Text("Audio File Analyzer")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                
                Text(formatdBFS(monitor.decibels))
                    .font(.system(size: 50, weight: .heavy, design: .monospaced))
                    .foregroundColor(getdBFSColor(monitor.decibels))
                    .shadow(radius: 5)
                    .scaleEffect(1.2)
                    .animation(.spring(), value: monitor.decibels)
                
                // Time display
                if monitor.duration > 0 {
                    VStack {
                        Text("\(formatTime(monitor.currentTime)) / \(formatTime(monitor.duration))")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ProgressView(value: monitor.currentTime, total: monitor.duration)
                            .progressViewStyle(LinearProgressViewStyle(tint: .white))
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                    }
                    .padding(.horizontal)
                }
                
                // Analysis Results
                if let results = monitor.analysisResults {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Analysis Results")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                        
                        HStack {
                            Text("Average RMS:")
                                .foregroundColor(.white)
                            Spacer()
                            Text(String(format: "%.6f", results.averageRMS))
                                .foregroundColor(.cyan)
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            Text("Peak RMS:")
                                .foregroundColor(.white)
                            Spacer()
                            Text(String(format: "%.6f", results.peakRMS))
                                .foregroundColor(.yellow)
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            Text("Average dBFS:")
                                .foregroundColor(.white)
                            Spacer()
                            Text(String(format: "%.1f dBFS", results.averagedBFS))
                                .foregroundColor(.cyan)
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            Text("Peak dBFS:")
                                .foregroundColor(.white)
                            Spacer()
                            Text(String(format: "%.1f dBFS", results.peakdBFS))
                                .foregroundColor(.yellow)
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            Text("Dynamic Range:")
                                .foregroundColor(.white)
                            Spacer()
                            Text(String(format: "%.1f dB", results.dynamicRange))
                                .foregroundColor(.green)
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            Text("Total Samples:")
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(results.totalSamples)")
                                .foregroundColor(.orange)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                    
                Spacer()
                
                Button(action: { showingFilePicker = true }) {
                    Text("Select Audio File")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                
                HStack {
                    Button(action: monitor.startPlayback) {
                        Text(monitor.isPlaying ? "Playing..." : "Play & Analyze")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(monitor.isPlaying ? Color.gray : Color.green)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .disabled(monitor.isPlaying)
                    
                    Button(action: monitor.stopPlayback) {
                        Text("Stop")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                }
                .padding(.horizontal)
                
                // dBFS Adjustment Section
                if monitor.analysisResults != nil {
                    VStack(spacing: 15) {
                        Text("Adjust Audio Level")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack {
                            Text("Target dBFS:")
                                .foregroundColor(.white)
                            
                            TextField("Target dBFS", text: $monitor.targetdBFS)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .frame(width: 100)
                            
                            Text("dBFS")
                                .foregroundColor(.white)
                        }
                        
                        if monitor.isExporting {
                            VStack {
                                Text("Exporting...")
                                    .foregroundColor(.white)
                                
                                ProgressView(value: monitor.exportProgress)
                                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                                    .scaleEffect(x: 1, y: 2, anchor: .center)
                            }
                        } else {
                            Button(action: exportAudio) {
                                Text("Export Adjusted Audio")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.purple)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showingFilePicker) {
            DocumentPicker { url in
                monitor.loadAudioFile(url: url)
            }
        }
        .alert("Export Complete", isPresented: $showingExportAlert) {
            Button("OK") { }
            if let url = exportedFileURL {
                Button("Share") {
                    shareFile(url: url)
                }
            }
        } message: {
            if let url = exportedFileURL {
                Text("Audio exported successfully to:\n\(url.lastPathComponent)")
            } else {
                Text("Audio exported successfully!")
            }
        }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func formatdBFS(_ value: Float) -> String {
        if value <= -100.0 {
            return "Silent"
        } else {
            return String(format: "%.1f dBFS", value)
        }
    }
    
    private func getdBFSColor(_ value: Float) -> Color {
        if value <= -100.0 {
            return .gray     // Silent
        } else if value > -6 {
            return .red      // Very loud (risk of clipping)
        } else if value > -12 {
            return .orange   // Loud
        } else if value > -18 {
            return .yellow   // Moderate
        } else if value > -30 {
            return .green    // Good level
        } else {
            return .blue     // Quiet
        }
    }
    
    private func exportAudio() {
        monitor.exportAudioWithTargetdBFS { url in
            if let url = url {
                exportedFileURL = url
                showingExportAlert = true
            } else {
                // Handle export failure
                print("Export failed")
            }
        }
    }
    
    private func shareFile(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    let onDocumentPicked: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            // Start accessing security-scoped resource
            if url.startAccessingSecurityScopedResource() {
                parent.onDocumentPicked(url)
                url.stopAccessingSecurityScopedResource()
            }
        }
    }
}
