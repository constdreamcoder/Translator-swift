//
//  APIManager.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/25.
//

import UIKit

enum NetworkError: Error {
    case inputTextEmpty
    case invalidURL
    case invalidRequest
    case requestFailed(Error)
    case invalidData
    case decodingFailed(Error)
    case downloadingFailed(Error)
}

enum HttpMethod {
    case GET
    case POST
    
    var description: String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        }
    }
}

struct APIManager {
//    private let mainURL = "https://translatelanguage.shop"
    private let mainURL = "http://localhost:3000"
    
    func setupURLRequest(
        endPoint: String = "/",
        httpMethod: HttpMethod = .GET,
        headers: [String: String] = [:],
        payload: [String: Any] = [:]
    ) -> URLRequest? {
        
        let url = "\(mainURL)\(endPoint)"
        
        guard let url = URL(string: url) else {
            print("invalidURL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.description
        
        do {
            let body = try JSONSerialization.data(withJSONObject: payload, options: [.fragmentsAllowed])
            request.httpBody = body
            request.allHTTPHeaderFields = headers
            
        } catch {
            print("requestFailed(error)")
            return nil
        }
        
        
        return request
    }
    
}
