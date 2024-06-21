//
//  NewsDetailswift
//  NewsAgregator
//
//  Created by Vladislav Mishukov on 21.06.2024.
//

import Foundation
import UIKit

final class NewsDetailView: UIView {
    //MARK: - UI
    lazy var newsDetailScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isDirectionalLockEnabled = true;
        addSubview(scrollView)
        return scrollView
    }()
    lazy var newsDetailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        newsDetailScrollView.addSubview(imageView)
        return imageView
    }()
    lazy var newsDetailDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyBold
        newsDetailScrollView.addSubview(label)
        return label
    }()
    lazy var newsDetailAuthorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyRegular
        newsDetailScrollView.addSubview(label)
        return label
    }()
    lazy var newsDetailArticleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyBold
        newsDetailScrollView.addSubview(label)
        return label
    }()
    lazy var newsDetailLinkLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyRegular
        label.textColor = .systemBlue
        label.isCopyingEnabled = true
        newsDetailScrollView.addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NewsDetailView {
    
    func setupUI() {
        NSLayoutConstraint.activate([
            newsDetailScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            newsDetailScrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            newsDetailScrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            newsDetailScrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            newsDetailImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            newsDetailImageView.topAnchor.constraint(equalTo: newsDetailScrollView.topAnchor),
            
            
            newsDetailArticleLabel.topAnchor.constraint(equalTo: newsDetailImageView.bottomAnchor,constant: 15),
            newsDetailArticleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            newsDetailArticleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20),
            
            newsDetailDescriptionLabel.topAnchor.constraint(equalTo: newsDetailArticleLabel.bottomAnchor,constant: 10),
            newsDetailDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            newsDetailDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            
            newsDetailAuthorLabel.topAnchor.constraint(equalTo: newsDetailDescriptionLabel.bottomAnchor,constant: 10),
            newsDetailAuthorLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            newsDetailAuthorLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            
            newsDetailLinkLabel.topAnchor.constraint(equalTo: newsDetailAuthorLabel.bottomAnchor,constant: 10),
            newsDetailLinkLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            newsDetailLinkLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            
            newsDetailLinkLabel.bottomAnchor.constraint(equalTo: newsDetailScrollView.bottomAnchor),
        ])
    }
}

