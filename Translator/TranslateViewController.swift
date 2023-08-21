//
//  TranslateViewController.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/18.
//

import UIKit

class TranslateViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Translate"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "historyIcon"),
            style: .done,
            target: self,
            action: #selector(moveToHistory)
        )
        
    }

    @objc func moveToHistory() {
        print("히스토리 화면으로 이동!!")
        let historyVC = HistoryViewController()
        navigationController?.pushViewController(historyVC, animated: true)
    }

}

