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
            return "Korean".localized
        case .en:
            return "English".localized
        case .ja:
            return "Japanese".localized
        case .zh:
            return "Chinese".localized
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
