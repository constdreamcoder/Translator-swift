//
//  Language.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/27.
//

import Foundation

enum Language: String, Codable, CaseIterable {
    case ko
    case en
    case ja
    case zh
    
    var languageCode: String {
        self.rawValue
    }
    
    var languageIdentifier: String {
        switch self {
        case .ko:
            return "ko-KR"
        case .en:
            return "en-US"
        case .ja:
            return "ja-JP"
        case .zh:
            return "cmn-CN"
            
        }
    }
    
    var language: String {
        switch self {
        case .ko:
            return "한국어"
        case .en:
            return "영어"
        case .ja:
            return "일본어"
        case .zh:
            return "중국어"
        }
    }
    
    var nationalFlag: String {
        switch self {
        case .ko:
            return "southKoreaFlag"
        case .en:
            return "unitedStatesFlag"
        case .ja:
            return "japanFlag"
        case .zh:
            return "chinaFlag"
        }
    }
}
