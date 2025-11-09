import AVFoundation
import Foundation

class AudioPlayerService: NSObject, ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    private var isSessionSetup = false
    
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var playbackRate: Float = 1.0
    
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
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.enableRate = true
            duration = audioPlayer?.duration ?? 0
            currentTime = 0
        } catch {
            print("Error loading audio from URL: \(error)")
            duration = 30.0
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
        if audioPlayer?.play() == true {
            isPlaying = true
            startTimer()
        } else {
            print("AudioPlayerService: play() failed. Player not ready or file not loaded.")
        }
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        stopTimer()
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPlaying = false
        currentTime = 0
        stopTimer()
    }
    
    func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = time
        currentTime = time
    }
    
    func setPlaybackRate(_ rate: Float) {
        playbackRate = rate
        audioPlayer?.rate = rate
    }
    
    var isReady: Bool {
        return audioPlayer != nil && duration > 0
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
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.currentTime = self.audioPlayer?.currentTime ?? 0
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
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
    }
}