//
//  AudioCacheService.swift
//  selakata
//
//  Created by Kiro on 12/11/25.
//

import Foundation

class AudioCacheService {
    static let shared = AudioCacheService()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        // Create cache directory in app's cache folder
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        cacheDirectory = cachesDirectory.appendingPathComponent("AudioCache", isDirectory: true)
        
        // Create directory if it doesn't exist
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    // MARK: - Public Methods
    
    /// Download audio from URL and cache it
    func downloadAndCache(from urlString: String, completion: @escaping (Result<URL, Error>) -> Void) {
        // Check if already cached
        if let cachedURL = getCachedFileURL(for: urlString), fileExists(at: cachedURL) {
            print("✅ Audio already cached: \(urlString)")
            completion(.success(cachedURL))
            return
        }
        
        // Download from URL
        guard let url = URL(string: urlString) else {
            completion(.failure(AudioCacheError.invalidURL))
            return
        }
        
        print("⬇️ Downloading audio: \(urlString)")
        
        let task = URLSession.shared.downloadTask(with: url) { [weak self] tempURL, response, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let tempURL = tempURL else {
                completion(.failure(AudioCacheError.downloadFailed))
                return
            }
            
            // Move to cache directory
            do {
                let cachedURL = self.getCachedFileURL(for: urlString)!
                
                // Remove existing file if any
                if self.fileExists(at: cachedURL) {
                    try self.fileManager.removeItem(at: cachedURL)
                }
                
                try self.fileManager.moveItem(at: tempURL, to: cachedURL)
                print("✅ Audio cached successfully: \(urlString)")
                completion(.success(cachedURL))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    /// Download multiple audio files
    func downloadMultiple(urls: [String], progress: @escaping (Int, Int) -> Void, completion: @escaping (Result<[URL], Error>) -> Void) {
        var cachedURLs: [URL] = []
        var downloadedCount = 0
        let totalCount = urls.count
        
        let group = DispatchGroup()
        var downloadError: Error?
        
        for urlString in urls {
            group.enter()
            
            downloadAndCache(from: urlString) { result in
                defer { group.leave() }
                
                switch result {
                case .success(let url):
                    cachedURLs.append(url)
                    downloadedCount += 1
                    DispatchQueue.main.async {
                        progress(downloadedCount, totalCount)
                    }
                case .failure(let error):
                    downloadError = error
                }
            }
        }
        
        group.notify(queue: .main) {
            if let error = downloadError {
                completion(.failure(error))
            } else {
                completion(.success(cachedURLs))
            }
        }
    }
    
    /// Get cached file URL if exists
    func getCachedURL(for urlString: String) -> URL? {
        guard let cachedURL = getCachedFileURL(for: urlString),
              fileExists(at: cachedURL) else {
            return nil
        }
        return cachedURL
    }
    
    /// Clear all cached audio files
    func clearAllCache() {
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        print("🗑️ All audio cache cleared")
    }
    
    /// Clear all cached audio files (alias for backward compatibility)
    func clearCache() {
        clearAllCache()
    }
    
    /// Clear specific cached file
    func clearCache(for urlString: String) {
        guard let cachedURL = getCachedFileURL(for: urlString) else { return }
        try? fileManager.removeItem(at: cachedURL)
        print("🗑️ Cleared cache for: \(urlString)")
    }
    
    /// Get cache size in bytes
    func getCacheSize() -> Int64 {
        guard let files = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey]) else {
            return 0
        }
        
        return files.reduce(0) { total, fileURL in
            let fileSize = (try? fileURL.resourceValues(forKeys: [.fileSizeKey]))?.fileSize ?? 0
            return total + Int64(fileSize)
        }
    }
    
    // MARK: - Private Methods
    
    private func getCachedFileURL(for urlString: String) -> URL? {
        // Create a unique filename from URL
        let filename = urlString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
        return cacheDirectory.appendingPathComponent(filename).appendingPathExtension("mp3")
    }
    
    private func fileExists(at url: URL) -> Bool {
        return fileManager.fileExists(atPath: url.path)
    }
}

// MARK: - Error Types
enum AudioCacheError: LocalizedError {
    case invalidURL
    case downloadFailed
    case fileNotFound
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid audio URL"
        case .downloadFailed:
            return "Failed to download audio"
        case .fileNotFound:
            return "Cached audio file not found"
        }
    }
}
