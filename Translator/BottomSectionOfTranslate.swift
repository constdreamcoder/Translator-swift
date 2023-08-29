//
//  BottomSectionOfTranslate.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/22.
//

import UIKit

protocol BottomSectionOfTranslateDelegate: AnyObject {
    func favouriteButtonTapped(_ favouriteButton: UIButton)
}

final class BottomSectionOfTranslate: UIView {
    
    weak var delegate: BottomSectionOfTranslateDelegate?
    
    private lazy var targetLangaugeLabel: UILabel = {
        let label = UILabel()
        label.text = TranslateManager().targetLanguage.language
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        label.textColor = UIColor(red: 0, green: 0.2, blue: 0.4, alpha: 1)
        label.tag = 1
        return label
    }()
    
    private lazy var targetLanguagePronunciationPlayButton: UIButton = {
        let button = UIButton()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium, scale: .large)
        button.setImage(UIImage(systemName: "speaker.wave.1", withConfiguration: imageConfiguration), for: .normal)
        button.tintColor = UIColor(red: 0, green: 0.2, blue: 0.4, alpha: 1)
        button.addTarget(self, action: #selector(playPronumciationSound), for: .touchUpInside)
        return button
    }()
    
    private lazy var targetLanguagePronunciationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 12.0
        [
            targetLangaugeLabel,
            targetLanguagePronunciationPlayButton
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .semibold)
        label.text = "¿Hola como estas?"
        label.textColor = UIColor(red: 0.19, green: 0.64, blue: 1, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var resultBaseView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16.0
        return view
    }()
    
    private lazy var copyButton: UIButton = {
        let button = UIButton()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 26, weight: .medium, scale: .large)
        button.setImage(UIImage(systemName: "doc.on.doc", withConfiguration: imageConfiguration), for: .normal)
        button.tintColor = UIColor(red: 0, green: 0.2, blue: 0.4, alpha: 1)
        button.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 26, weight: .medium, scale: .large)
        button.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfiguration), for: .normal)
        button.tintColor = UIColor(red: 0, green: 0.2, blue: 0.4, alpha: 1)
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button = UIButton()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 26, weight: .medium, scale: .large)
        button.setImage(UIImage(systemName: "star", withConfiguration: imageConfiguration), for: .normal)
        button.tintColor = UIColor(red: 0, green: 0.2, blue: 0.4, alpha: 1)
        button.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var micellaneousIconStackView: UIStackView = {
        let stackView = UIStackView()
        [
            copyButton,
            shareButton,
            favouriteButton
        ].forEach { stackView.addArrangedSubview($0) }
        stackView.spacing = 22.0
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        [
            targetLanguagePronunciationStackView,
            resultBaseView,
            resultLabel,
            micellaneousIconStackView
        ].forEach { self.addSubview($0) }
        self.layer.cornerRadius = 16.0
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(_ superUIView: UIView, _ middldSecion: UIView) {
        targetLanguagePronunciationPlayButton.translatesAutoresizingMaskIntoConstraints = false
        targetLanguagePronunciationStackView.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultBaseView.translatesAutoresizingMaskIntoConstraints = false
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        micellaneousIconStackView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        targetLangaugeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: middldSecion.bottomAnchor, constant: 30.0),
            self.leadingAnchor.constraint(equalTo: superUIView.leadingAnchor, constant: 23.0),
            self.trailingAnchor.constraint(equalTo: superUIView.trailingAnchor, constant: -23.0),
            self.bottomAnchor.constraint(equalTo: resultBaseView.bottomAnchor),
            
            targetLanguagePronunciationPlayButton.widthAnchor.constraint(equalToConstant: 28.0),
            targetLanguagePronunciationPlayButton.heightAnchor.constraint(equalTo: targetLanguagePronunciationPlayButton.widthAnchor, multiplier: 1),
            
            targetLanguagePronunciationStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 19.0),
            targetLanguagePronunciationStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22.0),
            
            resultBaseView.topAnchor.constraint(equalTo: targetLanguagePronunciationStackView.bottomAnchor, constant: 20.0),
            resultBaseView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            resultBaseView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            resultBaseView.bottomAnchor.constraint(equalTo: micellaneousIconStackView.bottomAnchor, constant: 22.0),
            
            resultLabel.topAnchor.constraint(equalTo: resultBaseView.topAnchor),
            resultLabel.leadingAnchor.constraint(equalTo: targetLanguagePronunciationStackView.leadingAnchor),
            resultLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22.0),
            
            copyButton.widthAnchor.constraint(equalToConstant: 26.0),
            copyButton.heightAnchor.constraint(equalTo: copyButton.widthAnchor, multiplier: 1.0),
            
            shareButton.widthAnchor.constraint(equalToConstant: 26.0),
            shareButton.heightAnchor.constraint(equalTo: shareButton.widthAnchor, multiplier: 1.0),
            
            favouriteButton.widthAnchor.constraint(equalToConstant: 26.0),
            favouriteButton.heightAnchor.constraint(equalTo: favouriteButton.widthAnchor, multiplier: 1.0),
            
            micellaneousIconStackView.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 50.0),
            micellaneousIconStackView.trailingAnchor.constraint(equalTo: resultLabel.trailingAnchor)
        ])
    }
    
}


// MARK: - UI Update Methods
extension BottomSectionOfTranslate {
    func updateTargetLangaugeLabel(_ targetLanguage: String) {
        targetLangaugeLabel.text = targetLanguage
    }
    
    func updateResultLabel(_ translatedText: String?) {
        resultLabel.text = translatedText
    }
    
    func updateFavouriteButton(_ isFavourite: Bool = false) {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 26, weight: .medium, scale: .large)
        if isFavourite {
            favouriteButton.setImage(UIImage(systemName: "star.fill", withConfiguration: imageConfiguration), for: .normal)
        } else {
            favouriteButton.setImage(UIImage(systemName: "star", withConfiguration: imageConfiguration), for: .normal)
        }
       
    }
}

// MARK: - User Event Methods
private extension BottomSectionOfTranslate {
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
        delegate?.favouriteButtonTapped(favouriteButton)
    }
}
