//
//  TranslatedText.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/25.
//

import Foundation

struct TranslatedText: Codable {
    let translatedText: String?
}

struct TranslatedTextManager {
    func translate(inputText: String = "", completion: @escaping (Result<TranslatedText, NetworkError>) -> Void) {
        
        guard let request = APIManager().setupURLRequest(
            endPoint: "/translate",
            httpMethod: .POST,
            headers: [
                "Content-Type": "application/json"
            ], payload: [
                "text": inputText,
                "source": "ko",
                "target": "en"
            ]) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200..<300
            if let error = error,
               let statusCode = (response as? HTTPURLResponse)?.statusCode,
               successRange.contains(statusCode) {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TranslatedText.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }
        
        task.resume()
    }
}
