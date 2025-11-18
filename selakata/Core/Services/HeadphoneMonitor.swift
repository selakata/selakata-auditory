import Foundation
import AVFoundation
import Combine

@MainActor
class HeadphoneMonitor: ObservableObject {

    @Published var isConnected: Bool = false

    private let session = AVAudioSession.sharedInstance()
    private var cancellable: Any?

    init() {
        try? session.setCategory(
            .playAndRecord,
            mode: .default,
            options: [.allowBluetooth]
        )
        try? session.setActive(true)

        startMonitoring()
        updateConnectionStatus()
    }

    private func startMonitoring() {
        cancellable = NotificationCenter.default.publisher(
            for: AVAudioSession.routeChangeNotification
        )
        .receive(on: RunLoop.main)
        .sink { [weak self] _ in
            self?.updateConnectionStatus()
        }
    }

    private func updateConnectionStatus() {
        let outputs = session.currentRoute.outputs
        let connected = outputs.contains { output in
            switch output.portType {
            case .headphones, .bluetoothA2DP, .bluetoothLE, .bluetoothHFP:
                return true
            default:
                return false
            }
        }

        if self.isConnected != connected {
            self.isConnected = connected
            print("Headphone connection changed → \(connected)")
        }
    }

    func stopMonitoring() {
        cancellable = nil
        try? session.setActive(false)
    }
}
