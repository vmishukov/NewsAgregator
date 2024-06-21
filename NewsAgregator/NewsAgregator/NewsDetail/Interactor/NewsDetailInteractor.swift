//
//  NewsDetailInteractor.swift
//  NewsAgregator
//
//  Created by Vladislav Mishukov on 21.06.2024.
//

import Foundation


protocol NewsDetailInteractorProtocol {
    func like(news: NewsDetailData)
    func dislikeNews(with newsID: String)
    func fetchLikedNews() throws -> [String]?
}

final class NewsDetailInteractor: NewsDetailInteractorProtocol {
    
    private let newsService: NewsDetailServiceProtocol
    
    init(newsService: NewsDetailServiceProtocol) {
        self.newsService = newsService
    }
    
    func like(news: NewsDetailData) {
        newsService.like(news: news)
    }
    
    func dislikeNews(with newsID: String) {
        newsService.dislikeNews(with: newsID)
    }
    func fetchLikedNews() throws -> [String]? {
        return try newsService.fetchLikedNews()
    }
}
