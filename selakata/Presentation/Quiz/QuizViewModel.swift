import Foundation
import SwiftUI

@MainActor
class QuizViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswer: Answer? = nil
    @Published var hasAnswered: Bool = false
    @Published var score: Int = 0
    @Published var showResults: Bool = false
    @Published var totalReplayCount: Int = 0

    private let levelUseCase: LevelUseCase
    private let levelId: String
    private let cacheService = AudioCacheService.shared

    @Published var level: Level?
    @Published var questions: [Question] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var downloadProgress: String = ""
    @Published var isDownloadingAudio: Bool = false
    
    private var resultUpdateScore: String = ""

    init(levelUseCase: LevelUseCase, levelId: String) {
        self.levelUseCase = levelUseCase
        self.levelId = levelId
        fetchQuestions()
    }

    func fetchQuestions() {
        isLoading = true
        let selectedVoiceId = UserDefaults.standard.string(forKey: "selectedVoiceID")
        levelUseCase.fetchDetailLevel(levelId: levelId, voiceId: selectedVoiceId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let level):
                    self?.level = level.data
                    self?.questions = level.data.questions as! [Question] ?? []
                    // Download audio files after fetching questions
                    self?.downloadAudioFiles()
                case .failure(let error):
                    self?.isLoading = false
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .typeMismatch(let type, let context):
                            print("❌ Type mismatch for type \(type):", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        case .valueNotFound(let type, let context):
                            print("❌ Value not found for type \(type):", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        case .keyNotFound(let key, let context):
                            print("❌ Missing key '\(key.stringValue)':", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        case .dataCorrupted(let context):
                            print("❌ Data corrupted:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        default:
                            print("❌ Unknown decoding error:", decodingError.localizedDescription)
                        }
                    } else {
                        print("❌ Non-decoding error:", error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func downloadAudioFiles() {
        // Get all audio URLs from questions (main + noise)
        var audioURLs: [String] = []
        
        for question in questions {
            if let mainAudioURL = question.audioFile?.fileURL {
                audioURLs.append(mainAudioURL)
            }
            if let noiseAudioURL = question.noiseFile?.fileURL {
                audioURLs.append(noiseAudioURL)
            }
        }
        
        guard !audioURLs.isEmpty else {
            isLoading = false
            print("⚠️ No audio files to download")
            return
        }
        
        isDownloadingAudio = true
        downloadProgress = "Downloading audio 0/\(audioURLs.count)"
        
        cacheService.downloadMultiple(urls: audioURLs) { [weak self] downloaded, total in
            self?.downloadProgress = "Downloading audio \(downloaded)/\(total)"
        } completion: { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.isDownloadingAudio = false
                
                switch result {
                case .success:
                    print("✅ All audio files (main + noise) downloaded successfully")
                case .failure(let error):
                    print("⚠️ Some audio files failed to download: \(error.localizedDescription)")
                    // Continue anyway, will try to stream if cache fails
                }
            }
        }
    }

    // MARK: - Computed Properties
    var currentQuestion: Question {
        guard !questions.isEmpty && currentQuestionIndex < questions.count else {
            // Return empty question as fallback
            return Question(
                id: "",
                text: "",
                urutan: 0,
                mainRMS: 0,
                noiseRMS: 0,
                isActive: false,
                snr: nil,
                poin: nil,
                type: 0,
                createdAt: "",
                updatedAt: "",
                updatedBy: nil,
                answerList: [],
                audioFile: nil,
                noiseFile: nil
            )
        }
        return questions[currentQuestionIndex]
    }

    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentQuestionIndex + 1) / Double(questions.count)
    }

    var audioFileName: String {
        guard let audioURL = currentQuestion.audioFile?.fileURL else {
            return ""
        }
        
        // Try to get cached URL first
        if let cachedURL = cacheService.getCachedURL(for: audioURL) {
            return cachedURL.path
        }
        
        // Fallback to streaming URL
        return audioURL
    }
    
    var noiseFileName: String? {
        guard let noiseURL = currentQuestion.noiseFile?.fileURL else {
            return nil
        }
        
        // Try to get cached URL first
        if let cachedURL = cacheService.getCachedURL(for: noiseURL) {
            return cachedURL.path
        }
        
        // Fallback to streaming URL
        return noiseURL
    }

    var isLastQuestion: Bool {
        guard !questions.isEmpty else { return true }
        return currentQuestionIndex == questions.count - 1
    }

    var totalQuestions: Int {
        questions.count
    }

    var questionNumber: String {
        guard !questions.isEmpty else { return "Loading..." }
        return "Question \(currentQuestionIndex + 1) of \(questions.count)"
    }

    var scoreText: String {
        guard !questions.isEmpty else { return "Score: 0/0" }
        return "Score: \(score)/\(questions.count)"
    }

    var nextButtonText: String {
        isLastQuestion ? "Finish" : "Next"
    }

    var audioTitle: String {
        currentQuestion.text
    }

    var audioSubdirectory: String {
        return "Resources/Audio"
    }

    // MARK: - Public Methods
    func selectAnswer(_ answer: Answer) {
        selectedAnswer = answer
        hasAnswered = true

        if answer.isCorrect {
            score += 1
        }
    }

    func nextQuestion() {
        if isLastQuestion {
            showQuizResults()
        } else {
            currentQuestionIndex += 1
            selectedAnswer = nil
            hasAnswered = false
        }
    }

    func showQuizResults() {
        showResults = true
        levelUseCase.updateLevelScore(levelId: levelId, score: score){ [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self?.resultUpdateScore = result
                case .failure(let error):
                    print("AISDEBUG: error update - \(error.localizedDescription)")
                }
            }
        }
    }

    func restartQuiz() {
        currentQuestionIndex = 0
        selectedAnswer = nil
        hasAnswered = false
        score = 0
        totalReplayCount = 0
        showResults = false
    }

    func dismissResults() {
        showResults = false
    }
    
    func incrementReplayCount() {
        totalReplayCount += 1
    }
    
    func clearAudioCache() {
        // Optional: Clear cache for this level's audio files
        let audioURLs = questions.compactMap { $0.audioFile?.fileURL }
        for url in audioURLs {
            cacheService.clearCache(for: url)
        }
        print("🗑️ Cleared audio cache for level \(levelId)")
    }
    
    deinit {
        // Optional: Auto-clear cache when quiz is dismissed
        // Uncomment if you want to clear cache automatically
        // Task { @MainActor in
        //     clearAudioCache()
        // }
    }
}
