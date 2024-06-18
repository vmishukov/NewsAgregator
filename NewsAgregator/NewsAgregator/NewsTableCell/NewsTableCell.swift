//
//  NewsTableCell.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 24.04.2024.
//

import Foundation
import UIKit
import Kingfisher

protocol NewsTableCellDelegate: AnyObject {
    func likeNewsDidTappedWith(newsId: String)
    func dislikeNewsDidTappedWith(newsId: String)
}

final class NewsTableCell: UITableViewCell {

    weak var delegate: NewsTableCellDelegate?
    
    static let identifier = String(describing: NewsTableCell.self)
    
    private lazy var newsTableCellArticleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        return imageView
    }()
    private lazy var newsTableArticleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    private lazy var newsTableAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyBold
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var newsTableDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption1
        contentView.addSubview(label)
        return label
    }()
    private lazy var newsTableInfoLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(newsTableAuthorLabel)
        stackView.addArrangedSubview(newsTableDateLabel)
        contentView.addSubview(stackView)
        return stackView
    }()
    private lazy var newsTableCellHeartButton: UIButton = {
        let button = UIButton.systemButton(
            with: .inlySuitHeartFill,
            target: self,
            action: #selector(didTapHeartButton)
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        return button
    }()

    private var isLiked = false
    private var newsId = ""

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        withImageSetupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initData(rowData: NewsTableCellData, isSelected: Bool) {
        newsTableCellArticleImage.image = .inlyArticlePlaceholder
        if let url = URL(string: rowData.imageUrl ?? "") {
            newsTableCellArticleImage.kf.setImage(with: url, placeholder: UIImage.inlyArticlePlaceholder)
            newsTableCellArticleImage.isHidden = false
        }
        newsId = rowData.articleId
        isLiked = isSelected
        newsTableCellHeartButton.tintColor = isSelected ? .inlyRedUniversal : .inlyBlack
        newsTableArticleLabel.text = rowData.title
        newsTableAuthorLabel.text = rowData.sourceUrl
        newsTableDateLabel.text = rowData.pubDate
    }

    private func withImageSetupUI() {
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 140),
            newsTableCellArticleImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            newsTableCellArticleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            newsTableCellArticleImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            newsTableCellArticleImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            
            newsTableInfoLabelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            newsTableInfoLabelStackView.leadingAnchor.constraint(equalTo: newsTableCellArticleImage.trailingAnchor, constant: 10),
            newsTableInfoLabelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            newsTableInfoLabelStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25),
            
            newsTableArticleLabel.topAnchor.constraint(equalTo: newsTableCellArticleImage.topAnchor),
            newsTableArticleLabel.leadingAnchor.constraint(equalTo: newsTableCellArticleImage.trailingAnchor, constant: 10),
            newsTableArticleLabel.bottomAnchor.constraint(equalTo: newsTableInfoLabelStackView.topAnchor, constant: -10),
            newsTableArticleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -50),
            
            newsTableCellHeartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            newsTableCellHeartButton.leadingAnchor.constraint(equalTo: newsTableArticleLabel.trailingAnchor),
            newsTableCellHeartButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
        ])
    }

    @objc
    private func didTapHeartButton(_ sender: UIButton) {
        isLiked.toggle()
        if isLiked {
            newsTableCellHeartButton.tintColor = .inlyRedUniversal
            delegate?.likeNewsDidTappedWith(newsId: newsId)
        } else {
            newsTableCellHeartButton.tintColor = .inlyBlack
            delegate?.dislikeNewsDidTappedWith(newsId: newsId)
        }
    }
}
