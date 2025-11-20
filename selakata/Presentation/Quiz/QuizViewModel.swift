import Foundation
import SwiftUI

@MainActor
class QuizViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswer: Answer? = nil
    @Published var hasAnswered: Bool = false
    @Published var correctAnswer: Int = 0
    @Published var showResults: Bool = false
    @Published var totalReplayCount: Int = 0
    
    // Fill in the blank support
    @Published var userTextAnswer: String = ""
    
    // Response time tracking
    private var audioCompletedTime: Date?
    private var responseTimes: [TimeInterval] = []

    private let levelUseCase: LevelUseCase
    private let levelId: String
    private let cacheService = AudioCacheService.shared

    @Published var level: Level?
    @Published var questions: [Question] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var downloadProgress: String = ""
    @Published var isDownloadingAudio: Bool = false
    @Published var isAudioReady: Bool = false
    
    private var resultUpdateScore: String = ""
    private var questionTracker: [QuestionTracker] = []

    init(levelUseCase: LevelUseCase, levelId: String) {
        self.levelUseCase = levelUseCase
        self.levelId = levelId
        
        // Clear cache before fetching new questions
        // print("🗑️ Clearing audio cache before starting quiz")
        // cacheService.clearAllCache()
        
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
                    self?.isAudioReady = true
                case .failure(let error):
                    print("⚠️ Some audio files failed to download: \(error.localizedDescription)")
                    // Continue anyway, will try to stream if cache fails
                    self?.isAudioReady = true
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
        
        // Debug: Print RMS values
        print("📊 Question RMS - Main: \(currentQuestion.mainRMS), Noise: \(currentQuestion.noiseRMS)")
        
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
        return "Score: \(correctAnswer)/\(questions.count)"
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
    
    private var totalScore: Int{
        Int((Double(correctAnswer) / Double(totalQuestions)) * 100)
    }

    // MARK: - Public Methods
    func selectAnswer(_ answer: Answer) {
        selectedAnswer = answer
        hasAnswered = true

        if answer.isCorrect {
            correctAnswer += 1
        }
        
        questionTracker.append(QuestionTracker(questionId: currentQuestion.id, isCorrect: answer.isCorrect))
           
        // Calculate response time
        if let startTime = audioCompletedTime {
            let responseTime = Date().timeIntervalSince(startTime)
            responseTimes.append(responseTime)
            print("⏱️ Response time: \(String(format: "%.2f", responseTime))s")
        }
    }
    
    func submitTextAnswer() {
        hasAnswered = true
        
        // Check if answer is correct (case-insensitive comparison)
        let correctAnswerText = currentQuestion.answerList.first(where: { $0.isCorrect })?.text ?? ""
        let isCorrect = userTextAnswer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == 
                       correctAnswerText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isCorrect {
            correctAnswer += 1
        }
        
        // Calculate response time
        if let startTime = audioCompletedTime {
            let responseTime = Date().timeIntervalSince(startTime)
            responseTimes.append(responseTime)
            print("⏱️ Response time: \(String(format: "%.2f", responseTime))s")
        }
        
        print("📝 Text answer submitted: '\(userTextAnswer)' - Correct: \(isCorrect)")
    }
    
    var isTextAnswerCorrect: Bool {
        let correctAnswerText = currentQuestion.answerList.first(where: { $0.isCorrect })?.text ?? ""
        return userTextAnswer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == 
               correctAnswerText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func startResponseTimer() {
        audioCompletedTime = Date()
        print("⏱️ Started response timer")
    }
    
    var averageResponseTime: Double {
        guard !responseTimes.isEmpty else { return 0.0 }
        let average = responseTimes.reduce(0, +) / Double(responseTimes.count)
        return average
    }
    
    var averageResponseTimeString: String {
        let average = averageResponseTime
        return String(format: "%.1fs", average)
    }

    func nextQuestion() {
        if isLastQuestion {
            showQuizResults()
        } else {
            currentQuestionIndex += 1
            selectedAnswer = nil
            userTextAnswer = ""  // Reset text answer
            hasAnswered = false
            audioCompletedTime = nil // Reset timer for next question
        }
    }

    func showQuizResults() {
        showResults = true
        let updateLevel = UpdateLevel(levelId: levelId, score: totalScore, repetition: totalReplayCount, responseTime: averageResponseTime, questions: questionTracker)
        levelUseCase.updateLevelScore(updateLevel: updateLevel){ [weak self] result in
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
        userTextAnswer = ""  // Reset text answer
        hasAnswered = false
        correctAnswer = 0
        totalReplayCount = 0
        isAudioReady = false
        showResults = false
        audioCompletedTime = nil
        responseTimes = []
        
        // Re-download audio files
        downloadAudioFiles()
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
