//
//  CustomTableViewCell.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/24.
//

import UIKit

protocol CustomTableViewCellDelegate: AnyObject {
    func favouriteButtonTapped(_ customCellData: CustomCellModel?, _ favouriteStarImageView: UIImageView)
}

final class CustomTableViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"
    var customCellData: CustomCellModel?
    
    var delegate: CustomTableViewCellDelegate?
    
    private lazy var sourceLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationManager.sourceLanguage.language
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        return label
    }()
    
    private lazy var inputTextLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = UIColor(red: 0, green: 0.2, blue: 0.4, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var favouriteStarImageView: UIImageView = {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .large)
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill",withConfiguration: imageConfiguration)
        imageView.tintColor = .systemYellow
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favouriteButtonTapped)))
        return imageView
    }()
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()
    
    private lazy var targetLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationManager.targetLanguage.language
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        return label
    }()
    
    private lazy var translatedTextLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = UIColor(red: 1, green: 0.4, blue: 0, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentContainerView: UIView = {
        let view = UIView()
        [
            sourceLanguageLabel,
            inputTextLabel,
            favouriteStarImageView,
            divider,
            targetLanguageLabel,
            translatedTextLabel
        ].forEach { view.addSubview($0) }
        view.layer.cornerRadius = 20.0
        view.backgroundColor = UIColor(red: 1, green: 0.98, blue: 1, alpha: 1)
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        return view
    }()
    
    private lazy var spacer: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        contentView.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
        [
            contentContainerView,
            spacer
        ].forEach { contentView.addSubview($0) }

        sourceLanguageLabel.translatesAutoresizingMaskIntoConstraints = false
        inputTextLabel.translatesAutoresizingMaskIntoConstraints = false
        favouriteStarImageView.translatesAutoresizingMaskIntoConstraints = false
        divider.translatesAutoresizingMaskIntoConstraints = false
        targetLanguageLabel.translatesAutoresizingMaskIntoConstraints = false
        translatedTextLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        sourceLanguageLabel.setContentHuggingPriority(.required, for: .horizontal)
        sourceLanguageLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            contentContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            contentContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 23.0),
            contentContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -23.0),
            
            sourceLanguageLabel.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 14.0),
            sourceLanguageLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 29.0),
            
            inputTextLabel.topAnchor.constraint(equalTo: sourceLanguageLabel.topAnchor),
            inputTextLabel.leadingAnchor.constraint(equalTo: sourceLanguageLabel.trailingAnchor, constant: 31.0),
            inputTextLabel.trailingAnchor.constraint(equalTo: favouriteStarImageView.leadingAnchor, constant: -10.0),
            
            favouriteStarImageView.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 10.0),
            favouriteStarImageView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -13.0),
            favouriteStarImageView.widthAnchor.constraint(equalToConstant: 24.0),
            favouriteStarImageView.heightAnchor.constraint(equalTo: favouriteStarImageView.widthAnchor, multiplier: 0.8),
            
            divider.topAnchor.constraint(equalTo: inputTextLabel.bottomAnchor, constant: 8.0),
            divider.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 29.0),
            divider.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -29.0),
            divider.heightAnchor.constraint(equalToConstant: 1.0),
            
            targetLanguageLabel.leadingAnchor.constraint(equalTo: sourceLanguageLabel.leadingAnchor),
            targetLanguageLabel.topAnchor.constraint(equalTo: translatedTextLabel.topAnchor),
            
            translatedTextLabel.leadingAnchor.constraint(equalTo: inputTextLabel.leadingAnchor),
            translatedTextLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 8.0),
            translatedTextLabel.trailingAnchor.constraint(equalTo: inputTextLabel.trailingAnchor),
            translatedTextLabel.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -14.0),
            
            spacer.topAnchor.constraint(equalTo: contentContainerView.bottomAnchor),
            spacer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spacer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            spacer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            spacer.heightAnchor.constraint(equalToConstant: 6.0),
            
        ])
    }
    
    func setupCustomCellData() {
        sourceLanguageLabel.text = customCellData?.sourceLanguage?.language
        inputTextLabel.text = customCellData?.inputText
        targetLanguageLabel.text = customCellData?.targetLanguage?.language
        translatedTextLabel.text = customCellData?.translateText
        
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .large)
        guard let isFavourite = customCellData?.isFavourite else { return }
        favouriteStarImageView.image = isFavourite
        ? UIImage(systemName: "star.fill",withConfiguration: imageConfiguration)
        : UIImage(systemName: "star",withConfiguration: imageConfiguration)
    }
}

// MARK: - User Event Methods
private extension CustomTableViewCell {
    @objc func favouriteButtonTapped() {
        print(#function)
        delegate?.favouriteButtonTapped(customCellData, favouriteStarImageView)
    }
}
