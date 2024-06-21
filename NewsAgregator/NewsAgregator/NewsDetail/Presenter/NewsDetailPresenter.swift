//
//  NewsDetailPresenter.swift
//  NewsTestAppInlyIT
//
//  Created by Vladislav Mishukov on 26.04.2024.
//

import Foundation

// MARK: - NewsDetailPresenterProtocol
protocol NewsDetailPresenterProtocol {
    
    var isSelected: Bool { get set }
    func setDetailNews(set: NewsDetailData)
    func likeNews()
    func dislikeNews()
    func viewDidLoad(view: NewsDetailViewProtocol)
}

final class NewsDetailPresenter: NewsDetailPresenterProtocol {
    
    weak var view: NewsDetailViewProtocol?
    
    var isSelected: Bool = false
    
    private let storage = SelectedNewsStorage.shared
    private let interactor: NewsDetailInteractorProtocol
    private var detailedNews: NewsDetailData?
    private var likedNews = [String]()
    
    init(interactor: NewsDetailInteractorProtocol) {
        self.interactor = interactor
    }
    
    func viewDidLoad(view: NewsDetailViewProtocol) {
        self.view = view
        guard let detailedNews = detailedNews else { return }
        loadLikedNews()
        isSelected = checkIfSelected(newsId: detailedNews.articleId)
        
        
        view.setupDetailNews(detailedNews: detailedNews)
    }
    
    func setDetailNews(set: NewsDetailData) {
        self.detailedNews = set
    }
    
    func likeNews() {
        guard let detailedNews = detailedNews else { return }
        interactor.like(news: detailedNews)
    }
    
    func dislikeNews() {
        guard let newsId = detailedNews?.articleId else { return }
        interactor.dislikeNews(with: newsId)
    }
}

private extension NewsDetailPresenter {
    
    func loadLikedNews() {
        do {
            guard let likedNews = try interactor.fetchLikedNews() else { return }
            self.likedNews = likedNews
        } catch {
            print(error)
        }
    }
    func checkIfSelected(newsId: String) -> Bool {
        return likedNews.contains(where: {
            $0 == newsId
        })
    }
}
