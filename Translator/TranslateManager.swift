//
//  TranslatorManager.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/27.
//

import Foundation

struct TranslateManager {
    static var inputText: String = ""
    static var translatedText: String = ""
    static var sourceLanguage: Language = .ko
    static var targetLanguage: Language = .en
}

extension TranslateManager {
    func translate(
        _ inputText: String = "",
        completion: @escaping (Result<TranslatedText, NetworkError>) -> Void
    ) {
        
        guard let request = APIManager().setupURLRequest(
            endPoint: "/translate",
            httpMethod: .POST,
            headers: [
                "Content-Type": "application/json"
            ], payload: [
                "source": TranslateManager.sourceLanguage.languageCode,
                "target": TranslateManager.targetLanguage.languageCode,
                "text": inputText
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
                
                TranslateManager.inputText = inputText
                TranslateManager.translatedText = response.translatedText ?? ""
                
                completion(.success(response))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }
        
        task.resume()
    }
}
