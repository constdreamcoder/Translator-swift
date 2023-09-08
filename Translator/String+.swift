//
//  String+.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/09/08.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
