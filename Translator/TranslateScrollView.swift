//
//  TranslateScrollView.swift
//  Translator
//
//  Created by SUCHAN CHANG on 2023/08/22.
//

import UIKit

final class TranslateScrollView: UIScrollView {
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getContentView() -> UIView {
        return contentView
    }

    func configureUI(_ superUIView: UIView, _ topSection: UIStackView, _ middleSection: UIView, _ bottomSection: UIView) {
        [
            topSection,
            middleSection,
            bottomSection
        ].forEach { contentView.addSubview($0) }
        
        self.addSubview(contentView)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentViewHeightConstraint = contentView.heightAnchor.constraint(equalTo: self.heightAnchor)
        contentViewHeightConstraint.isActive = true
        contentViewHeightConstraint.priority = UILayoutPriority(50)
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superUIView.topAnchor),
            self.leadingAnchor.constraint(equalTo: superUIView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superUIView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superUIView.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
    }
}
