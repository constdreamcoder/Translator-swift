//
//  TranslateViewController.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/18.
//

import UIKit

final class TranslateViewController: UIViewController {
    
    private var translateManager = TranslateManager()
    
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
        bottomSection.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeFavouriteStarImage), name: .changeFavouriteStarImage, object: nil)
        
        // 임시
        UserDefaults.standard.set(
            nil, forKey: UserDefaults.Key.historyList.rawValue
        )
        
        UserDefaults.standard.set(
            nil, forKey: UserDefaults.Key.favouriteList.rawValue
        )
        
    }
    
    
    @objc func moveToHistory() {
        print("히스토리 화면으로 이동!!")
        let historyVC = HistoryViewController()
        navigationController?.pushViewController(historyVC, animated: true)
    }
    
    @objc func changeFavouriteStarImage(_ notification: Notification) {
        if let isFavourite = notification.object as? Bool {
            bottomSection.updateFavouriteButton(isFavourite)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    func swapButtonTapped(
        _ sourceLanguageNationalFlagImageView: UIImageView,
        _ sourceLanguageLabel: UILabel,
        _ targetLanguageNationalFlagImageView: UIImageView,
        _ targetLanguageLabel: UILabel
    ) {
        swap(&sourceLanguageNationalFlagImageView.image, &targetLanguageNationalFlagImageView.image)
        swap(&sourceLanguageLabel.text, &targetLanguageLabel.text)
        
        middleSection.updateSourceLangaugeLabel(sourceLanguageLabel.text!)
        bottomSection.updateTargetLangaugeLabel(targetLanguageLabel.text!)
        
        let sourceLanguage = Language.allCases.filter { $0.language == sourceLanguageLabel.text! }[0]
        let targetLanguage = Language.allCases.filter { $0.language == targetLanguageLabel.text! }[0]
        TranslateManager.sourceLanguage = sourceLanguage
        TranslateManager.targetLanguage = targetLanguage
    }
    
    func stackViewTapped(
        _ nationalFlagImageView: UIImageView,
        _ languageLabel: UILabel,
        _ type: Type
    ) {
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
                            nationalFlagImageView.image = UIImage(named: value.nationalFlag)
                            switch type {
                            case .source:
                                weakSelf.middleSection.updateSourceLangaugeLabel(value.language)
                                DispatchQueue.global().async {
                                    TranslateManager.sourceLanguage = value
                                }
                            case .target:
                                weakSelf.bottomSection.updateTargetLangaugeLabel(value.language)
                                DispatchQueue.global().async {
                                    TranslateManager.targetLanguage = value
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
    func clearInputButtonTapped(_ inputTextView: UITextView) {
        inputTextView.text = ""
    }
    
    func translateButtonTapped(_ inputText: String) {
        
        translateManager.translate(inputText) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    weakSelf.bottomSection.updateResultLabel(response.translatedText)
                    weakSelf.bottomSection.updateFavouriteButton()
                    weakSelf.bottomSection.isHidden = false
                }
                
                let newHistoryModel = CustomCellModel(
                    sourceLanguage: TranslateManager.sourceLanguage,
                    targetLanguage: TranslateManager.targetLanguage,
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

extension TranslateViewController: BottomSectionOfTranslateDelegate {
    func copyButtonTapped(_ resultLabelText: String?) {
        print("\(resultLabelText)가 복사되었습니다")
        UIPasteboard.general.string = resultLabelText
    }
    
    func favouriteButtonTapped(_ favouriteButton: UIButton) {
        
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 26, weight: .medium, scale: .large)
        
        if favouriteButton.imageView?.image == UIImage(systemName: "star", withConfiguration: imageConfiguration) {
            
            if var firstOfHistoryList = UserDefaults.standard.historyList.first {
                firstOfHistoryList.isFavourite = true
                UserDefaults.standard.historyList[0] = firstOfHistoryList
                
                UserDefaults.standard.favouriteList = [firstOfHistoryList] + UserDefaults.standard.favouriteList
            } else {
                let newFavourite = CustomCellModel(
                    sourceLanguage: TranslateManager.sourceLanguage,
                    targetLanguage: TranslateManager.targetLanguage,
                    inputText: TranslateManager.inputText,
                    translateText: TranslateManager.translatedText,
                    isFavourite: true
                )
                
                UserDefaults.standard.favouriteList = [newFavourite] + UserDefaults.standard.favouriteList
            }
           
            DispatchQueue.main.async {
                favouriteButton.setImage(UIImage(systemName: "star.fill", withConfiguration: imageConfiguration), for: .normal)
            }
        } else {
            
            if var firstOfHistoryList = UserDefaults.standard.historyList.first  {
                firstOfHistoryList.isFavourite = false
                UserDefaults.standard.historyList[0] = firstOfHistoryList
            }
            
            UserDefaults.standard.favouriteList.removeFirst()
            
            DispatchQueue.main.async {
                favouriteButton.setImage(UIImage(systemName: "star", withConfiguration: imageConfiguration), for: .normal)
            }
        }
    }
}

extension MiddleSectionOfTranslate {
    @objc func playPronumciationSound() {
        print(#function)
    }
    
    
    
    @objc func voiceInputButtonTapped() {
        print(#function)
    }
    
    
}


