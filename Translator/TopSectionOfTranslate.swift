//
//  TopSectionOfTranslate.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/21.
//

import UIKit

protocol TopSectionOfTranslateDelegate: AnyObject {
    func stackViewTapped(_ languageLabel: UILabel, _ type: Type)
}

final class TopSectionOfTranslate: UIStackView {
    
    var delegate: TopSectionOfTranslateDelegate?
    
    // source language
    private lazy var sourceLanguageNationalFlagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "southKorea")
        return imageView
    }()
    
    private lazy var sourceLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "한국어"
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        return label
    }()
    
    private lazy var sourceLanguageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16.0
        stackView.alignment = .center
        stackView.distribution = .fill
        [
            sourceLanguageNationalFlagImageView,
            sourceLanguageLabel
        ].forEach { stackView.addArrangedSubview($0) }
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(sourceStackViewTapped))
        stackView.addGestureRecognizer(tapGR)
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    // swap language
    private lazy var languageSwapButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "swapIcon"), for: .normal)
        button.addTarget(self, action: #selector(swapButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // target language
    private lazy var targetLanguageNationalFlagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "unitedStates")
        return imageView
    }()
    
    private lazy var targetLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "영어"
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        return label
    }()
    
    private lazy var targetLanguageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16.0
        stackView.alignment = .center
        stackView.distribution = .fill
        [
            targetLanguageLabel,
            targetLanguageNationalFlagImageView
        ].forEach { stackView.addArrangedSubview($0) }
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(targetStackViewTapped))
        stackView.addGestureRecognizer(tapGR)
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .equalSpacing
        [
            sourceLanguageStackView,
            languageSwapButton,
            targetLanguageStackView
        ].forEach { self.addArrangedSubview($0) }
        self.layer.cornerRadius = 27.0
        self.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        self.isLayoutMarginsRelativeArrangement = true
        self.backgroundColor = .systemBackground
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(_ superUIView: UIView) {
        sourceLanguageNationalFlagImageView.translatesAutoresizingMaskIntoConstraints = false
        targetLanguageNationalFlagImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sourceLanguageNationalFlagImageView.widthAnchor.constraint(equalToConstant: 32.0),
            sourceLanguageNationalFlagImageView.heightAnchor.constraint(equalTo: sourceLanguageNationalFlagImageView.widthAnchor, multiplier: 1),
            
            targetLanguageNationalFlagImageView.widthAnchor.constraint(equalToConstant: 32.0),
            targetLanguageNationalFlagImageView.heightAnchor.constraint(equalTo: sourceLanguageNationalFlagImageView.widthAnchor, multiplier: 1),
            
            self.topAnchor.constraint(equalTo: superUIView.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            self.leadingAnchor.constraint(equalTo: superUIView.leadingAnchor, constant: 23.0),
            self.trailingAnchor.constraint(equalTo: superUIView.trailingAnchor, constant: -23.0),
            self.heightAnchor.constraint(equalToConstant: 54.0),
        ])
    }
}

private extension TopSectionOfTranslate {
    @objc func sourceStackViewTapped() {
        print(#function)
        delegate?.stackViewTapped(sourceLanguageLabel, .source)
    }
    
    @objc func targetStackViewTapped() {
        print(#function)
        delegate?.stackViewTapped(targetLanguageLabel, .target)
    }
}
