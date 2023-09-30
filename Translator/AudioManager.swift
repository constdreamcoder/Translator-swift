//
//  AudioManager.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/30.
//

import Foundation

struct AudioManager {
    func getAudioContent(
        _ text: String = "",
        _ language: Language = .ko,
        _ type: Type,
        completion: @escaping (Result<Data, NetworkError>, Type?) -> Void
    ) {
        
        guard let request = APIManager().setupURLRequest(
            endPoint: "/audio/play",
            httpMethod: .POST,
            headers: [
                "Content-Type": "application/json"
            ],
            payload: [
                "input": [
                    "text": text,
                ],
                "language": language.languageCode
            ]
        ) else {
            completion(.failure(.invalidRequest), nil)
            return
        }
        
        let task = URLSession.shared.downloadTask(with: request) { localURL, response, error in
            
            let successRange = 200..<300
            if let error = error,
               let statusCode = (response as? HTTPURLResponse)?.statusCode,
               successRange.contains(statusCode) {
                completion(.failure(.requestFailed(error)), nil)
                return
            }
            
            guard let localURL = localURL, error == nil else {
                print("Download failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            print("localURL")
            print(localURL)
            
            do {
                switch type {
                case .source:
                    TranslationManager.inputText = text
                case .target:
                    TranslationManager.translatedText = text
                }
                
                let audioData = try Data(contentsOf: localURL)
                completion(.success(audioData), type)
            } catch {
                print("Failed to read downloaded audio data: \(error)")
                completion(.failure(.downloadingFailed(error)), nil)
            }
        }
        
        task.resume()
    }
}
