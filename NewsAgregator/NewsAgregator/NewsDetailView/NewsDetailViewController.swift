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
    func setupDetailNews(detailedNews: NewsCollectionData)
}

final class NewsDetailViewController: UIViewController {
    //MARK: - presenter
    private var presenter: NewsDetailPresenterProtocol
    //MARK: - UI
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
    private lazy var newsDetailScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isDirectionalLockEnabled = true;
        view.addSubview(scrollView)
        return scrollView
    }()
    private lazy var newsDetailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        newsDetailScrollView.addSubview(imageView)
        return imageView
    }()
    private lazy var newsDetailDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyBold
        newsDetailScrollView.addSubview(label)
        return label
    }()
    private lazy var newsDetailAuthorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyRegular
        newsDetailScrollView.addSubview(label)
        return label
    }()
    private lazy var newsDetailArticleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyBold
        newsDetailScrollView.addSubview(label)
        return label
    }()
    private lazy var newsDetailLinkLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyRegular
        label.textColor = .systemBlue
        label.isCopyingEnabled = true
        newsDetailScrollView.addSubview(label)
        return label
    }()
    //MARK: - init
    init(presenter: NewsDetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupNavBar()
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    //MARK: - navbar setup
    private func setupNavBar() {
        navigationItem.title = "NewsDetail.Title"~
        navigationItem.rightBarButtonItem = newsDetailHeartButton
        
    }
    //MARK: - public func
    func setDetailedNews(_ set: NewsCollectionData) {
        presenter.setDetailNews(set: set)
    }
    // MARK: - OBJC
    @objc
    private func newsDetailHeartButtonClicked(_ sender: UIButton) {
        presenter.isSelected.toggle()
        if presenter.isSelected {
            newsDetailHeartButton.tintColor = .inlyRedUniversal
            presenter.addSelectedNews()
        } else {
            newsDetailHeartButton.tintColor = .inlyBlack
            presenter.deleteSelectedNews()
        }
    }
    //MARK: - ui setup
    private func setupUI() {
        NSLayoutConstraint.activate([
            newsDetailScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsDetailScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            newsDetailScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            newsDetailScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            newsDetailImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newsDetailImageView.topAnchor.constraint(equalTo: newsDetailScrollView.topAnchor),
            
            
            newsDetailArticleLabel.topAnchor.constraint(equalTo: newsDetailImageView.bottomAnchor,constant: 15),
            newsDetailArticleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            newsDetailArticleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            
            newsDetailDescriptionLabel.topAnchor.constraint(equalTo: newsDetailArticleLabel.bottomAnchor,constant: 10),
            newsDetailDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            newsDetailDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            
            newsDetailAuthorLabel.topAnchor.constraint(equalTo: newsDetailDescriptionLabel.bottomAnchor,constant: 10),
            newsDetailAuthorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            newsDetailAuthorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            
            newsDetailLinkLabel.topAnchor.constraint(equalTo: newsDetailAuthorLabel.bottomAnchor,constant: 10),
            newsDetailLinkLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            newsDetailLinkLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            
            newsDetailLinkLabel.bottomAnchor.constraint(equalTo: newsDetailScrollView.bottomAnchor),
        ])
    }
}
// MARK: - NewsDetailViewProtocol
extension NewsDetailViewController: NewsDetailViewProtocol {
    func setupDetailNews(detailedNews: NewsCollectionData) {
        newsDetailDescriptionLabel.text = detailedNews.description
        newsDetailHeartButton.tintColor = presenter.isSelected ? .inlyRedUniversal : .inlyBlack
        newsDetailArticleLabel.text = detailedNews.title
        newsDetailAuthorLabel.text = detailedNews.sourceUrl
        newsDetailLinkLabel.text = detailedNews.link
        newsDetailImageView.image = nil
        if let url = URL(string: detailedNews.imageUrl ?? "") {
            newsDetailImageView.kf.setImage(with: url, placeholder: nil)
        }
    }
}

