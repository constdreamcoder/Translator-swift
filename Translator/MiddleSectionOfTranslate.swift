//
//  MiddleSectionOfTranslate.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/22.
//

import UIKit

protocol MiddleSectionOfTranslateDelegate: AnyObject {
    func clearInputButtonTapped(_ inputTextView: UITextView)
    func translateButtonTapped(_ inputText: String)
}

final class MiddleSectionOfTranslate: UIView {
    
    weak var delegate: MiddleSectionOfTranslateDelegate?
    
    private lazy var sourceLangaugeLabel: UILabel = {
        let label = UILabel()
        label.text = "한국"
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        label.textColor = UIColor(red: 0, green: 0.2, blue: 0.4, alpha: 1)
        return label
    }()
    
    private lazy var sourceLanguagePronunciationPlayButton: UIButton = {
        let button = UIButton()
        
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium, scale: .large)
        button.setImage(UIImage(systemName: "speaker.wave.1", withConfiguration: imageConfiguration), for: .normal)
        button.tintColor = UIColor(red: 0, green: 0.2, blue: 0.4, alpha: 1)
        button.addTarget(self, action: #selector(playPronumciationSound), for: .touchUpInside)
        return button
    }()
    
    private lazy var sourceLanguagePronunciationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 12.0
        [
            sourceLangaugeLabel,
            sourceLanguagePronunciationPlayButton
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private lazy var clearInputButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        button.layer.cornerRadius = 0.5 * 39.0
        button.addTarget(self, action: #selector(clearInputButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 20.0, weight: .semibold)
        textView.text = "번역할 내용을 입력해주세요."
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        return textView
    }()
    
    private lazy var voiceInputButton: UIButton = {
        let button = UIButton()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium, scale: .large)
        button.setImage(UIImage(systemName: "mic.fill", withConfiguration: imageConfiguration), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 0, green: 0.2, blue: 0.4, alpha: 1)
        button.layer.cornerRadius = 0.5 * 43.0
        button.addTarget(self, action: #selector(voiceInputButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var translateButton: UIButton = {
        let button = UIButton()
        button.setTitle("번역하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .medium)
        button.backgroundColor = UIColor(red: 1, green: 0.4, blue: 0, alpha: 1)
        button.layer.cornerRadius = 20.0
        button.addTarget(self, action: #selector(translateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        [
            sourceLanguagePronunciationStackView,
            clearInputButton,
            inputTextView,
            voiceInputButton,
            translateButton
        ].forEach { self.addSubview($0) }
        self.layer.cornerRadius = 16.0
        self.backgroundColor = .systemBackground
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(_ superUIView: UIView, _ topSection: UIStackView) {
        sourceLangaugeLabel.translatesAutoresizingMaskIntoConstraints = false
        sourceLanguagePronunciationPlayButton.translatesAutoresizingMaskIntoConstraints = false
        sourceLanguagePronunciationStackView.translatesAutoresizingMaskIntoConstraints = false
        clearInputButton.translatesAutoresizingMaskIntoConstraints = false
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        voiceInputButton.translatesAutoresizingMaskIntoConstraints = false
        translateButton.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        sourceLangaugeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: topSection.bottomAnchor, constant: 22.0),
            self.leadingAnchor.constraint(equalTo: superUIView.leadingAnchor, constant: 23.0),
            self.trailingAnchor.constraint(equalTo: superUIView.trailingAnchor, constant: -23.0),
            self.heightAnchor.constraint(equalToConstant: 250.0),
            
            
            sourceLanguagePronunciationPlayButton.widthAnchor.constraint(equalToConstant: 28.0),
            sourceLanguagePronunciationPlayButton.heightAnchor.constraint(equalTo: sourceLanguagePronunciationPlayButton.widthAnchor, multiplier: 1),
            
            sourceLanguagePronunciationStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22.0),
            sourceLanguagePronunciationStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 19.0),
            
            clearInputButton.centerYAnchor.constraint(equalTo: sourceLanguagePronunciationStackView.centerYAnchor),
            clearInputButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12.0),
            clearInputButton.widthAnchor.constraint(equalToConstant: 39.0),
            clearInputButton.heightAnchor.constraint(equalTo: clearInputButton.widthAnchor, multiplier: 1),
            
            inputTextView.topAnchor.constraint(equalTo: sourceLangaugeLabel.bottomAnchor, constant: 20.0),
            inputTextView.leadingAnchor.constraint(equalTo: sourceLanguagePronunciationStackView.leadingAnchor),
            inputTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22.0),
            inputTextView.heightAnchor.constraint(equalToConstant: 100),
            
            
            voiceInputButton.leadingAnchor.constraint(equalTo: sourceLanguagePronunciationStackView.leadingAnchor),
            voiceInputButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -22.0),
            voiceInputButton.widthAnchor.constraint(equalToConstant: 43.0),
            voiceInputButton.heightAnchor.constraint(equalTo: voiceInputButton.widthAnchor, multiplier: 1.0),
            
            translateButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22.0),
            translateButton.widthAnchor.constraint(equalToConstant: 116.0),
            translateButton.heightAnchor.constraint(equalToConstant: 43.0),
            translateButton.centerYAnchor.constraint(equalTo: voiceInputButton.centerYAnchor)
            
        ])
    }
}

// MARK: - Text Delegate Methods
extension MiddleSectionOfTranslate: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        print(#function)
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print(#function)
        if textView.text.isEmpty {
            textView.text = "번역할 내용을 입력해주세요."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        print(#function)
        if textView.text.isEmpty {
            clearInputButton.isHidden = true
            return
        }
        clearInputButton.isHidden = false
    }
}

// MARK: - UI Update Methods
extension MiddleSectionOfTranslate {
    func updateSourceLangaugeLabel(_ sourceLanguage: String) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.sourceLangaugeLabel.text = sourceLanguage
        }
    }
}

// MARK: - User Event Methods
private extension MiddleSectionOfTranslate {
    @objc func clearInputButtonTapped() {
        print(#function)
        delegate?.clearInputButtonTapped(inputTextView)
    }
    
    @objc func translateButtonTapped() {
        print(#function)
        if !inputTextView.text.isEmpty
            && inputTextView.textColor != nil
            && inputTextView.textColor != UIColor.lightGray {
            delegate?.translateButtonTapped(inputTextView.text)
        }
    }
}
