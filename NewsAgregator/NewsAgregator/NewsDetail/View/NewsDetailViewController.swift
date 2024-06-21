//
//  NewsDetailView.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 25.04.2024.
//

import Foundation
import UIKit
import Kingfisher
import UILabel_Copyable

protocol NewsDetailViewProtocol: AnyObject {
    func setupDetailNews(detailedNews: NewsDetailData)
}

final class NewsDetailViewController: UIViewController {

    private var presenter: NewsDetailPresenterProtocol
    private let contentView = NewsDetailView()

    init(presenter: NewsDetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavBar()
        presenter.viewDidLoad(view: self)
    }
    
    //MARK: - navbar setup
    private lazy var newsDetailHeartButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: .inlySuitHeartFill,
            style: .plain,
            target: self,
            action: #selector(newsDetailHeartButtonClicked)
        )
        
        button.tintColor = .inlyBlack
        return button
    }()
    private func setupNavBar() {
        navigationItem.title = "NewsDetail.Title"~
        navigationItem.rightBarButtonItem = newsDetailHeartButton
    }

    @objc
    private func newsDetailHeartButtonClicked(_ sender: UIButton) {
        presenter.isSelected.toggle()
        if presenter.isSelected {
            newsDetailHeartButton.tintColor = .inlyRedUniversal
            presenter.likeNews()
        } else {
            newsDetailHeartButton.tintColor = .inlyBlack
            presenter.dislikeNews()
        }
    }
}

extension NewsDetailViewController: NewsDetailViewProtocol {
    
    func setupDetailNews(detailedNews: NewsDetailData) {
        contentView.newsDetailDescriptionLabel.text = detailedNews.description
        newsDetailHeartButton.tintColor = presenter.isSelected ? .inlyRedUniversal : .inlyBlack
        contentView.newsDetailArticleLabel.text = detailedNews.title
        contentView.newsDetailAuthorLabel.text = detailedNews.sourceUrl
        contentView.newsDetailLinkLabel.text = detailedNews.link
        contentView.newsDetailImageView.image = nil
        if let url = URL(string: detailedNews.imageUrl ?? "") {
            contentView.newsDetailImageView.kf.setImage(with: url, placeholder: nil)
        }
    }
}

