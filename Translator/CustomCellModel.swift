//
//  CustomCellModel.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/26.
//

import Foundation

struct CustomCellModel: Codable {
    var uuid = UUID()
    let sourceLanguage: Language?
    let targetLanguage: Language?
    let inputText: String?
    let translateText: String?
    var isFavourite: Bool?
    var createdAt = Date()
}
