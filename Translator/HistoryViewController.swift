//
//  HistoryViewController.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/18.
//

import UIKit

final class HistoryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "히스토리"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "모두 지우기",
            style: .done,
            target: self,
            action: #selector(clearAllHistoryRecords)
        )
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
    }
    
    @objc func clearAllHistoryRecords() {
        print("히스토리 모두 지우기!!")
    }
}
