//
//  TranslateViewController.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/18.
//

import UIKit

final class TranslateViewController: UIViewController {
    
    // MARK: - Top Section
    private let topSection = TopSectionOfTranslate()
    
    // MARK: - Middle Section
    private let middleSection = MiddleSectionOfTranslate()
    
    // MARK: - Bottom Section
    private let bottomSection = BottomSectionOfTranslate()
    
    // MARK: - Translate UI ScrollView
    private let scrollView = TranslateScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "번역"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "historyIcon"),
            style: .done,
            target: self,
            action: #selector(moveToHistory)
        )
                
        setupViews()
    }
    
    @objc func moveToHistory() {
        print("히스토리 화면으로 이동!!")
        let historyVC = HistoryViewController()
        navigationController?.pushViewController(historyVC, animated: true)
    }
}

private extension TranslateViewController {
    func setupViews() {
        view.addSubview(scrollView)
        
        // MARK: - Configure The Constraints of Translate UI ScrollView
        scrollView.configureUI(view, topSection, middleSection, bottomSection)
        
        // MARK: - Configure The Contraints of Top Section of Translate UI
        topSection.configureUI(scrollView.getContentView())
        
        // MARK: - Configure The Contraints of Middle Section of Translate UI
        middleSection.configureUI(scrollView.getContentView(), topSection)
        
        // MARK: - Configure The Contraints of Bottom Section of Translate UI
        bottomSection.configureUI(scrollView.getContentView(), middleSection)
    }
}

extension TopSectionOfTranslate {
    @objc func swapButtonTapped() {
        print(#function)
    }
}

extension MiddleSectionOfTranslate {
    @objc func playPronumciationSound() {
        print(#function)
    }
    
    @objc func clearInputBUttonTapped() {
        print(#function)
    }
    
    @objc func voiceInputButtonTapped() {
        print(#function)
    }
    
    @objc func translateButtonTapped() {
        print(#function)
    }
}

extension BottomSectionOfTranslate {
    @objc func playPronumciationSound() {
        print(#function)
    }
    
    @objc func copyButtonTapped() {
        print(#function)
    }
    
    @objc func shareButtonTapped() {
        print(#function)
    }
    
    @objc func favouriteButtonTapped() {
        print(#function)
    }
}
    
