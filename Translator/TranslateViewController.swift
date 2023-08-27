//
//  TranslateViewController.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/18.
//

import UIKit

final class TranslateViewController: UIViewController {
    
    private var translateManager = TranslatorManager()
    
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
        topSection.delegate = self
        middleSection.delegate = self
        
        UserDefaults.standard.set(
            nil, forKey: UserDefaults.Key.historyList.rawValue
        )
    }
    
    
    @objc func moveToHistory() {
        print("히스토리 화면으로 이동!!")
        let historyVC = HistoryViewController()
        navigationController?.pushViewController(historyVC, animated: true)
    }
}

// MARK: - Setup Views
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
        bottomSection.isHidden = true
    }
}

// MARK: - Set up User Events' Behavior
extension TranslateViewController: TopSectionOfTranslateDelegate {
    func stackViewTapped(_ languageLabel: UILabel, _ type: Type) {
        
        let actionSheet = UIAlertController(title: "언어를 골라주세요.", message: nil, preferredStyle: .actionSheet)
        
        Language.allCases.forEach { value in
            actionSheet.addAction(
                UIAlertAction(
                    title: value.language,
                    style: .default,
                    handler: { [weak self] _ in
                        guard let weakSelf = self else { return }
                        print("\(value.language)가 선택되었습니다.")
                       
                        DispatchQueue.main.async {
                            languageLabel.text = value.language
                            switch type {
                            case .source:
                                weakSelf.middleSection.updateSourceLangaugeLabel(value.language)
                                DispatchQueue.global().async {
                                    weakSelf.translateManager.sourceLanguage = value
                                }
                            case .target:
                                weakSelf.bottomSection.updateTargetLangaugeLabel(value.language)
                                DispatchQueue.global().async {
                                    weakSelf.translateManager.targetLanguage = value
                                }
                            }
                        }
                    }
                )
            )
        }
        
        present(actionSheet, animated: true)
    }
    
    
}
extension TranslateViewController: MiddleSectionOfTranslateDelegate {
    func translateButtonTapped(_ inputText: String) {
        translateManager.translate(inputText) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    weakSelf.bottomSection.updateResultLabel(response.translatedText)
                    weakSelf.bottomSection.isHidden = false
                }
                
                let newHistoryModel = CustomCellModel(
                    sourceLanguage: weakSelf.translateManager.sourceLanguage,
                    targetLanguage: weakSelf.translateManager.targetLanguage,
                    inputText: inputText,
                    translateText: response.translatedText,
                    isFavourite: false
                )
                
                UserDefaults.standard.historyList = [newHistoryModel] + UserDefaults.standard.historyList
                dump(UserDefaults.standard.historyList)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
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

