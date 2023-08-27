//
//  UserDefaults+.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/27.
//

import Foundation

extension UserDefaults {
    enum Key: String {
        case historyList
        case favouriteList
    }
    
    var historyList: [CustomCellModel] {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaults.Key.historyList.rawValue),
                  let historyList = try? PropertyListDecoder().decode([CustomCellModel].self, from: data) else {
                return []
            }
            return historyList
        }
        set {
            UserDefaults.standard.set(
                try? PropertyListEncoder().encode(newValue),
                forKey: UserDefaults.Key.historyList.rawValue
            )
        }
    }
    
}
