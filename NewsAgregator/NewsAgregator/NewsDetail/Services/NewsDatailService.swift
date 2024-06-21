//
//  NewsDatailService.swift
//  NewsAgregator
//
//  Created by Vladislav Mishukov on 21.06.2024.
//

import Foundation

protocol NewsDetailServiceProtocol {
    func like(news: NewsDetailData)
    func dislikeNews(with newsID: String)
    func fetchLikedNews() throws -> [String]?
}

final class NewsDatailService: NewsDetailServiceProtocol {
    private let dataStore: NewsDataStoreProtocol
    
    init(dataStore: NewsDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func like(news: NewsDetailData) {
        let newsCoreData = FavoriteNewsCoreData(articleId: news.articleId,
                                                title: news.title,
                                                link: news.link,
                                                sourceUrl: news.sourceUrl,
                                                description: news.description,
                                                content: news.content,
                                                pubDate: news.pubDate,
                                                imageUrl: news.imageUrl)
        do {
            try dataStore.addNews(newsCoreData)
        } catch {
            print(error)
        }
    }
    
    func dislikeNews(with newsID: String) {
        do {
            try dataStore.deleteNews(newsID)
        } catch {
            print(error)
        }
    }
    func fetchLikedNews() throws -> [String]? {
        guard let news = try dataStore.fetchNews() else { return nil }
        let collectionNews = news.map{
            $0.articleId ?? ""
        }
        return collectionNews
    }
}
