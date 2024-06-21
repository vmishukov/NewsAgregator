//
//  FavoriteNewsInteractor.swift
//  NewsAgregator
//
//  Created by Vladislav Mishukov on 21.06.2024.
//

import Foundation

protocol FavoriteNewsInteractorDelegate: AnyObject {
    
    func newsDataService(_: any FavoriteNewsInteractorProtocol, like news: FavoriteNewsCollectionData, at indexPath: IndexPath)
    
    func companiesDataServiceDislikeNews(_: any FavoriteNewsInteractorProtocol, at newsId: String)
}

protocol FavoriteNewsInteractorProtocol {
    
    var delegate: FavoriteNewsInteractorDelegate? { get set }
    func fetchLikedNews() throws -> [FavoriteNewsCollectionData]?
    func dislikeNews(with newsID: String)
}

final class FavoriteNewsInteractor: FavoriteNewsInteractorProtocol {
    weak var delegate: (any FavoriteNewsInteractorDelegate)?
    
    var newsService: FavoriteNewsServiceProtocol
    
    init(newsService: FavoriteNewsServiceProtocol) {
        self.newsService = newsService
        self.newsService.delegate = self
    }    
    
    func fetchLikedNews() throws -> [FavoriteNewsCollectionData]? {
        return try newsService.fetchLikedNews()
    }
    
    func dislikeNews(with newsID: String) {
        newsService.dislikeNews(with: newsID)
    }
}

extension FavoriteNewsInteractor: FavoriteNewsDataServiceDelegate {
    
    func newsDataService(_: any FavoriteNewsServiceProtocol, like news: FavoriteNewsCollectionData, at indexPath: IndexPath) {
        delegate?.newsDataService(self, like: news, at: indexPath)
    }
    
    func companiesDataServiceDislikeNews(_: any FavoriteNewsServiceProtocol, at newsId: String) {
        delegate?.companiesDataServiceDislikeNews(self, at: newsId)
    }
}
