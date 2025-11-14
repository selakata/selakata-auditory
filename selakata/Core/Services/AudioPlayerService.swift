import AVFoundation
import Foundation

class AudioPlayerService: NSObject, ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    private var remotePlayer: AVPlayer?
    
    private var playerItem: AVPlayerItem?
    private var statusObserver: NSKeyValueObservation?
    private var didPlayToEndObserver: Any?
    
    private var isSessionSetup = false
    
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var playbackRate: Float = 1.0
    @Published var isReady = false
    
    private var timer: Timer?
    
    override init() {
        super.init()
    }
    
    func setupPlayer() {
        guard !isSessionSetup else { return }
        setupAudioSession()
        isSessionSetup = true
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    func loadAudio(fileName: String, fileExtension: String = "mp3") {
        setupPlayer()
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("Could not find audio file: \(fileName).\(fileExtension)")
            // Set dummy duration untuk testing jika file tidak ada
            duration = 30.0
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.enableRate = true
            duration = audioPlayer?.duration ?? 0
            currentTime = 0
        } catch {
            print("Error loading audio: \(error)")
            // Set dummy duration untuk testing jika ada error
            duration = 30.0
        }
    }
    
    func loadAudioFromPath(fileName: String, subdirectory: String? = nil, fileExtension: String = "mp3") {
        setupPlayer()
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension, subdirectory: subdirectory) else {
            print("Could not find audio file: \(fileName).\(fileExtension) in subdirectory: \(subdirectory ?? "root")")
            // Set dummy duration untuk testing jika file tidak ada
            duration = 30.0
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.enableRate = true
            duration = audioPlayer?.duration ?? 0
            currentTime = 0
        } catch {
            print("Error loading audio: \(error)")
            // Set dummy duration untuk testing jika ada error
            duration = 30.0
        }
    }
    
    func loadAudioFromURL(_ url: URL) {
        setupPlayer()
        stop()

        if url.isFileURL {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
                audioPlayer?.enableRate = true
                duration = audioPlayer?.duration ?? 0
                currentTime = 0
            } catch {
                print("Error loading audio from URL: \(error)")
                duration = 0
            }
        } else {
            let asset = AVURLAsset(url: url)
            playerItem = AVPlayerItem(asset: asset)
            
            statusObserver = playerItem?.observe(\.status, options: [.new, .initial]) { [weak self] item, _ in
                guard let self = self else { return }
                if item.status == .readyToPlay {
                    DispatchQueue.main.async {
                        self.duration = item.duration.seconds
                        self.currentTime = 0
                    }
                } else if item.status == .failed {
                    print("AudioPlayerService: Error loading remote stream: \(item.error?.localizedDescription ?? "Unknown error")")
                    DispatchQueue.main.async {
                        self.duration = 0
                    }
                }
            }
            
            didPlayToEndObserver = NotificationCenter.default.addObserver(
                forName: AVPlayerItem.didPlayToEndTimeNotification,
                object: playerItem,
                queue: .main
            ) { [weak self] _ in
                self?.handlePlaybackFinished()
            }

            remotePlayer = AVPlayer(playerItem: playerItem)
            remotePlayer?.rate = playbackRate
        }
    }
    
    func loadAudioFromDocuments(fileName: String) {
        setupPlayer()
        
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Could not find Documents directory")
            duration = 30.0
            return
        }
        
        let url = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.enableRate = true
            duration = audioPlayer?.duration ?? 0
            currentTime = 0
        } catch {
            print("Error loading audio from Documents: \(error)")
            duration = 30.0
        }
    }
    
    func play() {
        setupPlayer()
        
        if let audioPlayer = audioPlayer {
            // Prepare to play if not already prepared
            if !audioPlayer.prepareToPlay() {
                print("⚠️ AudioPlayerService: Failed to prepare audio player")
            }
            
            if audioPlayer.play() {
                isPlaying = true
                isReady = true
                startTimer()
                print("✅ Audio playing successfully")
            } else {
                print("❌ AudioPlayerService: play() returned false")
            }
        } else if let remotePlayer = remotePlayer {
            remotePlayer.play()
            isPlaying = true
            isReady = true
            startTimer()
            print("✅ Remote audio playing successfully")
        } else {
            print("❌ AudioPlayerService: play() failed. Player not ready or file not loaded.")
            isReady = false
        }
    }
    
    func pause() {
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying {
            audioPlayer.pause()
        } else if let remotePlayer = remotePlayer, remotePlayer.rate > 0 {
            remotePlayer.pause()
        }
        
        isPlaying = false
        stopTimer()
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        remotePlayer?.pause()
        remotePlayer?.seek(to: .zero)
        remotePlayer = nil
        
        statusObserver?.invalidate()
        statusObserver = nil
        if let observer = didPlayToEndObserver {
            NotificationCenter.default.removeObserver(observer)
            didPlayToEndObserver = nil
        }
        playerItem = nil
        
        isPlaying = false
        currentTime = 0
        duration = 0
        stopTimer()
    }
    
    func seek(to time: TimeInterval) {
        let seekTime = CMTime(seconds: time, preferredTimescale: 600)
        
        if let audioPlayer = audioPlayer {
            audioPlayer.currentTime = time
            self.currentTime = time
        } else if let remotePlayer = remotePlayer {
            remotePlayer.seek(to: seekTime)
            self.currentTime = time
        }
    }
    
    func setPlaybackRate(_ rate: Float) {
        playbackRate = rate
        audioPlayer?.rate = rate
        remotePlayer?.rate = rate
    }
    
    func debugAudioFiles() {
        print("=== Debug Audio Files ===")
        
        // List all MP3 files in bundle
        if let mp3Files = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) {
            print("MP3 files in root bundle:")
            for file in mp3Files {
                print("  - \(file.lastPathComponent)")
            }
        }
        
        // Check specific subdirectories
        let subdirectories = ["Resources/Audio", "Audio", "Resources"]
        for subdir in subdirectories {
            if let mp3Files = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: subdir) {
                print("MP3 files in \(subdir):")
                for file in mp3Files {
                    print("  - \(file.lastPathComponent)")
                }
            }
        }
        
        // Check bundle resource path
        if let resourcePath = Bundle.main.resourcePath {
            print("Bundle resource path: \(resourcePath)")
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if let audioPlayer = self.audioPlayer {
                self.currentTime = audioPlayer.currentTime
            } else if let remotePlayer = self.remotePlayer,
                      let item = remotePlayer.currentItem,
                      item.status == .readyToPlay {
                self.currentTime = remotePlayer.currentTime().seconds
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func handlePlaybackFinished() {
        isPlaying = false
        currentTime = 0
        stopTimer()
        remotePlayer?.seek(to: .zero)
    }
    
    deinit {
        stopTimer()
    }
}

extension AudioPlayerService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        currentTime = 0
        stopTimer()
        handlePlaybackFinished()
    }
}
